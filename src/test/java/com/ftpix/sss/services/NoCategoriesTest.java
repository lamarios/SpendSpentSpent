package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.SearchParameters;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import com.ftpix.sss.utils.TestService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * A user without categories must not see the data of other users.
 */
@Import(TestConfig.class)
public class NoCategoriesTest extends TestContainerTest {

    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private SearchService searchService;

    @Autowired
    private HistoryService historyService;

    @Autowired
    private RecurringExpenseService recurringExpenseService;

    @Autowired
    private RecurringExpenseRepository recurringExpenseRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private TestService testService;

    private User userWithoutCategories;

    @BeforeEach
    public void createDataOfAnotherUser() throws Exception {
        Category house = categoryRepository.findAllByUser(currentUser)
                .stream()
                .filter(c -> c.getIcon().equals("house"))
                .findFirst()
                .orElseThrow();

        Expense expense = new Expense();
        expense.setAmount(1200);
        expense.setCategory(house);
        expense.setDate(LocalDate.now());
        expense.setTimestamp(expense.getDate().atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli());
        expense.setType(Expense.TYPE_NORMAL);
        expense.setNote("Rent");
        expenseService.create(expense, currentUser);
        historyService.refreshMaterializedViews();

        RecurringExpense recurring = new RecurringExpense();
        recurring.setName("Rent");
        recurring.setAmount(1200);
        recurring.setCategory(house);
        recurring.setType(RecurringExpense.TYPE_MONTHLY);
        recurring.setTypeParam(1);
        recurring.setNextOccurrence(LocalDate.now());
        recurringExpenseRepository.save(recurring);

        userWithoutCategories = testService.create("nocategories@example.org", false);
    }

    @AfterEach
    public void deleteRecurringExpenses() {
        recurringExpenseRepository.deleteAll();
    }

    @Test
    public void searchFindsNothing() {
        SearchParameters everything = new SearchParameters(List.of(), -1, -1, null, null, "");

        assertTrue(searchService.search(userWithoutCategories, everything, ZoneId.systemDefault()).isEmpty());
    }

    @Test
    public void searchParametersDontShowOtherAmounts() throws Exception {
        SearchParameters parameters = searchService.getSearchParameters(userWithoutCategories, null);

        assertEquals(0, parameters.minAmount());
        assertEquals(0, parameters.maxAmount());
    }

    @Test
    public void historyIsEmpty() {
        List<Map<String, Object>> history = new ArrayList<>();
        history.addAll(historyService.getMonthlyHistory(-1, 12, userWithoutCategories));
        history.addAll(historyService.getYearlyHistory(-1, 2, userWithoutCategories));

        history.forEach(entry -> assertEquals(0, ((Number) entry.get("amount")).doubleValue(), entry.toString()));
    }

    @Test
    public void noRecurringExpensesToProcess() throws Exception {
        assertTrue(recurringExpenseService.getToProcessForUser(userWithoutCategories).isEmpty());
    }
}
