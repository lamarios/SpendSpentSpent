package com.ftpix.sss.controllers.api;

public class ExpenseControllerTest {
/*
    private final static DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    private ExpenseController controller = new ExpenseController();

    @BeforeClass
    public static void prepareDB() throws SQLException, IOException {
        PrepareDB.prepareDB();
    }


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

        return controller.create(exp, TOKEN);
    }

    @Test(expected = Exception.class)
    public void createNullCategoryExpense() throws Exception {

        Expense exp = create(12d, 32131, "2012-10-10", false, Expense.TYPE_NORMAL, 0, 0, "");

    }

    @Test()
    public void testAddDeleteExpense() throws Exception {

        Expense newExpense = create(10d, 1, "2012-12-24", false, Expense.TYPE_NORMAL, 0, 0, "");

        Expense fromController = controller.getAll(TOKEN).stream().reduce((first, second) -> second).get();

        assertEquals(newExpense.getId(), fromController.getId());


        controller.delete(newExpense.getId(), TOKEN);

        fromController = controller.get(newExpense.getId(), TOKEN);

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


        assertEquals(2, controller.getMonths(TOKEN).size());
        assertTrue(controller.getMonths(TOKEN).contains("2012-10"));
        assertTrue(controller.getMonths(TOKEN).contains("2012-12"));

        Map<String, Map<String, Object>> byDay = controller.getByDay(null, null, "2012-12", TOKEN);
        //we only have 3 distinct days of expenses
        assertEquals(3, byDay.size());
        assertEquals(2, ((List) byDay.get("2012-12-24").get("expenses")).size());
        assertEquals(1, ((List) byDay.get("2012-12-02").get("expenses")).size());
        assertEquals(1, ((List) byDay.get("2012-12-23").get("expenses")).size());

        double totalAmount = (double) byDay.get("2012-12-24").get("outcome");
        assertEquals(70d, totalAmount, 0);
    }
*/
}
