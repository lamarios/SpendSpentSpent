package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.controllers.BackgroundJob;
import com.ftpix.sss.controllers.api.SearchController;
import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.FilesRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.utils.MockEmailService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import com.ftpix.sss.websockets.WebSocketSessionManager;
import org.mockito.ArgumentCaptor;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

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
    private CategoryRepository categoryRepository;
    @Autowired
    private FilesRepository filesRepository;
    @Autowired
    private HouseholdLocks householdLocks;
    @PersistenceContext
    private EntityManager entityManager;
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
    private PlatformTransactionManager transactionManager;
    @Autowired
    private HistoryService historyService;
    @Autowired
    private SearchService searchService;
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
    public void backgroundJobDoesntHoldTheHouseholdLockWhileSendingReports() throws Exception {
        RecurringExpense rent = recurringExpenseService.create(newRecurring(ownCategory(currentUser, "house"), 800, "rent"), partner);
        rent.setNextOccurrence(LocalDate.now().minusDays(1));
        recurringExpenseRepository.save(rent);

        // e.g. a slow mail server: a category change, which needs the exclusive lock, must not wait for it
        List<Boolean> lockFreeWhileSending = new CopyOnWriteArrayList<>();
        ExecutorService executor = Executors.newSingleThreadExecutor();
        MockEmailService mails = (MockEmailService) emailService;
        mails.setOnSend(() -> {
            Future<?> exclusive = executor.submit(() -> new TransactionTemplate(transactionManager)
                    .executeWithoutResult(status -> householdLocks.exclusive()));
            try {
                exclusive.get(5, TimeUnit.SECONDS);
                lockFreeWhileSending.add(true);
            } catch (TimeoutException e) {
                lockFreeWhileSending.add(false);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        try {
            backgroundJob.run();
        } finally {
            mails.setOnSend(null);
            executor.shutdownNow();
        }

        assertFalse(lockFreeWhileSending.isEmpty());
        assertTrue(lockFreeWhileSending.stream().allMatch(free -> free), lockFreeWhileSending.toString());
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

    /**
     * Older versions don't check icons within the household, the category is saved as they would.
     */
    private Category duplicateCategory(User user, String icon) {
        Category category = new Category();
        category.setIcon(icon);
        return categoryRepository.saveAtEndOfHousehold(category, user);
    }

    @Test
    public void separationReusesExistingCategoriesWithTheSameIcon() throws Exception {
        CrossBookings bookings = crossBook();
        // I already own a "food" category, e.g. created by an older version
        Category myFood = duplicateCategory(currentUser, "food");

        householdService.leaveHousehold(partner);

        assertEquals(myFood.getId(), categoryOf(bookings.mineOnPartner()).getId());
    }

    @Test
    public void joiningMergesCategoriesWithTheSameIcon() throws Exception {
        Category myHouse = ownCategory(currentUser, "house");
        Category partnerFood = categoryService.create("food", partner);

        // the outsider has their own categories and entries before joining
        Category outsiderHouse = categoryService.create("house", outsider);
        Category outsiderFood = categoryService.create("food", outsider);
        Category outsiderCar = categoryService.create("car", outsider);
        Expense rent = expenseService.create(newExpense(outsiderHouse, 800), outsider);
        Expense lunch = expenseService.create(newExpense(outsiderFood, 12), outsider);
        RecurringExpense insurance = recurringExpenseService.create(newRecurring(outsiderHouse, 50, "insurance"), outsider);

        householdService.inviteUser(currentUser, outsider.getEmail());
        householdService.acceptInvitation(outsider, householdService.getCurrentHousehold(currentUser).orElseThrow());

        // the admin's category is kept, then the oldest one. Unique icons stay as they are
        List<Category> categories = categoryService.getAll(outsider);
        assertEquals(List.of("car", "cloth", "cloud", "food", "house"), categories.stream().map(Category::getIcon).sorted().toList());
        assertEquals(List.of(myHouse.getId(), partnerFood.getId(), outsiderCar.getId()).stream().sorted().toList(),
                categories.stream()
                        .filter(c -> List.of("house", "food", "car").contains(c.getIcon()))
                        .map(Category::getId)
                        .sorted()
                        .toList());
        assertTrue(categoryRepository.findById(outsiderHouse.getId()).isEmpty());
        assertTrue(categoryRepository.findById(outsiderFood.getId()).isEmpty());

        // the entries moved and keep their creator
        assertEquals(myHouse.getId(), categoryOf(rent).getId());
        assertEquals(outsider.getId(), expenseRepository.findById(rent.getId()).orElseThrow().getUser().getId());
        assertEquals(partnerFood.getId(), categoryOf(lunch).getId());
        RecurringExpense movedInsurance = recurringExpenseRepository.findById(insurance.getId()).orElseThrow();
        assertEquals(myHouse.getId(), movedInsurance.getCategory().getId());
        assertEquals(outsider.getId(), movedInsurance.getUser().getId());

        // leaving again gives the outsider their entries back
        householdService.leaveHousehold(outsider);
        Category outsiderHouseAgain = categoryOf(rent);
        assertEquals("house", outsiderHouseAgain.getIcon());
        assertEquals(outsider.getId(), outsiderHouseAgain.getUser().getId());
        assertEquals(outsiderHouseAgain.getId(), recurringExpenseRepository.findById(insurance.getId()).orElseThrow().getCategory().getId());
        assertEquals("food", categoryOf(lunch).getIcon());
        assertEquals(outsider.getId(), categoryOf(lunch).getUser().getId());
    }

    @Test
    public void memberLeftWithoutCategoriesSeesNoDataOfOthers() throws Exception {
        expenseService.create(newExpense(ownCategory(currentUser, "house"), 1200), currentUser);
        // the outsider's only category is merged into mine, they leave again without booking anything
        categoryService.create("house", outsider);
        householdService.inviteUser(currentUser, outsider.getEmail());
        householdService.acceptInvitation(outsider, householdService.getCurrentHousehold(currentUser).orElseThrow());
        householdService.leaveHousehold(outsider);

        assertTrue(categoryService.getAll(outsider).isEmpty());
        assertTrue(searchService.search(outsider, new SearchParameters(List.of(), -1, -1, null, null, ""), ZoneId.systemDefault()).isEmpty());
        historyService.getMonthlyHistory(-1, 1, outsider)
                .forEach(month -> assertEquals(0, ((Number) month.get("amount")).doubleValue()));
        historyService.getYearlyHistory(-1, 1, outsider)
                .forEach(year -> assertEquals(0, ((Number) year.get("amount")).doubleValue()));
    }

    @Test
    public void startupMergesCategoriesWithTheSameIcon() throws Exception {
        Category myHouse = ownCategory(currentUser, "house");
        // the household was created before categories were shared, both members have a "house" category
        Category partnerHouse = duplicateCategory(partner, "house");
        Expense partnerExpense = expenseService.create(newExpense(partnerHouse, 30), partner);
        RecurringExpense partnerRecurring = recurringExpenseService.create(newRecurring(partnerHouse, 20, "cleaning"), partner);

        backgroundJob.repairOwnership();

        assertTrue(categoryRepository.findById(partnerHouse.getId()).isEmpty());
        assertEquals(myHouse.getId(), categoryOf(partnerExpense).getId());
        assertEquals(partner.getId(), expenseRepository.findById(partnerExpense.getId()).orElseThrow().getUser().getId());
        assertEquals(myHouse.getId(), recurringExpenseRepository.findById(partnerRecurring.getId()).orElseThrow().getCategory().getId());
        assertEquals(1, categoryService.getAll(partner).stream().filter(c -> c.getIcon().equals("house")).count());

        // nothing left to merge
        backgroundJob.repairOwnership();
        assertEquals(myHouse.getId(), categoryOf(partnerExpense).getId());
    }

    @Test
    public void amongAdminsTheOldestCategoryIsKept() throws Exception {
        householdService.setAdmin(currentUser, partner, true);
        Category partnerFood = categoryService.create("food", partner);
        Category myFood = duplicateCategory(currentUser, "food");
        Expense mine = expenseService.create(newExpense(myFood, 5), currentUser);

        backgroundJob.repairOwnership();

        assertTrue(categoryRepository.findById(myFood.getId()).isEmpty());
        assertEquals(partnerFood.getId(), categoryOf(mine).getId());
        assertEquals(currentUser.getId(), expenseRepository.findById(mine.getId()).orElseThrow().getUser().getId());
    }

    @Test
    public void mergingKeepsTheEntriesOfAnAlreadyLoadedCategory() throws Exception {
        Category myHouse = ownCategory(currentUser, "house");
        Category partnerHouse = duplicateCategory(partner, "house");

        SSSFile receipt = new SSSFile();
        receipt.setUser(partner);
        receipt.setFileName("receipt.png");
        receipt.setStatus(AiProcessingStatus.NO_PROCESSING);
        receipt = filesRepository.save(receipt);
        Expense expense = newExpense(partnerHouse, 30);
        expense.setFiles(new ArrayList<>(List.of(receipt)));
        expense = expenseService.create(expense, partner);
        RecurringExpense recurring = recurringExpenseService.create(newRecurring(partnerHouse, 20, "cleaning"), partner);

        // something earlier in the transaction loaded the entries of the category being merged
        new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
            householdLocks.exclusive();
            entityManager.createQuery("from Category c left join fetch c.expenses where c.id = :id", Category.class)
                    .setParameter("id", partnerHouse.getId())
                    .getSingleResult();
            entityManager.createQuery("from Category c left join fetch c.recurringExpenses where c.id = :id", Category.class)
                    .setParameter("id", partnerHouse.getId())
                    .getSingleResult();
            backgroundJob.repairOwnership();
        });

        assertTrue(categoryRepository.findById(partnerHouse.getId()).isEmpty());
        assertEquals(myHouse.getId(), categoryOf(expense).getId());
        assertEquals(myHouse.getId(), recurringExpenseRepository.findById(recurring.getId()).orElseThrow().getCategory().getId());
        assertEquals(expense.getId(), filesRepository.findById(receipt.getId()).orElseThrow().getExpense().getId());
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
    public void clientsSeeTheCreatorOfRecurringExpensesAsCategoryUser() throws Exception {
        Category house = ownCategory(currentUser, "house");
        RecurringExpense created = recurringExpenseService.create(newRecurring(house, 800, "rent"), partner);
        RecurringExpense recurring = recurringExpenseService.get(currentUser).get(0);

        JsonNode json = jsonMapper.readTree(jsonMapper.writeValueAsString(recurring));
        com.fasterxml.jackson.databind.JsonNode legacyJson = legacyObjectMapper.readTree(legacyObjectMapper.writeValueAsString(recurring));
        for (String categoryUserId : List.of(json.get("category").get("user").get("id").asString(), legacyJson.get("category").get("user").get("id").asText())) {
            assertEquals(partner.getId().toString(), categoryUserId);
        }
        assertEquals(house.getId().longValue(), json.get("category").get("id").asLong());

        // what the app sends back when editing
        String fromApp = "{\"id\":" + created.getId() + ",\"name\":\"rent\",\"amount\":900,\"type\":2,\"typeParam\":1,"
                + "\"category\":{\"id\":" + house.getId() + ",\"icon\":\"house\",\"user\":{\"id\":\"" + partner.getId() + "\"}}}";
        RecurringExpense parsed = jsonMapper.readValue(fromApp, RecurringExpense.class);
        assertTrue(recurringExpenseService.update(parsed, currentUser));
        RecurringExpense saved = recurringExpenseRepository.findById(created.getId()).orElseThrow();
        assertEquals(900, saved.getAmount());
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
    public void categoriesCanSwapTheirIconsInOneList() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Category gas = categoryService.create("gas", partner);

        Category houseToGas = new Category();
        houseToGas.setId(house.getId());
        houseToGas.setIcon("gas");
        houseToGas.setCategoryOrder(1);
        Category gasToHouse = new Category();
        gasToHouse.setId(gas.getId());
        gasToHouse.setIcon("house");
        gasToHouse.setCategoryOrder(0);
        categoryService.updateMany(List.of(houseToGas, gasToHouse), partner);

        assertEquals("gas", categoryService.get(house.getId(), partner).getIcon());
        assertEquals("house", categoryService.get(gas.getId(), partner).getIcon());
    }

    @Test
    public void editingACategoryOutsideTheHouseholdIsRejected() throws Exception {
        Category outsiderCategory = categoryService.create("food", outsider);

        IllegalArgumentException error = assertThrows(IllegalArgumentException.class,
                () -> categoryService.update(outsiderCategory.getId(), "gas", 0, partner));
        assertEquals("Category doesn't exist", error.getMessage());
        assertEquals("food", categoryService.get(outsiderCategory.getId(), outsider).getIcon());
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
    public void createdEntriesIgnoreTheIdSentByTheClient() throws Exception {
        Category outsiderCategory = categoryService.create("food", outsider);
        RecurringExpense outsiderRecurring = recurringExpenseService.create(newRecurring(outsiderCategory, 10, "outsider"), outsider);

        Category stolenCategory = new Category();
        stolenCategory.setId(outsiderCategory.getId());
        stolenCategory.setIcon("gas");
        Category created = categoryService.create(stolenCategory, partner);
        assertNotEquals(outsiderCategory.getId(), created.getId());

        RecurringExpense stolenRecurring = newRecurring(ownCategory(partner, "house"), 99, "partner");
        stolenRecurring.setId(outsiderRecurring.getId());
        RecurringExpense createdRecurring = recurringExpenseService.create(stolenRecurring, partner);
        assertNotEquals(outsiderRecurring.getId(), createdRecurring.getId());

        // the outsider's entries are untouched
        Category category = categoryRepository.findById(outsiderCategory.getId()).orElseThrow();
        assertEquals(outsider.getId(), category.getUser().getId());
        assertEquals("food", category.getIcon());
        RecurringExpense recurring = recurringExpenseRepository.findById(outsiderRecurring.getId()).orElseThrow();
        assertEquals(outsider.getId(), recurring.getUser().getId());
        assertEquals(outsiderCategory.getId(), recurring.getCategory().getId());
        assertEquals(10, recurring.getAmount());
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

    /**
     * Runs the action in its own transaction on another thread and keeps the transaction open until released.
     */
    private class OpenTransaction<T> implements AutoCloseable {
        private final ExecutorService executor = Executors.newSingleThreadExecutor();
        private final CountDownLatch done = new CountDownLatch(1);
        private final CountDownLatch release = new CountDownLatch(1);
        private final Future<T> result;

        OpenTransaction(Callable<T> action) throws InterruptedException {
            result = executor.submit(() -> new TransactionTemplate(transactionManager).execute(status -> {
                try {
                    T value = action.call();
                    done.countDown();
                    assertTrue(release.await(15, TimeUnit.SECONDS));
                    return value;
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }));
            assertTrue(done.await(15, TimeUnit.SECONDS), "the action didn't complete");
        }

        T commit() throws Exception {
            release.countDown();
            return result.get(20, TimeUnit.SECONDS);
        }

        @Override
        public void close() {
            release.countDown();
            executor.shutdownNow();
        }
    }

    private <T> Future<T> inBackground(ExecutorService executor, Callable<T> action) {
        return executor.submit(action);
    }

    @Test
    public void leavingWaitsForRunningBookings() throws Exception {
        Category house = ownCategory(currentUser, "house");
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try (OpenTransaction<Expense> booking = new OpenTransaction<>(() -> expenseService.create(newExpense(house, 123), partner))) {
            Future<Boolean> leaving = inBackground(executor, () -> householdService.leaveHousehold(partner));

            // the separation must not run before the booking is committed
            assertThrows(TimeoutException.class, () -> leaving.get(1, TimeUnit.SECONDS));

            Expense saved = booking.commit();
            assertTrue(leaving.get(20, TimeUnit.SECONDS));

            Category moved = categoryOf(saved);
            assertEquals(partner.getId(), moved.getUser().getId());
            assertEquals("house", moved.getIcon());
            assertTrue(expenseService.getFromTo(currentUser, true, 0, Long.MAX_VALUE, true).isEmpty());
            assertEquals(1, expenseService.getFromTo(partner, true, 0, Long.MAX_VALUE, true).size());
        } finally {
            executor.shutdownNow();
        }
    }

    @Test
    public void leavingWaitsForRunningDeletions() throws Exception {
        Category house = ownCategory(currentUser, "house");
        Expense expense = expenseService.create(newExpense(house, 10), partner);
        RecurringExpense recurring = recurringExpenseService.create(newRecurring(house, 20, "rent"), partner);
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try (OpenTransaction<Boolean> deleting = new OpenTransaction<>(() -> {
            boolean deleted = expenseService.delete(expense.getId(), partner) && recurringExpenseService.delete(recurring.getId(), partner);
            expenseRepository.flush();
            return deleted;
        })) {
            Future<Boolean> leaving = inBackground(executor, () -> householdService.leaveHousehold(partner));

            // the separation would try to move the deleted entries
            assertThrows(TimeoutException.class, () -> leaving.get(1, TimeUnit.SECONDS));

            assertTrue(deleting.commit());
            assertTrue(leaving.get(20, TimeUnit.SECONDS));

            assertTrue(householdService.getCurrentHousehold(partner).isEmpty());
            assertTrue(expenseRepository.findById(expense.getId()).isEmpty());
            assertTrue(recurringExpenseRepository.findById(recurring.getId()).isEmpty());
        } finally {
            executor.shutdownNow();
        }
    }

    @Test
    public void bookingAfterLeavingCannotUseTheFormerHouseholdCategories() throws Exception {
        Category house = ownCategory(currentUser, "house");
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try (OpenTransaction<Boolean> leaving = new OpenTransaction<>(() -> householdService.leaveHousehold(partner))) {
            Future<Expense> booking = inBackground(executor, () -> expenseService.create(newExpense(house, 123), partner));

            assertThrows(TimeoutException.class, () -> booking.get(1, TimeUnit.SECONDS));
            assertTrue(leaving.commit());

            // once the partner left, the category isn't theirs to use anymore
            ExecutionException error = assertThrows(ExecutionException.class, () -> booking.get(20, TimeUnit.SECONDS));
            assertEquals("Category doesn't exist", error.getCause().getMessage());
        } finally {
            executor.shutdownNow();
        }
    }

    @Test
    public void concurrentMembersCannotCreateTheSameIcon() throws Exception {
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try (OpenTransaction<Category> first = new OpenTransaction<>(() -> categoryService.create("food", currentUser))) {
            Future<Category> second = inBackground(executor, () -> categoryService.create("food", partner));

            assertThrows(TimeoutException.class, () -> second.get(1, TimeUnit.SECONDS));
            first.commit();

            ExecutionException error = assertThrows(ExecutionException.class, () -> second.get(20, TimeUnit.SECONDS));
            assertInstanceOf(IllegalArgumentException.class, error.getCause());
            assertEquals(1, categoryService.getAll(partner).stream().filter(c -> c.getIcon().equals("food")).count());
        } finally {
            executor.shutdownNow();
        }
    }

    @Test
    public void leavingMemberCannotEditTheFormerHouseholdCategories() throws Exception {
        Category house = ownCategory(currentUser, "house");
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try (OpenTransaction<Boolean> leaving = new OpenTransaction<>(() -> householdService.leaveHousehold(partner))) {
            Category diff = new Category();
            diff.setIcon("food");
            Future<Boolean> edit = inBackground(executor, () -> categoryService.mergeCategory(house.getId(), diff, partner));

            // the access check must wait until the membership change is done
            assertThrows(TimeoutException.class, () -> edit.get(1, TimeUnit.SECONDS));
            assertTrue(leaving.commit());

            assertFalse(edit.get(20, TimeUnit.SECONDS));
            assertEquals("house", categoryService.get(house.getId(), currentUser).getIcon());
        } finally {
            executor.shutdownNow();
        }
    }

    @Test
    public void bookingsDontBlockEachOther() throws Exception {
        Category house = ownCategory(currentUser, "house");
        try (OpenTransaction<Expense> booking = new OpenTransaction<>(() -> expenseService.create(newExpense(house, 1), partner))) {
            // would time out if bookings took exclusive locks
            assertNotNull(expenseService.create(newExpense(house, 2), currentUser));
            booking.commit();
        }
        assertEquals(2, categoryService.countExpenses(house.getId(), currentUser));
    }

    @Test
    public void categoryChangesNotifyTheOtherMembersAfterCommit() throws Exception {
        WebSocketSession partnerSession = mock(WebSocketSession.class);
        when(partnerSession.isOpen()).thenReturn(true);
        WebSocketSession mySession = mock(WebSocketSession.class);
        when(mySession.isOpen()).thenReturn(true);
        WebSocketSessionManager.register(partner.getId().toString(), partnerSession);
        WebSocketSessionManager.register(currentUser.getId().toString(), mySession);
        try {
            Category food = categoryService.create("food", currentUser);
            categoryService.update(food.getId(), "gas", 5, currentUser);
            // a whole list counts as one change
            categoryService.updateMany(categoryService.getAll(currentUser), currentUser);
            assertTrue(categoryService.delete(food.getId(), currentUser));

            ArgumentCaptor<TextMessage> messages = ArgumentCaptor.forClass(TextMessage.class);
            verify(partnerSession, times(4)).sendMessage(messages.capture());
            // older clients only understand the existing message types
            assertTrue(messages.getAllValues().stream().allMatch(m -> m.getPayload().contains("\"householdUpdate\"")), messages.getAllValues().toString());
            verify(mySession, never()).sendMessage(any());

            // nothing is sent when the change is rolled back
            reset(partnerSession);
            when(partnerSession.isOpen()).thenReturn(true);
            assertThrows(Exception.class, () -> new TransactionTemplate(transactionManager).executeWithoutResult(status -> {
                try {
                    categoryService.create("books", currentUser);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
                throw new IllegalStateException("rollback");
            }));
            verify(partnerSession, never()).sendMessage(any());
        } finally {
            WebSocketSessionManager.remove(partner.getId().toString(), partnerSession);
            WebSocketSessionManager.remove(currentUser.getId().toString(), mySession);
        }
    }

    @Test
    public void recurringExpenseChangesNotifyTheOtherMembersAfterCommit() throws Exception {
        Category house = ownCategory(currentUser, "house");
        WebSocketSession partnerSession = mock(WebSocketSession.class);
        when(partnerSession.isOpen()).thenReturn(true);
        WebSocketSession mySession = mock(WebSocketSession.class);
        when(mySession.isOpen()).thenReturn(true);
        WebSocketSessionManager.register(partner.getId().toString(), partnerSession);
        WebSocketSessionManager.register(currentUser.getId().toString(), mySession);
        try {
            RecurringExpense rent = recurringExpenseService.create(newRecurring(house, 800, "rent"), currentUser);
            rent.setAmount(850);
            assertTrue(recurringExpenseService.update(rent, currentUser));
            assertTrue(recurringExpenseService.delete(rent.getId(), currentUser));

            ArgumentCaptor<TextMessage> messages = ArgumentCaptor.forClass(TextMessage.class);
            verify(partnerSession, times(3)).sendMessage(messages.capture());
            // the clients reload the recurring expenses on this message
            assertTrue(messages.getAllValues().stream().allMatch(m -> m.getPayload().contains("\"householdUpdate\"")), messages.getAllValues().toString());
            verify(mySession, never()).sendMessage(any());

            // nothing changes, nothing is sent
            reset(partnerSession);
            when(partnerSession.isOpen()).thenReturn(true);
            assertFalse(recurringExpenseService.delete(rent.getId(), currentUser));
            verify(partnerSession, never()).sendMessage(any());
        } finally {
            WebSocketSessionManager.remove(partner.getId().toString(), partnerSession);
            WebSocketSessionManager.remove(currentUser.getId().toString(), mySession);
        }
    }

    @Test
    public void membersAreNotifiedOfExpensesOnceTheHistoryIsUpToDate() throws Exception {
        Category house = ownCategory(currentUser, "house");
        // the client reloads the history as soon as it gets the message
        List<Double> monthTotalWhenNotified = new CopyOnWriteArrayList<>();
        WebSocketSession partnerSession = mock(WebSocketSession.class);
        when(partnerSession.isOpen()).thenReturn(true);
        doAnswer(invocation -> monthTotalWhenNotified.add(monthTotal(partner))).when(partnerSession).sendMessage(any());
        WebSocketSessionManager.register(partner.getId().toString(), partnerSession);
        try {
            Expense expense = expenseService.create(newExpense(house, 42), currentUser);
            assertEquals(List.of(42.0), monthTotalWhenNotified);

            assertTrue(expenseService.delete(expense.getId(), currentUser));
            assertEquals(List.of(42.0, 0.0), monthTotalWhenNotified);
        } finally {
            WebSocketSessionManager.remove(partner.getId().toString(), partnerSession);
        }
    }

    @Test
    public void failingNotificationsDontFailCommittedChanges() throws Exception {
        Category house = ownCategory(currentUser, "house");
        WebSocketSession broken = mock(WebSocketSession.class);
        when(broken.isOpen()).thenReturn(true);
        // e.g. Tomcat when a message is sent while another one is still being sent
        doThrow(new IllegalStateException("TEXT_FULL_WRITING")).when(broken).sendMessage(any());
        WebSocketSession working = mock(WebSocketSession.class);
        when(working.isOpen()).thenReturn(true);
        WebSocketSessionManager.register(partner.getId().toString(), broken);
        WebSocketSessionManager.register(partner.getId().toString(), working);
        try {
            Expense saved = expenseService.create(newExpense(house, 42), currentUser);

            assertNotNull(saved.getId());
            assertEquals(1, expenseRepository.count());
            verify(working, times(1)).sendMessage(any());
        } finally {
            WebSocketSessionManager.remove(partner.getId().toString(), broken);
            WebSocketSessionManager.remove(partner.getId().toString(), working);
        }
    }

    private double monthTotal(User user) throws Exception {
        return historyService.monthly(user).stream()
                .filter(c -> c.getCategory().getId() == -1L)
                .findFirst()
                .orElseThrow()
                .getAmount();
    }

    /**
     * Known limitation, to be addressed with client support (a version sent along with categories): the client always
     * sends the whole category list, an outdated list overwrites icon changes made by another member in the meantime.
     */
    @Test
    public void outdatedListOverwritesIconChangesOfOthers() throws Exception {
        Category house = ownCategory(currentUser, "house");
        List<Category> outdated = categoryService.getAll(partner);

        categoryService.update(house.getId(), "food", house.getCategoryOrder(), currentUser);
        categoryService.updateMany(outdated, partner);

        assertEquals("house", categoryService.get(house.getId(), currentUser).getIcon());
    }
}
