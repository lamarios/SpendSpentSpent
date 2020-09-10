package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

public class ExpenseControllerTest {
    private ExpenseController controller = new ExpenseController();

    private final static DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    @BeforeClass
    public static void prepareDB() throws SQLException {
        PrepareDB.prepareDB();
    }


    private Expense create(double amount, long catId, String date, boolean income, int expenseType, long lat, long longitude, String note) throws SQLException {

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

        return controller.create(exp);
    }

    @Test(expected = HaltException.class)
    public void createNullCategoryExpense() throws SQLException {

        Expense exp = create(12d, 32131, "2012-10-10", false, Expense.TYPE_NORMAL, 0, 0, "");

    }

    @Test
    public void testAddDeleteExpense() throws SQLException {

        Expense newExpense = create(10d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");

        Expense fromController = controller.getAll().stream().reduce((first, second) -> second).get();

        assertEquals(newExpense.getId(), fromController.getId());


        controller.delete(newExpense.getId());

        fromController = controller.get(newExpense.getId());

        assertNull(fromController);
    }


    @Test
    public void testAddWithTime() throws SQLException{
        Date today = new Date();

        Expense newExpense = create(10d, 1, df.format(today), false, Expense.TYPE_NORMAL, 0, 0, "");
        Expense newExpense2 =create(10d, 1, "2012-03-21", false, Expense.TYPE_NORMAL, 0, 0, "");

        String properTime = String.format("%02d", today.getHours())+":"+String.format("%02d", today.getMinutes());

        assertEquals(properTime, newExpense.getTime());
        assertNull(newExpense2.getTime());
        assertNull(newExpense2.getTime());
    }


    @Test
    public void testCategoryByDay() throws SQLException, ParseException {
        create(10d, 1, "2012-12-02", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(20d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(30d, 1, "2012-12-23", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(40d, 1, "2012-10-24", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(50d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");


        assertEquals(2, controller.getMonths().size());
        assertTrue(controller.getMonths().contains("2012-10"));
        assertTrue(controller.getMonths().contains("2012-12"));

        Map<String, Map<String, Object>> byDay = controller.getByDay(null, null, "2012-12");
        //we only have 3 distinct days of expenses
        assertEquals(3, byDay.size());
        assertEquals(2, ((List) byDay.get("2012-12-24").get("expenses")).size());
        assertEquals(1, ((List) byDay.get("2012-12-02").get("expenses")).size());
        assertEquals(1, ((List) byDay.get("2012-12-23").get("expenses")).size());

        double totalAmount = (double) byDay.get("2012-12-24").get("outcome");
        assertEquals(70d, totalAmount, 0);
    }
}
