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

        GregorianCalendar today = new GregorianCalendar();

        GregorianCalendar newDate = new GregorianCalendar();
        newDate.setTime(recurringExpenseService.calculateNextDate(expense));

        System.out.println(today);
        System.out.println(newDate);

        assertEquals(today.get(Calendar.YEAR), newDate.get(Calendar.YEAR));
        assertEquals(today.get(Calendar.MONTH), newDate.get(Calendar.MONTH));
        assertEquals(today.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));

        //Check monthly of non passed date yet
        GregorianCalendar lastPaymentDate = new GregorianCalendar();
        lastPaymentDate.add(Calendar.YEAR, 1);
        lastPaymentDate.set(Calendar.MONTH, 3);
        lastPaymentDate.set(Calendar.DAY_OF_MONTH, 1);

        expense.setType(RecurringExpense.TYPE_MONTHLY);
        expense.setTypeParam(1);
        expense.setLastOccurrence(lastPaymentDate.getTime());

        newDate.setTime(recurringExpenseService.calculateNextDate(expense));

        assertEquals(lastPaymentDate.get(Calendar.YEAR), newDate.get(Calendar.YEAR));
        assertEquals(lastPaymentDate.get(Calendar.MONTH) + 1, newDate.get(Calendar.MONTH));
        assertEquals(lastPaymentDate.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));

        //Check yearly of non passed date yet
        lastPaymentDate = new GregorianCalendar();
        lastPaymentDate.add(Calendar.YEAR, 1);
        lastPaymentDate.set(Calendar.MONTH, 3);
        lastPaymentDate.set(Calendar.DAY_OF_MONTH, 1);

        expense.setType(RecurringExpense.TYPE_YEARLY);
        expense.setTypeParam(3);
        expense.setLastOccurrence(lastPaymentDate.getTime());

        newDate.setTime(recurringExpenseService.calculateNextDate(expense));

        assertEquals(lastPaymentDate.get(Calendar.YEAR) + 1, newDate.get(Calendar.YEAR));
        assertEquals(lastPaymentDate.get(Calendar.MONTH), newDate.get(Calendar.MONTH));
        assertEquals(lastPaymentDate.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));
    }


}
