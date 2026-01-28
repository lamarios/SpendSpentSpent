package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.RecurringExpenseService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.testcontainers.shaded.org.checkerframework.checker.units.qual.A;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.GregorianCalendar;

import static org.junit.jupiter.api.Assertions.*;


@Import(TestConfig.class)
public class RecurringExpenseControllerTest extends TestContainerTest {

    @Autowired
    private RecurringExpenseService recurringExpenseService;

    @Autowired
    private User currentUser;

    @Autowired
    private CategoryDao categoryDaoJooq;
    @Autowired
    private CategoryDao categoryDao;

    private RecurringExpense create(Category category, double amount, boolean income, String name, int type, int when) throws Exception {
        RecurringExpense exp = new RecurringExpense();

        exp.setCategory(category);


        exp.setAmount(amount);
        exp.setIncome(income);
        exp.setName(name);
        exp.setType(type);
        exp.setTypeParam(when);

        return recurringExpenseService.create(exp, currentUser);
    }

    @Test
    public void createDeleteRecurringExpense() throws Exception {

        int count = recurringExpenseService.get(currentUser).size();

        var categories = categoryDaoJooq.getWhere(currentUser);

        RecurringExpense expense = create(categories.get(0), 10d, false, "spotify", RecurringExpense.TYPE_DAILY, 0);

        int newCount = recurringExpenseService.get(currentUser).size();

        assertEquals(count + 1, newCount);


        assertNotNull(recurringExpenseService.getId(expense.getId(), currentUser));

        recurringExpenseService.delete(expense.getId(), currentUser);
        newCount = recurringExpenseService.get(currentUser).size();

        assertEquals(count, newCount);
    }


    @Test
    public void testNewDateCalculation() {
        //Daily expense
        RecurringExpense expense = new RecurringExpense();
        expense.setType(RecurringExpense.TYPE_DAILY);

        LocalDate today = LocalDate.now();

        LocalDate newDate;
        newDate = recurringExpenseService.calculateNextDate(expense);

        System.out.println(today);
        System.out.println(newDate);

        assertEquals(today.getYear(), newDate.getYear());
        assertEquals(today.getMonth(), newDate.getMonth());
        assertEquals(today.getDayOfMonth(), newDate.getDayOfMonth());

        //Check monthly of non passed date yet
        LocalDate lastPaymentDate = LocalDate.of(1, 3, 1);

        expense.setType(RecurringExpense.TYPE_MONTHLY);
        expense.setTypeParam(1);
        expense.setLastOccurrence(lastPaymentDate);

        newDate = recurringExpenseService.calculateNextDate(expense);

        assertEquals(lastPaymentDate.getYear(), newDate.getYear());
        assertEquals(lastPaymentDate.getMonth().getValue() + 1, newDate.getMonth().getValue());
        assertEquals(lastPaymentDate.getDayOfMonth(), newDate.getDayOfMonth());

        //Check yearly of non passed date yet
        lastPaymentDate = LocalDate.of(1, 1, 1);

        expense.setType(RecurringExpense.TYPE_YEARLY);
        expense.setTypeParam(0);
        expense.setLastOccurrence(lastPaymentDate);

        newDate = recurringExpenseService.calculateNextDate(expense);

        assertEquals(lastPaymentDate.getYear() + 1, newDate.getYear());
        assertEquals(lastPaymentDate.getMonth(), newDate.getMonth());
        assertEquals(lastPaymentDate.getDayOfMonth(), newDate.getDayOfMonth());

        // now trying with no previous expense
        expense.setLastOccurrence(null);
        expense.setTypeParam(today.getMonth()
                .getValue() - 1); // old way was using first month as 0, switching to local date months start at 1
        newDate = recurringExpenseService.calculateNextDate(expense);

        // when no previous expense and we check the current month, we want to add a new expense now so the next expense should be now
        assertEquals(today, newDate);

        // when we're not in the current month of the expense, the next expense should be planned for next year
        LocalDate twoMonthAgo = today.minusMonths(2);
        expense.setTypeParam(twoMonthAgo.getMonth()
                .getValue() - 1); // old way was using first month as 0, switching to local date months start at 1
        newDate = recurringExpenseService.calculateNextDate(expense);
        assertEquals(twoMonthAgo.getMonth(), newDate.getMonth());
        assertEquals(twoMonthAgo.getYear() + 1, newDate.getYear());
        assertEquals(1, newDate.getDayOfMonth());

    }

    @Test
    public void testDateCalculationOnNewRecurringExpenses() {
        RecurringExpense expense = new RecurringExpense();
        expense.setType(RecurringExpense.TYPE_MONTHLY);
        // we want our expense to be on the first of the month
        expense.setTypeParam(1);


        // we set our current date
        LocalDate date = LocalDate.of(2025, 8, 20);


        var nextOccurrence = recurringExpenseService.calculateNextDate(expense, date);

        assertEquals(9, nextOccurrence.getMonth().getValue());
        assertEquals(2025, nextOccurrence.getYear());


    }


}
