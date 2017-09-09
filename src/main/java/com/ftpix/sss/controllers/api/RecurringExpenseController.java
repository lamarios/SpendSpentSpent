package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

@SparkController("/API/RecurringExpense")
public class RecurringExpenseController {
    private final static String FIELD_AMOUNT = "amount", FIELD_CATEGORY = "category", FIELD_ID = "id", FIELD_INCOME = "income", FIELD_LAST_OCCURRENCE = "lastOccurrence", FIELD_NAME = "name",
            FIELD_NEXT_OCCURRENCE = "nextOccurrence", FIELD_TYPE = "type", FIELD_WHEN = "typeParam";

    private final static Logger logger = LogManager.getLogger();


    /**
     * Creates a recurring expense
     *
     * @param categoryId the category
     * @param amount     the amount
     * @param income     the income
     * @param name       the name
     * @param type       the type (daily, weekly, monthly, yearly)
     * @param when       when (1st of the month, or 1 month of the year, 2nd day of the week etc... depends on type parameter)
     * @return
     * @throws SQLException
     */
    @SparkPost(transformer = GsonTransformer.class)
    public RecurringExpense create(
            @SparkQueryParam(FIELD_CATEGORY) int categoryId,
            @SparkQueryParam(FIELD_AMOUNT) double amount,
            @SparkQueryParam(FIELD_INCOME) boolean income,
            @SparkQueryParam(FIELD_NAME) String name,
            @SparkQueryParam(FIELD_TYPE) int type,
            @SparkQueryParam(FIELD_WHEN) int when
    ) throws SQLException {
        logger.info("RecurringExpenseApi.create()");
        RecurringExpense expense = new RecurringExpense();

        Category category = DB.CATEGORY_DAO.queryForId(categoryId);
        if (category == null) {
            Spark.halt(503, "Category doesn't exist");
        } else {
            expense.setCategory(category);
        }

        expense.setAmount(amount);

        try {
            expense.setIncome(income);
        } catch (NullPointerException e) {
            expense.setIncome(false);
        }

        expense.setName(name);
        expense.setType(type);
        expense.setTypeParam(when);

        expense.setNextOccurrence(calculateNextDate(expense));

        DB.RECURRING_EXPENSE_DAO.create(expense);

        return expense;
    }


    /**
     * GEts all the expenses
     *
     * @return
     * @throws SQLException
     */
    @SparkGet(accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<RecurringExpense> get() throws SQLException {
        List<RecurringExpense> expenses = DB.RECURRING_EXPENSE_DAO.queryForAll();
//        expenses.forEach((expense) -> {
//            expense.getCategory().getIcon();
//        });

        return expenses;
    }


    /**
     * Gets a single recurring expense
     *
     * @param id the id of the expense to get
     * @return the expense
     * @throws SQLException
     */
    @SparkGet(value = "/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public RecurringExpense getId(@SparkParam("id") int id) throws SQLException {
        return DB.RECURRING_EXPENSE_DAO.queryForId(id);
    }


    /**
     * Delete a single recurring expense
     *
     * @param id
     * @return
     * @throws SQLException
     */
    @SparkDelete(value = "/:id", transformer = GsonTransformer.class, accept = Constants.JSON)
    public boolean delete(@SparkParam("id") int id) throws SQLException {
        DB.RECURRING_EXPENSE_DAO.deleteById(id);
        return true;
    }


    /**
     * Update a recurring expense
     *
     * @param id         the id of the expense to update
     * @param categoryId the new category
     * @param amount     the new amount
     * @param income     the new income
     * @param name       the new name
     * @param type       the new type (daily, weekly, monthly, yearly)
     * @param when       when (1st of the month, or 1 month of the year, 2nd day of the week etc... depends on type parameter)
     * @return
     * @throws SQLException
     */
    @SparkPut(value = "/:id", transformer = GsonTransformer.class)
    public RecurringExpense update(
            @SparkParam("id") int id,
            @SparkQueryParam(FIELD_CATEGORY) int categoryId,
            @SparkQueryParam(FIELD_AMOUNT) double amount,
            @SparkQueryParam(FIELD_INCOME) boolean income,
            @SparkQueryParam(FIELD_NAME) String name,
            @SparkQueryParam(FIELD_TYPE) int type,
            @SparkQueryParam(FIELD_WHEN) int when
    ) throws SQLException {
        RecurringExpense expense = DB.RECURRING_EXPENSE_DAO.queryForId(id);
        try {
            expense.setAmount(amount);
        } catch (NullPointerException e) {
        }

        Category category = DB.CATEGORY_DAO.queryForId(categoryId);
        if (category != null) {
            expense.setCategory(category);
        }

        try {
            expense.setIncome(income);
        } catch (NullPointerException e) {
        }

        try {
            expense.setType(type);
        } catch (NullPointerException e) {
        }

        try {
            expense.setTypeParam(when);
        } catch (NullPointerException e) {
        }

        try {
            expense.setName(name);
        } catch (NullPointerException e) {
        }

        DB.RECURRING_EXPENSE_DAO.update(expense);

        return expense;
    }

    /**
     * Calculate the next instance of a recurring expense
     * @param expense the expense we want to check.
     * @return when is the new payment due.
     */
    public static Date calculateNextDate(RecurringExpense expense) {
        int calendarField;
        Calendar cal = new GregorianCalendar();
        Calendar today = new GregorianCalendar();
        switch (expense.getType()) {
            case RecurringExpense.TYPE_DAILY:
                logger.info("Daily");
                calendarField = Calendar.DAY_OF_MONTH;
                break;
            case RecurringExpense.TYPE_MONTHLY:
                logger.info("Monthly");
                calendarField = Calendar.MONTH;
                cal.set(Calendar.DAY_OF_MONTH, expense.getTypeParam());
                break;
            case RecurringExpense.TYPE_WEEKLY:
                logger.info("Weekly");
                calendarField = Calendar.WEEK_OF_YEAR;
                cal.set(Calendar.DAY_OF_WEEK, expense.getTypeParam());
                break;
            case RecurringExpense.TYPE_YEARLY:
            default:
                logger.info("Yearly");
                calendarField = Calendar.YEAR;
                cal.set(Calendar.MONTH, expense.getTypeParam());
        }

        logger.info("Calculated date[{}]", cal.getTime());

        // We don't have a date
        if (expense.getLastOccurrence() == null) {

            logger.info("No date, must be new recurring expense: let's check if the set date is already past");
            logger.info("Comparing today[{}] and the set up date[{}]", today.getTime(), cal.getTime());

            if (today.after(cal)) {
                cal.add(calendarField, 1);
                logger.info("The calculated date is expired, adding the extra time, new date[{}]", cal.getTime());

                // Handling special cases
                switch (expense.getType()) {
                    case RecurringExpense.TYPE_YEARLY:
                        cal.set(Calendar.DAY_OF_MONTH, 1);
                        break;
                }

            } else {
                // Handling special cases
                switch (expense.getType()) {
                    case RecurringExpense.TYPE_YEARLY:
                        if (today.get(Calendar.MONTH) < cal.get(Calendar.MONTH)) {
                            cal.set(Calendar.DAY_OF_MONTH, 1);
                        }
                        break;
                }

            }

            return cal.getTime();

        } else {
            logger.info("We already have a preceding payment, just handling the special cases");
            GregorianCalendar last = new GregorianCalendar();
            last.setTime(expense.getLastOccurrence());
            last.add(calendarField, 1);

            // Handling special cases
            switch (expense.getType()) {
                case RecurringExpense.TYPE_YEARLY:
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    break;
            }

            return last.getTime();
        }

    }

}