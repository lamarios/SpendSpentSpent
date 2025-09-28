package com.ftpix.sss.services;

import com.ftpix.sss.Constants;
import com.ftpix.sss.dao.RecurringExpenseDao;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import net.bytebuddy.asm.Advice;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoField;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalField;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import static com.ftpix.sss.dsl.Tables.RECURRING_EXPENSE;

@Service
public class RecurringExpenseService {
    private final static Logger logger = LogManager.getLogger();
    private final CategoryService categoryService;
    private final RecurringExpenseDao recurringExpenseDaoJooq;

    @Autowired
    public RecurringExpenseService(CategoryService categoryService, RecurringExpenseDao recurringExpenseDaoJooq) {
        this.categoryService = categoryService;
        this.recurringExpenseDaoJooq = recurringExpenseDaoJooq;
    }

    public LocalDate calculateNextDate(RecurringExpense expense) {
        return calculateNextDate(expense, LocalDate.now());
    }

    /**
     * Calculate the next instance of a recurring expense
     *
     * @param expense the expense we want to check.
     * @return when is the new payment due.
     */
    public LocalDate calculateNextDate(RecurringExpense expense, LocalDate today) {
        ChronoField calendarField;
        ChronoUnit calendarUnit;
        LocalDate cal = today;
//        Calendar cal = new GregorianCalendar();
//        Calendar today = new GregorianCalendar();
        switch (expense.getType()) {
            case RecurringExpense.TYPE_DAILY:
                logger.info("Daily");
//                calendarField = Calendar.DAY_OF_MONTH;
                calendarField = ChronoField.DAY_OF_MONTH;
                calendarUnit = ChronoUnit.DAYS;
                break;
            case RecurringExpense.TYPE_MONTHLY:
                logger.info("Monthly");
//                calendarField = Calendar.MONTH;
                calendarField = ChronoField.MONTH_OF_YEAR;
                calendarUnit = ChronoUnit.MONTHS;
                cal = cal.withDayOfMonth(expense.getTypeParam());
//                cal.set(Calendar.DAY_OF_MONTH, expense.getTypeParam());
                break;
            case RecurringExpense.TYPE_WEEKLY:
                logger.info("Weekly");
//                calendarField = Calendar.WEEK_OF_YEAR;
//                cal.set(Calendar.DAY_OF_WEEK, expense.getTypeParam());
                // we migrated from gregorian calendar which starts the week on sunday, LocalDate starts on monday
                DayOfWeek dow = DayOfWeek.of(((expense.getTypeParam() + 5) % 7) + 1);
                cal = cal.with(ChronoField.DAY_OF_WEEK, dow.getValue());
                calendarField = ChronoField.ALIGNED_WEEK_OF_YEAR;
                calendarUnit = ChronoUnit.WEEKS;
                break;
            case RecurringExpense.TYPE_YEARLY:
            default:
                logger.info("Yearly");
//                calendarField = Calendar.YEAR;
//                cal.set(Calendar.MONTH, expense.getTypeParam());
                calendarField = ChronoField.YEAR;
                calendarUnit = ChronoUnit.YEARS;
                cal = cal.withMonth(expense.getTypeParam());
        }

        logger.info("Calculated date[{}]", cal.toString());

        // We don't have a date
        if (expense.getLastOccurrence() == null) {

            logger.info("No date, must be new recurring expense: let's check if the set date is already past");
            logger.info("Comparing today[{}] and the set up date[{}]", today, cal);

            if (today.isAfter(cal)) {
                cal = cal.plus( 1, calendarUnit);
                logger.info("The calculated date is expired, adding the extra time, new date[{}]", cal);

                // Handling special cases
                switch (expense.getType()) {
                    case RecurringExpense.TYPE_YEARLY:
                        cal = cal.withDayOfMonth(1);
                        break;
                }

            } else {
                // Handling special cases
                switch (expense.getType()) {
                    case RecurringExpense.TYPE_YEARLY:
                        if (today.getMonth().getValue() < cal.getMonth().getValue()) {
                            cal = cal.withDayOfMonth(1);
                        }
                        break;
                }

            }

            return cal;

        } else {
            logger.info("We already have a preceding payment, just handling the special cases");
//            GregorianCalendar last = new GregorianCalendar();
//            last.setTime(expense.getLastOccurrence());
//            last.add(calendarField, 1);
            LocalDate last = expense.getLastOccurrence();
            last = last.plus(1, calendarUnit);

            // Handling special cases
            switch (expense.getType()) {
                case RecurringExpense.TYPE_YEARLY:
                    cal = cal.withDayOfMonth(1);
                    break;
            }

            return last;
        }

    }

    @Transactional
    public RecurringExpense create(RecurringExpense expense, User user) throws Exception {
        expense.setNextOccurrence(calculateNextDate(expense));
        return recurringExpenseDaoJooq.insert(user, expense);
    }

    @Transactional(readOnly = true)
    public List<RecurringExpense> get(User user) throws Exception {
        return recurringExpenseDaoJooq.getWhere(user);
    }


    @Transactional(readOnly = true)
    public RecurringExpense getId(long id, User user) throws Exception {
        return recurringExpenseDaoJooq.queryForId(user, id);
    }


    @Transactional
    public boolean delete(long id, User user) throws Exception {
        recurringExpenseDaoJooq.deleteById(user, id);
        return true;
    }


    @Transactional(readOnly = true)
    public List<RecurringExpense> getToProcessForUser(User user) throws Exception {
        return recurringExpenseDaoJooq.getWhere(user, RECURRING_EXPENSE.NEXT_OCCURRENCE.le(Constants.dateFormatter.format(LocalDate.now())));
    }

    @Transactional
    public boolean update(RecurringExpense expense, User user) throws Exception {
        RecurringExpense existing = getId(expense.getId(), user);


        if (existing != null) {
            // dates should only be updated by the cron job !
            expense.setNextOccurrence(existing.getNextOccurrence());
            expense.setLastOccurrence(existing.getLastOccurrence());
            return recurringExpenseDaoJooq.update(user, expense);
        } else {
            return false;
        }
    }
}
