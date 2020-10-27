package com.ftpix.sss.services;

import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class RecurringExpenseService {
    private final static Logger logger = LogManager.getLogger();
    private final CategoryService categoryService;

    @Autowired
    public RecurringExpenseService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    /**
     * Calculate the next instance of a recurring expense
     *
     * @param expense the expense we want to check.
     * @return when is the new payment due.
     */
    public Date calculateNextDate(RecurringExpense expense) {
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

    public RecurringExpense create(RecurringExpense expense, User user) throws Exception {

        Category category = categoryService.get(expense.getCategory().getId(), user);
        if (category == null) {
            throw new Exception("Category doesn't exist");
        } else {
            expense.setCategory(category);
        }

        expense.setNextOccurrence(calculateNextDate(expense));

        DB.RECURRING_EXPENSE_DAO.create(expense);

        return expense;
    }

    public List<RecurringExpense> get(User user) throws Exception {
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
        if (!userCategoriesId.isEmpty()) {
            return DB.RECURRING_EXPENSE_DAO.queryBuilder()
                    .where()
                    .in("category_id", userCategoriesId)
                    .query();
        } else {
            return new ArrayList<RecurringExpense>(0);
        }
    }


    public RecurringExpense getId(long id, User user) throws Exception {
        final RecurringExpense recurringExpense = DB.RECURRING_EXPENSE_DAO.queryForId(id);
        if (recurringExpense.getCategory().getUser().getId().equals(user.getId())) {
            return recurringExpense;
        } else {
            return null;
        }
    }


    public boolean delete(long id, User user) throws Exception {
        final RecurringExpense recurringExpenses = getId(id, user);

        if (recurringExpenses != null) {
            DB.RECURRING_EXPENSE_DAO.deleteById(id);
            return true;
        } else {
            return false;
        }
    }
}
