package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.Expense;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

public class ExpenseControllerTest {
    private ExpenseController controller = new ExpenseController();

    @BeforeClass
    public static void prepareDB() throws SQLException {
        PrepareDB.prepareDB();
    }


    @Test(expected = HaltException.class)
    public void createNullCategoryExpense() throws SQLException {

        controller.create(12d, 32131, "2012-10-10", false, Expense.TYPE_NORMAL, 0, 0);


    }

    @Test
    public void testAddDeleteExpense() throws SQLException {

        Expense newExpense = controller.create(10d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0);

        Expense fromController = controller.getAll().stream().reduce((first, second) -> second).get();

        assertEquals(newExpense.getId(), fromController.getId());


        controller.delete(newExpense.getId());

        fromController = controller.get(newExpense.getId());

        assertNull(fromController);
    }


    @Test
    public void testCategoryByDay() throws SQLException, ParseException {
        controller.create(10d, 1, "2012-12-02", false, Expense.TYPE_NORMAL, 0, 0);
        controller.create(20d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0);
        controller.create(30d, 1, "2012-12-23", false, Expense.TYPE_NORMAL, 0, 0);
        controller.create(40d, 1, "2012-10-24", false, Expense.TYPE_NORMAL, 0, 0);
        controller.create(50d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0);


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
