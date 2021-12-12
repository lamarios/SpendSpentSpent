package com.ftpix.sss.services;

import com.ftpix.sss.dao.RecurringExpenseDao;
import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.j256.ormlite.dao.Dao;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jooq.DSLContext;
import org.jooq.impl.DSL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.ftpix.sss.dsl.Tables.*;

@Service
public class RecurringExpenseService {
    private final static Logger logger = LogManager.getLogger();
    private final CategoryService categoryService;
    private final RecurringExpenseDao recurringExpenseDaoJooq;
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    @Autowired
    public RecurringExpenseService(CategoryService categoryService, RecurringExpenseDao recurringExpenseDaoJooq) {
        this.categoryService = categoryService;
        this.recurringExpenseDaoJooq = recurringExpenseDaoJooq;
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
        expense.setNextOccurrence(calculateNextDate(expense));
        return recurringExpenseDaoJooq.insert(user, expense);
    }

    public List<RecurringExpense> get(User user) throws Exception {
        return recurringExpenseDaoJooq.getWhere(user);
    }


    public RecurringExpense getId(long id, User user) throws Exception {
        return recurringExpenseDaoJooq.queryForId(user, id);
    }


    public boolean delete(long id, User user) throws Exception {
        recurringExpenseDaoJooq.deleteById(user, id);
        return true;
    }


    public List<RecurringExpense> getToProcessForUser(User user) throws Exception {
        return recurringExpenseDaoJooq.getWhere(user, RECURRING_EXPENSE.NEXT_OCCURRENCE.le(df.format(new Date())));
    }
}
