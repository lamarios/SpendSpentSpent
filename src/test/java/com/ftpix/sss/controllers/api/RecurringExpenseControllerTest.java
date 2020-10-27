package com.ftpix.sss.controllers.api;

public class RecurringExpenseControllerTest {
/*
    private RecurringExpenseController controller = new RecurringExpenseController();

    @BeforeClass
    public static void prefareDB() throws SQLException, IOException {
        PrepareDB.prepareDB();
    }

    private RecurringExpense create(long category, double amount, boolean income, String name, int type, int when) throws SQLException {
        RecurringExpense exp = new RecurringExpense();
        Category cat = new Category();
        cat.setId(category);
        exp.setCategory(cat);


        exp.setAmount(amount);
        exp.setIncome(income);
        exp.setName(name);
        exp.setType(type);
        exp.setTypeParam(when);

        return controller.create(exp);
    }

    @Test
    public void createDeleteRecurringExpense() throws Exception {

        int count = controller.get(USER).size();

        RecurringExpense expense = create(1, 10d, false, "spotify", RecurringExpense.TYPE_DAILY, 0);

        int newCount = controller.get(USER).size();

        assertEquals(count + 1, newCount);


        assertNotNull(controller.getId(expense.getId(), PrepareDB.TOKEN));

        controller.delete(expense.getId(), PrepareDB.TOKEN);
        newCount = controller.get(USER).size();

        assertEquals(count, newCount);
    }


    @Test(expected = HaltException.class)
    public void testAddingWronCategory() throws SQLException {
        create(3213121, 10d, false, "spotify", RecurringExpense.TYPE_DAILY, 0);
    }

    @Test
    public void testNewDateCalculation() {

        //Daily expense
        RecurringExpense expense = new RecurringExpense();
        expense.setType(RecurringExpense.TYPE_DAILY);

        GregorianCalendar today = new GregorianCalendar();

        GregorianCalendar newDate = new GregorianCalendar();
        newDate.setTime(RecurringExpenseController.calculateNextDate(expense));

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

        newDate.setTime(RecurringExpenseController.calculateNextDate(expense));


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

        newDate.setTime(RecurringExpenseController.calculateNextDate(expense));


        assertEquals(lastPaymentDate.get(Calendar.YEAR) + 1, newDate.get(Calendar.YEAR));
        assertEquals(lastPaymentDate.get(Calendar.MONTH), newDate.get(Calendar.MONTH));
        assertEquals(lastPaymentDate.get(Calendar.DAY_OF_MONTH), newDate.get(Calendar.DAY_OF_MONTH));


    }


*/
}
