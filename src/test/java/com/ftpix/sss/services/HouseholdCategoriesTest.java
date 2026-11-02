package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.controllers.BackgroundJob;
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

import java.time.LocalDate;
import java.util.ArrayList;
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

        backgroundJob.assignMissingOwners();

        assertEquals(currentUser.getId(), expenseRepository.findById(expense.getId()).orElseThrow().getUser().getId());
        assertEquals(currentUser.getId(), recurringExpenseRepository.findById(recurring.getId()).orElseThrow().getUser().getId());
    }
}
