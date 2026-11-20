package com.ftpix.sss.services;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import com.ftpix.sss.persistence.utils.Specifications;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoField;
import java.time.temporal.ChronoUnit;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RecurringExpenseService {
  private static final Logger logger = LogManager.getLogger();
  private final CategoryService categoryService;
  private final RecurringExpenseRepository recurringExpenseRepository;
  private final HouseholdLocks householdLocks;
  private final HouseholdService householdService;

  @Autowired
  public RecurringExpenseService(
      CategoryService categoryService,
      RecurringExpenseRepository recurringExpenseRepository,
      HouseholdLocks householdLocks,
      HouseholdService householdService) {
    this.categoryService = categoryService;
    this.recurringExpenseRepository = recurringExpenseRepository;
    this.householdLocks = householdLocks;
    this.householdService = householdService;
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
    ChronoUnit calendarUnit;
    LocalDate cal = today;
    //        Calendar cal = new GregorianCalendar();
    //        Calendar today = new GregorianCalendar();
    switch (expense.getType()) {
      case RecurringExpense.TYPE_DAILY:
        logger.info("Daily");
        //                calendarField = Calendar.DAY_OF_MONTH;
        calendarUnit = ChronoUnit.DAYS;
        break;
      case RecurringExpense.TYPE_MONTHLY:
        logger.info("Monthly");
        //                calendarField = Calendar.MONTH;
        calendarUnit = ChronoUnit.MONTHS;
        cal = cal.withDayOfMonth(expense.getTypeParam());
        //                cal.set(Calendar.DAY_OF_MONTH, expense.getTypeParam());
        break;
      case RecurringExpense.TYPE_WEEKLY:
        logger.info("Weekly");
        //                calendarField = Calendar.WEEK_OF_YEAR;
        //                cal.set(Calendar.DAY_OF_WEEK, expense.getTypeParam());
        // we migrated from gregorian calendar which starts the week on sunday, LocalDate starts on
        // monday
        DayOfWeek dow = DayOfWeek.of(((expense.getTypeParam() + 5) % 7) + 1);
        cal = cal.with(ChronoField.DAY_OF_WEEK, dow.getValue());
        calendarUnit = ChronoUnit.WEEKS;
        break;
      case RecurringExpense.TYPE_YEARLY:
      default:
        logger.info("Yearly");
        //                calendarField = Calendar.YEAR;
        //                cal.set(Calendar.MONTH, expense.getTypeParam());
        calendarUnit = ChronoUnit.YEARS;
        // we migrated to local date which the starts the months of the year with 1 instead of 0
        cal = cal.withMonth(expense.getTypeParam() + 1);
    }

    logger.info("Calculated date[{}]", cal.toString());

    // We don't have a date
    if (expense.getLastOccurrence() == null) {

      logger.info(
          "No date, must be new recurring expense: let's check if the set date is already past");
      logger.info("Comparing today[{}] and the set up date[{}]", today, cal);

      if (today.isAfter(cal)) {
        cal = cal.plus(1, calendarUnit);
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

  /** Each following occurrence is counted from it, and each one becomes an expense. */
  private void checkNextOccurrence(RecurringExpense expense, LocalDate date) {
    if (!isOnSchedule(expense, date)) {
      throw new IllegalArgumentException("The occurrence doesn't match the schedule");
    }
    // a mistyped year mustn't create hundreds of expenses
    if (date.isBefore(LocalDate.now().minusYears(1))) {
      throw new IllegalArgumentException("The occurrence can't be more than a year ago");
    }
  }

  /**
   * The next occurrence of the schedule from today on, as for a new recurring expense, but after
   * the last occurrence, which is booked already and might be today.
   */
  private LocalDate nextOccurrenceFromToday(RecurringExpense expense, LocalDate lastOccurrence) {
    LocalDate from = LocalDate.now();
    if (lastOccurrence != null && !lastOccurrence.isBefore(from)) {
      from = lastOccurrence.plusDays(1);
    }
    RecurringExpense schedule = new RecurringExpense();
    schedule.setType(expense.getType());
    schedule.setTypeParam(expense.getTypeParam());
    return calculateNextDate(schedule, from);
  }

  /**
   * Whether the date falls on the schedule of the recurring expense: the chosen weekday, day of the
   * month or month. The following occurrences are counted from the first one, so it must be on the
   * schedule.
   *
   * <p>Like the clients offer it, monthly and yearly ones are on the 28th at the latest:
   * calculateNextDate fails for a later day of the month in shorter months, and a yearly one on
   * February 29th would move to the 28th.
   */
  public boolean isOnSchedule(RecurringExpense expense, LocalDate date) {
    return switch (expense.getType()) {
      case RecurringExpense.TYPE_DAILY -> true;
      // same conversion from the gregorian calendar as in calculateNextDate
      case RecurringExpense.TYPE_WEEKLY ->
          date.getDayOfWeek() == DayOfWeek.of(((expense.getTypeParam() + 5) % 7) + 1);
      case RecurringExpense.TYPE_MONTHLY ->
          date.getDayOfMonth() == expense.getTypeParam() && date.getDayOfMonth() <= 28;
      case RecurringExpense.TYPE_YEARLY ->
          date.getMonthValue() == expense.getTypeParam() + 1 && date.getDayOfMonth() <= 28;
      default -> false;
    };
  }

  /**
   * Without a first occurrence, the recurring expense starts at its next occurrence from today on.
   * A first occurrence in the past is booked by the next run of the background job, along with the
   * following ones until today.
   */
  @Transactional
  public RecurringExpense create(RecurringExpense expense, User user) throws Exception {
    LocalDate firstOccurrence = expense.getNextOccurrence();
    if (firstOccurrence != null) {
      checkNextOccurrence(expense, firstOccurrence);
    }

    // the category might belong to a member leaving the household right now
    householdLocks.shared();
    Category category = categoryService.resolve(expense.getCategory(), user);
    if (category != null) {
      // an id sent by the client would overwrite that recurring expense, whoever it belongs to
      expense.setId(null);
      expense.setCategory(category);
      expense.setUser(user);
      expense.setLastOccurrence(null);
      expense.setNextOccurrence(
          firstOccurrence != null ? firstOccurrence : calculateNextDate(expense));
      RecurringExpense saved = recurringExpenseRepository.save(expense);
      // the recurring expenses are shared within the household
      householdService.notifyOtherMembersAfterCommit(user);
      return saved;
    } else {
      return null;
    }
  }

  /**
   * @return the recurring expenses of the user's household
   */
  @Transactional(readOnly = true)
  public List<RecurringExpense> get(User user) throws Exception {
    return recurringExpenseRepository.findHouseholdRecurringExpenses(user);
  }

  @Transactional(readOnly = true)
  public RecurringExpense getId(long id, User user) throws Exception {
    return recurringExpenseRepository.findHouseholdRecurringExpenseById(id, user);
  }

  @Transactional
  public boolean delete(long id, User user) throws Exception {
    // a member leaving the household right now might be moving this recurring expense
    householdLocks.shared();
    if (getId(id, user) != null) {
      recurringExpenseRepository.deleteById(id);
      householdService.notifyOtherMembersAfterCommit(user);
      return true;
    } else {
      return false;
    }
  }

  /**
   * @return the due recurring expenses created by the user. Each recurring expense is processed
   *     once, for its creator, even if its category is shared with other household members.
   */
  @Transactional
  public List<RecurringExpense> getToProcessForUser(User user) throws Exception {
    // expenses get created on these categories, which might belong to a member leaving the
    // household right now
    householdLocks.shared();
    Specification<RecurringExpense> spec =
        Specification.where(
                Specifications.<RecurringExpense, LocalDate>lessThanOrEqual(
                    "nextOccurrence", LocalDate.now()))
            .and(Specifications.<RecurringExpense>createdBy(user));
    return recurringExpenseRepository.findAll(spec);
    //        return recurringExpenseDaoJooq.getWhere(user,
    // RECURRING_EXPENSE.NEXT_OCCURRENCE.le(Constants.dateFormatter.format(LocalDate.now())));
  }

  /**
   * Without a next occurrence from the client, it stays as it is, unless the schedule changes: it
   * then moves to the next occurrence of the new schedule from today on, as for a new recurring
   * expense, but after the last one.
   *
   * <p>One the client sends is taken like the first one of a new recurring expense, but it must be
   * after the last occurrence, which is booked already. Older clients send it back as they got it
   * along with the same schedule. It stays as it is then, also when the background job booked it
   * meanwhile.
   */
  @Transactional
  public boolean update(RecurringExpense expense, User user) throws Exception {
    // the category might belong to a member leaving the household right now
    householdLocks.shared();
    RecurringExpense existing = getId(expense.getId(), user);
    Category category = categoryService.resolve(expense.getCategory(), user);

    if (existing != null && category != null) {
      boolean scheduleChanged =
          expense.getType() != existing.getType()
              || (expense.getType() != RecurringExpense.TYPE_DAILY
                  && expense.getTypeParam() != existing.getTypeParam());
      LocalDate requested = expense.getNextOccurrence();
      LocalDate next;
      LocalDate last = existing.getLastOccurrence();
      boolean booked = requested != null && last != null && !requested.isAfter(last);
      if (requested == null) {
        next =
            scheduleChanged ? nextOccurrenceFromToday(expense, last) : existing.getNextOccurrence();
      } else if (!scheduleChanged && (requested.equals(existing.getNextOccurrence()) || booked)) {
        // sent back as the client got it, maybe before the background job booked it
        next = existing.getNextOccurrence();
      } else {
        checkNextOccurrence(expense, requested);
        if (booked) {
          throw new IllegalArgumentException(
              "The next occurrence must be after the last one, it's already booked");
        }
        next = requested;
      }
      expense.setNextOccurrence(next);
      // only the background job books occurrences
      expense.setLastOccurrence(existing.getLastOccurrence());
      // the creator never changes and the category must be one of the household's
      expense.setUser(existing.getUser());
      expense.setCategory(category);
      recurringExpenseRepository.save(expense);
      householdService.notifyOtherMembersAfterCommit(user);
      return true;
    } else {
      return false;
    }
  }
}
