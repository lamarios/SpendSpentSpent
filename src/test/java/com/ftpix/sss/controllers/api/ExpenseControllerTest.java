package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.models.*;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.HistoryService;
import com.ftpix.sss.utils.TestService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;


@Import(TestConfig.class)
public class ExpenseControllerTest extends TestContainerTest {

    private final static DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    private static final double DELTA = 1e-15;

    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private HistoryService historyService;

    @Autowired
    private TestService testService;

    @Autowired
    private User currentUser;

    @Autowired
    private CategoryDao categoryDaoJooq;

    private final static DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");


    private Expense create(User user, double amount, Category cat, String date, boolean income, int expenseType, long lat, long longitude, String note) throws Exception {
        Expense exp = new Expense();
        exp.setAmount(amount);

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

        return expenseService.create(exp, user);
    }

    private Expense create(double amount, long catId, String date, boolean income, int expenseType, long lat, long longitude, String note) throws Exception {

        var cats = categoryDaoJooq.getWhere(currentUser);

        return create(currentUser, amount, cats.stream().filter(category -> category.getId() == catId).findFirst().get(), date, income, expenseType, lat, longitude, note);
    }

    @Test
    public void createNullCategoryExpense() throws Exception {
        Assertions.assertThrows(Exception.class, () -> {
            Expense exp = create(12d, 32131, "2012-10-10", false, Expense.TYPE_NORMAL, 0, 0, "");
        });
    }

    @Test
    public void testAddDeleteExpense() throws Exception {

        var cats = categoryDaoJooq.getWhere(currentUser);
        Expense newExpense = create(10d, cats.get(0).getId(), "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");

        Expense fromController = expenseService.get(newExpense.getId(), currentUser);

        assertEquals(newExpense.getId(), fromController.getId());


        expenseService.delete(newExpense.getId(), currentUser);

        fromController = expenseService.get(newExpense.getId(), currentUser);

        assertNull(fromController);

    }


    @Test
    public void testAddWithTime() throws Exception {
        Date today = new Date();

        var cats = categoryDaoJooq.getWhere(currentUser);

        Expense newExpense = create(10d, cats.get(0).getId(), df.format(today), false, Expense.TYPE_NORMAL, 0, 0, "");
        Expense newExpense2 = create(10d, cats.get(0).getId(), "2012-03-21", false, Expense.TYPE_NORMAL, 0, 0, "");

        String properTime = String.format("%02d", today.getHours()) + ":" + String.format("%02d", today.getMinutes());

        assertEquals(properTime, newExpense.getTime());
        assertNull(newExpense2.getTime());
        assertNull(newExpense2.getTime());
    }


    @Test
    public void testCategoryByDay() throws Exception {
        var cats = categoryDaoJooq.getWhere(currentUser);

        create(10d, cats.get(0).getId(), "2012-12-02", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(20d, cats.get(0).getId(), "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(30d, cats.get(0).getId(), "2012-12-23", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(40d, cats.get(0).getId(), "2012-10-24", false, Expense.TYPE_NORMAL, 0, 0, "");
        create(50d, cats.get(0).getId(), "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");


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

    @Test
    public void testHistoryRecordInsertion() throws Exception {

        User user = testService.create(UUID.randomUUID().toString() + "@test.com", false, "cat1", "cat2");
        System.out.println(user.getId());
        List<CategoryOverall> monthly = historyService.monthly(user);
        List<CategoryOverall> yearly = historyService.yearly(user);
        // We created the user with 2 categories, so we should have 3 here (including the "All" category)
        assertEquals(3, monthly.size());
        assertEquals(3, yearly.size());
        assertTrue(monthly.stream().allMatch(c -> c.getTotal() == 0), "All should be 0");
        assertTrue(yearly.stream().allMatch(c -> c.getTotal() == 0), "All should be 0");


        Category cat = monthly.stream().filter(c -> c.getCategory().getId() != -1).findFirst().get().getCategory();

        String now = LocalDate.now().format(dtf);


        var cats = categoryDaoJooq.getWhere(user);

        Expense created = create(user, 50d, cats.get(0), now, false, Expense.TYPE_NORMAL, 0, 0, "");
        monthly = historyService.monthly(user);
        yearly = historyService.yearly(user);

        assertEquals(50d, getForCatId(monthly, cat.getId()).getTotal(), DELTA);
        assertEquals(50d, getForCatId(yearly, cat.getId()).getTotal(), DELTA);
        assertEquals(50d, getForCatId(monthly, -1).getTotal(), DELTA);
        assertEquals(50d, getForCatId(yearly, -1).getTotal(), DELTA);

        expenseService.delete(created.getId(), user);
        monthly = historyService.monthly(user);
        yearly = historyService.yearly(user);

        assertEquals(0d, getForCatId(monthly, cat.getId()).getTotal(), DELTA);
        assertEquals(0d, getForCatId(yearly, cat.getId()).getTotal(), DELTA);
        assertEquals(0d, getForCatId(monthly, -1).getTotal(), DELTA);
        assertEquals(0d, getForCatId(yearly, -1).getTotal(), DELTA);

    }

    private CategoryOverall getForCatId(List<CategoryOverall> history, long catId) {
        return history.stream().filter(c -> c.getCategory().getId() == catId).findFirst().get();
    }

}
