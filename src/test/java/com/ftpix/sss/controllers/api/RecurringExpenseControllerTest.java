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
        LocalDate lastPaymentDate = LocalDate.of(1,3,1);

        expense.setType(RecurringExpense.TYPE_MONTHLY);
        expense.setTypeParam(1);
        expense.setLastOccurrence(lastPaymentDate);

        newDate = recurringExpenseService.calculateNextDate(expense);

        assertEquals(lastPaymentDate.getYear(), newDate.getYear());
        assertEquals(lastPaymentDate.getMonth().getValue() + 1, newDate.getMonth().getValue());
        assertEquals(lastPaymentDate.getDayOfMonth(), newDate.getDayOfMonth());

        //Check yearly of non passed date yet
        lastPaymentDate = LocalDate.of(1,3,1);

        expense.setType(RecurringExpense.TYPE_YEARLY);
        expense.setTypeParam(3);
        expense.setLastOccurrence(lastPaymentDate);

        newDate = recurringExpenseService.calculateNextDate(expense);

        assertEquals(lastPaymentDate.getYear() + 1, newDate.getYear());
        assertEquals(lastPaymentDate.getMonth(), newDate.getMonth());
        assertEquals(lastPaymentDate.getDayOfMonth(), newDate.getDayOfMonth());
    }


}
