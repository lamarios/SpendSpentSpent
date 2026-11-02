package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.controllers.BackgroundJob;
import com.ftpix.sss.controllers.api.SearchController;
import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.utils.MockEmailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletResponse;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Categories and recurring expenses are shared within a household while expenses keep track of who created them.
 */
@Import(TestConfig.class)
public class HouseholdCategoriesTest extends TestContainerTest {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private HouseholdService householdService;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private ExpenseService expenseService;
    @Autowired
    private RecurringExpenseService recurringExpenseService;
    @Autowired
    private ExpenseRepository expenseRepository;
    @Autowired
    private RecurringExpenseRepository recurringExpenseRepository;
    @Autowired
    private BackgroundJob backgroundJob;
    @Autowired
    private EmailService emailService;
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private UserService userService;
    @Autowired
    private JsonMapper jsonMapper;
    @Autowired
    private SearchController searchController;
    @Autowired
    private com.fasterxml.jackson.databind.ObjectMapper legacyObjectMapper;

    // currentUser is the household admin and owns the base categories (house, cloud, cloth)
    private User partner;
    private User outsider;

    @BeforeEach
    public void setUpHousehold() {
        partner = createUser("partner");
        outsider = createUser("outsider");

        Household hs = householdService.createHousehold(currentUser);
        householdService.inviteUser(currentUser, partner.getEmail());
        householdService.acceptInvitation(partner, hs);
    }

    private User createUser(String name) {
        User user = new User();
        user.setEmail(name + System.nanoTime() + "@test.com");
        user.setFirstName(name);
        user.setLastName("test");
        return userRepository.save(user);
    }

    private Category ownCategory(User user, String icon) throws Exception {
        return categoryService.getAll(user)
                .stream()
                .filter(c -> c.getIcon().equals(icon))
                .findFirst()
                .orElseThrow();
    }

    private Expense newExpense(Category category, double amount) {
        Expense expense = new Expense();
        expense.setCategory(category);
        expense.setAmount(amount);
        return expense;
    }

    /**
     * Mimics what a client sends back when editing an expense without attachments.
     */
    private Expense detached(Expense expense) {
        Expense edit = expenseRepository.findById(expense.getId()).orElseThrow();
        edit.setFiles(new ArrayList<>());
        return edit;
    }

    private RecurringExpense newRecurring(Category category, double amount, String name) {
        RecurringExpense expense = new RecurringExpense();
        expense.setCategory(category);
        expense.setAmount(amount);
        expense.setName(name);
        expense.setType(RecurringExpense.TYPE_MONTHLY);
        expense.setTypeParam(1);
        return expense;
    }

    @Test
    public void membersShareCategories() throws Exception {
        List<String> partnerIcons = categoryService.getAll(partner).stream().map(Category::getIcon).toList();
        assertEquals(List.of("house", "cloud", "cloth").stream().sorted().toList(), partnerIcons.stream().sorted().toList());

        // a category created by the partner is visible to everyone in the household
        Category food = categoryService.create("food", partner);
        assertNotNull(categoryService.get(food.getId(), currentUser));
        assertEquals(4, categoryService.getAll(currentUser).size());

        // new categories go after the existing household ones
        assertTrue(categoryService.getAll(currentUser)
                .stream()
                .filter(c -> !c.getId().equals(food.getId()))
                .allMatch(c -> c.getCategoryOrder() < food.getCategoryOrder()));

        // icons used by any member are no longer available
        assertTrue(categoryService.getAvailable(partner)
                .values()
                .stream()
                .flatMap(List::stream)
                .noneMatch(icon -> icon.name().equalsIgnoreCase("house") || icon.name().equalsIgnoreCase("food")));
        assertThrows(Exception.class, () -> categoryService.create("house", partner));

        // outsiders see none of it
        assertTrue(categoryService.getAll(outsider).isEmpty());
        assertNull(categoryService.get(food.getId(), outsider));
    }

    @Test
    public void expensesKeepTheirCreator() throws Exception {
        Category house = ownCategory(currentUser, "house");

        Expense partnerExpense = expenseService.create(newExpense(house, 25), partner);
        Expense myExpense = expenseService.create(newExpense(house, 10), currentUser);

        assertEquals(partner.getId(), expenseRepository.findById(partnerExpense.getId()).orElseThrow().getUser().getId());
        assertEquals(currentUser.getId(), expenseRepository.findById(myExpense.getId()).orElseThrow().getUser().getId());

        // the delete warning counts every expense of the category
        assertEquals(2, categoryService.countExpenses(house.getId(), partner));
        assertEquals(2L, categoryService.countEveryExpenses(currentUser).get(house.getId()));

        // only the creator can see/edit/delete an expense directly
        assertNull(expenseService.get(partnerExpense.getId(), currentUser));
        assertFalse(expenseService.delete(partnerExpense.getId(), currentUser));

        Expense edit = detached(partnerExpense);
        edit.setAmount(99);
        assertNull(expenseService.update(edit, currentUser));

        edit = detached(partnerExpense);
        edit.setAmount(30);
        edit.setUser(null); // clients never send the creator
        Expense updated = expenseService.update(edit, partner);
        assertEquals(30, updated.getAmount());
        assertEquals(partner.getId(), expenseRepository.findById(partnerExpense.getId()).orElseThrow().getUser().getId());

        assertTrue(expenseService.delete(partnerExpense.getId(), partner));
        assertEquals(1, categoryService.countExpenses(house.getId(), currentUser));
    }

    @Test
    public void expensesCannotUseCategoriesOutsideTheHousehold() throws Exception {
        Category outsiderCategory = categoryService.create("food", outsider);
        Category house = ownCategory(currentUser, "house");

        assertThrows(Exception.class, () -> expenseService.create(newExpense(outsiderCategory, 10), partner));

        // moving an expense to a category outside the household is rejected
        Expense expense = expenseService.create(newExpense(house, 10), partner);
        Expense edit = detached(expense);
        edit.setCategory(outsiderCategory);
        assertNull(expenseService.update(edit, partner));
        assertEquals(house.getId(), expenseRepository.findById(expense.getId()).orElseThrow().getCategory().getId());

        assertNull(recurringExpenseService.create(newRecurring(outsiderCategory, 10, "nope"), partner));
    }

    @Test
    public void anyMemberCanEditButOnlyCreatorOrAdminCanDelete() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Category partnerCategory = categoryService.create("food", partner);
        Category otherPartnerCategory = categoryService.create("gas", partner);

        // edits are allowed for every member
        Category diff = new Category();
        diff.setIcon("books");
        diff.setCategoryOrder(42);
        assertTrue(categoryService.mergeCategory(house.getId(), diff, partner));
        assertEquals("books", categoryService.get(house.getId(), currentUser).getIcon());

        // a non admin member can't delete somebody else's category
        assertFalse(categoryService.delete(house.getId(), partner));
        assertNotNull(categoryService.get(house.getId(), partner));

        // the creator can
        assertTrue(categoryService.delete(partnerCategory.getId(), partner));
        assertNull(categoryService.get(partnerCategory.getId(), currentUser));

        // household admins can delete any household category
        assertTrue(categoryService.delete(otherPartnerCategory.getId(), currentUser));
        assertNull(categoryService.get(otherPartnerCategory.getId(), partner));

        // outsiders can't touch anything
        assertFalse(categoryService.delete(house.getId(), outsider));
        assertFalse(categoryService.mergeCategory(house.getId(), diff, outsider));
    }

    @Test
    public void recurringExpensesAreSharedAndProcessedOnceForTheirCreator() throws Exception {
        Category house = ownCategory(currentUser, "house");

        RecurringExpense rent = recurringExpenseService.create(newRecurring(house, 800, "rent"), partner);
        assertEquals(partner.getId(), rent.getUser().getId());

        // everyone in the household sees and manages it
        assertEquals(1, recurringExpenseService.get(currentUser).size());
        assertTrue(recurringExpenseService.get(outsider).isEmpty());

        RecurringExpense edit = recurringExpenseRepository.findById(rent.getId()).orElseThrow();
        edit.setAmount(850);
        edit.setName("rent 2026");
        edit.setUser(null); // clients never send the creator
        assertTrue(recurringExpenseService.update(edit, currentUser));
        RecurringExpense updated = recurringExpenseRepository.findById(rent.getId()).orElseThrow();
        assertEquals(850, updated.getAmount());
        assertEquals("rent 2026", updated.getName());
        assertEquals(partner.getId(), updated.getUser().getId());

        assertFalse(recurringExpenseService.update(updated, outsider));

        // make it due and let the background job run
        updated.setNextOccurrence(LocalDate.now().minusDays(1));
        recurringExpenseRepository.save(updated);

        assertTrue(recurringExpenseService.getToProcessForUser(currentUser).isEmpty());
        assertEquals(1, recurringExpenseService.getToProcessForUser(partner).size());

        MockEmailService mails = (MockEmailService) emailService;
        mails.getEmails().clear();
        backgroundJob.run();

        List<Expense> generated = expenseService.getAll(partner);
        assertEquals(1, generated.size());
        assertEquals(850, generated.get(0).getAmount());
        assertEquals(Expense.TYPE_RECURRENT, generated.get(0).getType());
        assertTrue(expenseService.getAll(currentUser).isEmpty());

        // only the creator gets the report
        assertEquals(1, mails.getEmails().size());
        assertEquals(partner.getEmail(), mails.getEmails().peek().email());

        // already processed, a second run doesn't duplicate it
        backgroundJob.run();
        assertEquals(1, expenseService.getAll(partner).size());

        assertTrue(recurringExpenseService.delete(rent.getId(), currentUser));
        assertTrue(recurringExpenseService.get(partner).isEmpty());
    }

    @Test
    public void entriesWithoutCreatorAreAssignedToTheCategoryOwner() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Expense expense = expenseService.create(newExpense(house, 10), partner);
        RecurringExpense recurring = recurringExpenseService.create(newRecurring(house, 10, "legacy"), partner);

        // simulate rows written by a version that didn't know about the creator
        jdbcTemplate.update("UPDATE expense SET user_id = NULL WHERE id = ?", expense.getId());
        jdbcTemplate.update("UPDATE recurring_expense SET user_id = NULL WHERE id = ?", recurring.getId());

        backgroundJob.repairOwnership();

        assertEquals(currentUser.getId(), expenseRepository.findById(expense.getId()).orElseThrow().getUser().getId());
        assertEquals(currentUser.getId(), recurringExpenseRepository.findById(recurring.getId()).orElseThrow().getUser().getId());
    }

    /**
     * Sets up the situation the separation has to deal with: each member booked an expense and a recurring expense on
     * the other one's category.
     */
    private record CrossBookings(Category myCategory, Category partnerCategory, Expense partnerOnMine,
                                 Expense mineOnPartner, RecurringExpense partnerRecurringOnMine) {
    }

    private CrossBookings crossBook() throws Exception {
        Category myCategory = ownCategory(currentUser, "house");
        Category partnerCategory = categoryService.create("food", partner);
        return new CrossBookings(myCategory, partnerCategory,
                expenseService.create(newExpense(myCategory, 25), partner),
                expenseService.create(newExpense(partnerCategory, 10), currentUser),
                recurringExpenseService.create(newRecurring(myCategory, 800, "rent"), partner));
    }

    private Category categoryOf(Expense expense) {
        return expenseRepository.findById(expense.getId()).orElseThrow().getCategory();
    }

    private void assertSeparated(CrossBookings bookings) throws Exception {
        // the partner's entries moved to a new "house" category of their own
        Category partnerHouse = categoryOf(bookings.partnerOnMine());
        assertEquals("house", partnerHouse.getIcon());
        assertEquals(partner.getId(), partnerHouse.getUser().getId());
        assertNotEquals(bookings.myCategory().getId(), partnerHouse.getId());

        RecurringExpense rent = recurringExpenseRepository.findById(bookings.partnerRecurringOnMine().getId()).orElseThrow();
        assertEquals(partnerHouse.getId(), rent.getCategory().getId());
        assertEquals(partner.getId(), rent.getUser().getId());

        // my expense on the partner's category moved to a new "food" category of mine
        Category myFood = categoryOf(bookings.mineOnPartner());
        assertEquals("food", myFood.getIcon());
        assertEquals(currentUser.getId(), myFood.getUser().getId());

        // nobody sees anything of the other one anymore
        assertTrue(categoryService.getAll(currentUser).stream().allMatch(c -> c.getUser().getId().equals(currentUser.getId())));
        assertTrue(categoryService.getAll(partner).stream().allMatch(c -> c.getUser().getId().equals(partner.getId())));
        assertTrue(expenseService.getFromTo(currentUser, true, 0, Long.MAX_VALUE, true)
                .stream()
                .allMatch(e -> e.getUser().getId().equals(currentUser.getId())));
        assertEquals(List.of(25d), expenseService.getFromTo(partner, true, 0, Long.MAX_VALUE, true)
                .stream()
                .map(Expense::getAmount)
                .toList());
        assertTrue(recurringExpenseService.get(currentUser).isEmpty());
        assertEquals(1, recurringExpenseService.get(partner).size());

        // nothing was lost
        assertEquals(2, expenseRepository.count());
    }

    @Test
    public void leavingTheHouseholdSeparatesEntries() throws Exception {
        CrossBookings bookings = crossBook();
        assertTrue(householdService.leaveHousehold(partner));
        assertSeparated(bookings);
    }

    @Test
    public void removingAMemberSeparatesEntries() throws Exception {
        CrossBookings bookings = crossBook();
        householdService.removeMember(currentUser, partner);
        assertSeparated(bookings);
    }

    @Test
    public void deletingTheHouseholdSeparatesEntries() throws Exception {
        CrossBookings bookings = crossBook();
        householdService.deleteHousehold(currentUser);
        assertSeparated(bookings);
    }

    @Test
    public void separationReusesExistingCategoriesWithTheSameIcon() throws Exception {
        CrossBookings bookings = crossBook();
        // the first separation creates a "food" category for me
        householdService.leaveHousehold(partner);
        Category myFood = categoryOf(bookings.mineOnPartner());

        // the partner joins again: both of us now own a "food" category in the same household.
        // I book on the partner's one, the partner leaves again: my existing "food" category is reused
        householdService.inviteUser(currentUser, partner.getEmail());
        householdService.acceptInvitation(partner, householdService.getCurrentHousehold(currentUser).orElseThrow());
        Expense again = expenseService.create(newExpense(bookings.partnerCategory(), 5), currentUser);
        householdService.leaveHousehold(partner);

        assertEquals(myFood.getId(), categoryOf(again).getId());
    }

    @Test
    public void deletingAUserKeepsTheOtherMembersExpenses() throws Exception {
        CrossBookings bookings = crossBook();

        assertTrue(userService.deleteUser(partner.getId().toString(), currentUser));

        // the partner's data is gone
        assertTrue(expenseRepository.findById(bookings.partnerOnMine().getId()).isEmpty());
        assertTrue(recurringExpenseRepository.findById(bookings.partnerRecurringOnMine().getId()).isEmpty());
        assertNull(categoryService.get(bookings.partnerCategory().getId(), currentUser));

        // mine survived on a new category of mine
        Category myFood = categoryOf(bookings.mineOnPartner());
        assertEquals("food", myFood.getIcon());
        assertEquals(currentUser.getId(), myFood.getUser().getId());
        assertNotNull(categoryService.get(bookings.myCategory().getId(), currentUser));
    }

    @Test
    public void clientsSeeTheCreatorAsCategoryUser() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Expense created = expenseService.create(newExpense(house, 25), partner);
        Expense expense = expenseRepository.findById(created.getId()).orElseThrow();
        expense.setFiles(new ArrayList<>());

        // HTTP responses (Jackson 3) and the legacy mapper (Jackson 2) behave the same
        JsonNode json = jsonMapper.readTree(jsonMapper.writeValueAsString(expense));
        com.fasterxml.jackson.databind.JsonNode legacyJson = legacyObjectMapper.readTree(legacyObjectMapper.writeValueAsString(expense));

        for (String categoryUserId : List.of(json.get("category").get("user").get("id").asString(), legacyJson.get("category").get("user").get("id").asText())) {
            assertEquals(partner.getId().toString(), categoryUserId);
        }
        assertEquals(house.getId().longValue(), json.get("category").get("id").asLong());
        assertEquals("house", json.get("category").get("icon").asString());
        assertEquals(partner.getId().toString(), json.get("user").get("id").asString());

        // the entity itself still points to the real owner
        assertEquals(currentUser.getId(), expenseRepository.findById(created.getId()).orElseThrow().getCategory().getUser().getId());

        // what the app sends back when editing: the category is resolved by id, the creator can't be overridden
        String fromApp = "{\"id\":" + created.getId() + ",\"amount\":30,\"timestamp\":" + expense.getTimestamp()
                + ",\"category\":{\"id\":" + house.getId() + ",\"icon\":\"house\",\"user\":{\"id\":\"" + partner.getId() + "\"}},"
                + "\"user\":{\"id\":\"" + currentUser.getId() + "\"},\"files\":[]}";
        Expense parsed = jsonMapper.readValue(fromApp, Expense.class);
        assertEquals(house.getId(), parsed.getCategory().getId());
        assertNull(parsed.getUser());

        expenseService.update(parsed, partner);
        Expense saved = expenseRepository.findById(created.getId()).orElseThrow();
        assertEquals(30, saved.getAmount());
        assertEquals(partner.getId(), saved.getUser().getId());
        assertEquals(currentUser.getId(), saved.getCategory().getUser().getId());
    }

    @Test
    public void iconsStayUniqueWhenEditing() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Category gas = categoryService.create("gas", partner);

        Category diff = new Category();
        diff.setIcon("house");
        assertThrows(IllegalArgumentException.class, () -> categoryService.mergeCategory(gas.getId(), diff, partner));
        assertThrows(IllegalArgumentException.class, () -> categoryService.update(gas.getId(), "house", 0, partner));

        // saving the list as the client has it (icons unchanged) works, reordering included
        List<Category> list = new ArrayList<>(categoryService.getAll(partner));
        Collections.reverse(list);
        for (int i = 0; i < list.size(); i++) {
            list.get(i).setCategoryOrder(i);
        }
        assertEquals(list.stream().map(Category::getId).toList(),
                categoryService.updateMany(list, partner).stream().map(Category::getId).toList());

        // changing an icon to one used by another household category fails
        Category clash = new Category();
        clash.setId(gas.getId());
        clash.setIcon("HOUSE");
        assertThrows(IllegalArgumentException.class, () -> categoryService.updateMany(List.of(clash), partner));
        assertEquals("gas", categoryService.get(gas.getId(), partner).getIcon());
        assertEquals("house", categoryService.get(house.getId(), partner).getIcon());
    }

    @Test
    public void outdatedCategoryListsAreSaved() throws Exception {
        Category outsiderCategory = categoryService.create("food", outsider);
        List<Category> list = new ArrayList<>(categoryService.getAll(partner));
        // e.g. a category of a member who left in the meantime
        list.add(outsiderCategory);
        list.forEach(c -> c.setCategoryOrder(7));

        categoryService.updateMany(list, partner);

        assertTrue(categoryService.getAll(partner).stream().allMatch(c -> c.getCategoryOrder() == 7));
        // the category outside the household is left untouched
        assertEquals(1, categoryService.get(outsiderCategory.getId(), outsider).getCategoryOrder());
    }

    @Test
    public void categoryReferencesWithoutIdAreRejected() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Category noId = new Category();
        noId.setIcon("house");

        assertThrows(Exception.class, () -> expenseService.create(newExpense(noId, 10), partner));
        assertNull(recurringExpenseService.create(newRecurring(noId, 10, "nope"), partner));

        Expense expense = expenseService.create(newExpense(house, 10), partner);
        Expense edit = detached(expense);
        edit.setCategory(noId);
        assertNull(expenseService.update(edit, partner));

        RecurringExpense recurring = recurringExpenseService.create(newRecurring(house, 10, "rent"), partner);
        RecurringExpense recurringEdit = recurringExpenseRepository.findById(recurring.getId()).orElseThrow();
        recurringEdit.setCategory(noId);
        assertFalse(recurringExpenseService.update(recurringEdit, partner));
    }

    @Test
    public void filteringByCreatorRequiresAUser() {
        assertThrows(NullPointerException.class, () -> recurringExpenseService.getToProcessForUser(null));
        assertThrows(NullPointerException.class, () -> expenseService.getFromTo(null, false, 0, Long.MAX_VALUE, true));
    }

    @Test
    public void startupSeparatesEntriesLeftAcrossHouseholds() throws Exception {
        CrossBookings bookings = crossBook();

        // the partner left while an older version, which doesn't separate entries, was running
        jdbcTemplate.update("DELETE FROM household_members WHERE user_id = ?", partner.getId().toString());

        backgroundJob.repairOwnership();

        assertSeparated(bookings);
    }

    @Test
    public void csvExportNamesTheCreator() throws Exception {
        Category house = ownCategory(currentUser, "house");
        expenseService.create(newExpense(house, 25), partner);
        expenseService.create(newExpense(house, 10), currentUser);

        MockHttpServletResponse response = new MockHttpServletResponse();
        searchController.searchAsCsv(new SearchParameters(new ArrayList<>(), 0, 9999999, null, null, null), response, "");

        List<String> lines = response.getContentAsString().lines().skip(1).toList();
        assertEquals(2, lines.size());
        assertTrue(lines.stream().anyMatch(l -> l.contains(",25.0,") && l.endsWith("," + partner.getEmail())), lines.toString());
        assertTrue(lines.stream().anyMatch(l -> l.contains(",10.0,") && l.endsWith("," + currentUser.getEmail())), lines.toString());
    }
}
