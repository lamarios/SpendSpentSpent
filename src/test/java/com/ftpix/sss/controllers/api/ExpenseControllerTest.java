package com.ftpix.sss.controllers.api;

import com.ftpix.sss.App;
import com.ftpix.sss.TestConfig;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.DailyExpense;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.ExpenseService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

@SpringBootTest(classes = App.class)
@RunWith(SpringJUnit4ClassRunner.class)
@Import(TestConfig.class)
public class ExpenseControllerTest {

    private final static DateFormat df = new SimpleDateFormat("yyyy-MM-dd");


    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private User currentUser;


    private Expense create(double amount, long catId, String date, boolean income, int expenseType, long lat, long longitude, String note) throws Exception {

        Expense exp = new Expense();
        exp.setAmount(amount);
        Category cat = new Category();
        cat.setId(catId);

        exp.setCategory(cat);
        try {
            exp.setDate(df.parse(date));
        } catch (ParseException e) {
            e.printStackTrace();
        }

        exp.setIncome(income);
        exp.setType(expenseType);
        exp.setLatitude(lat);
        exp.setLongitude(longitude);
        exp.setNote(note);

        return expenseService.create(exp, currentUser);
    }

    @Test(expected = Exception.class)
    public void createNullCategoryExpense() throws Exception {

        Expense exp = create(12d, 32131, "2012-10-10", false, Expense.TYPE_NORMAL, 0, 0, "");
    }

    @Test()
    public void testAddDeleteExpense() throws Exception {

        Expense newExpense = create(10d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");

        Expense fromController = expenseService.get(newExpense.getId(), currentUser);

        assertEquals(newExpense.getId(), fromController.getId());


        expenseService.delete(newExpense.getId(), currentUser);

        fromController = expenseService.get(newExpense.getId(), currentUser);

        assertNull(fromController);

    }


    @Test
    public void testAddWithTime() throws Exception {
        Date today = new Date();

        Expense newExpense = create(10d, 1, df.format(today), false, Expense.TYPE_NORMAL, 0, 0, "");
        Expense newExpense2 = create(10d, 1, "2012-03-21", false, Expense.TYPE_NORMAL, 0, 0, "");

        String properTime = String.format("%02d", today.getHours()) + ":" + String.format("%02d", today.getMinutes());

        assertEquals(properTime, newExpense.getTime());
        assertNull(newExpense2.getTime());
        assertNull(newExpense2.getTime());
    }


    @Test
    public void testCategoryByDay() throws Exception {
        create(10d, 1, "2012-12-02", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(20d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(30d, 1, "2012-12-23", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(40d, 1, "2012-10-24", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(50d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");


        assertEquals(2, expenseService.getMonths(currentUser).size());
        assertTrue(expenseService.getMonths(currentUser).contains("2012-10"));
        assertTrue(expenseService.getMonths(currentUser).contains("2012-12"));

        Map<String, DailyExpense> byDay = expenseService.getByDay("2012-12", currentUser);
        //we only have 3 distinct days of expenses
        assertEquals(3, byDay.size());
        assertEquals(2, ((List) byDay.get("2012-12-24").getExpenses()).size());
        assertEquals(1, ((List) byDay.get("2012-12-02").getExpenses()).size());
        assertEquals(1, ((List) byDay.get("2012-12-23").getExpenses()).size());

        double totalAmount = (double) byDay.get("2012-12-24").getTotal();
        assertEquals(70d, totalAmount, 0);
    }
}
