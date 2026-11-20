package com.ftpix.sss.services;

import static org.junit.jupiter.api.Assertions.*;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.controllers.ApplicationController;
import com.ftpix.sss.controllers.BackgroundJob;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.function.Consumer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

/**
 * Clients can change the schedule of a recurring expense and choose its next occurrence, older
 * clients only change the rest and send the dates back as they got them.
 */
@Import(TestConfig.class)
public class RecurringExpenseEditTest extends TestContainerTest {

  @Autowired private RecurringExpenseService recurringExpenseService;
  @Autowired private RecurringExpenseRepository recurringExpenseRepository;
  @Autowired private ExpenseService expenseService;
  @Autowired private BackgroundJob backgroundJob;
  @Autowired private ApplicationController applicationController;
  @Autowired private CategoryRepository categoryRepository;

  private Category category(int index) {
    return categoryRepository.findAllByUser(currentUser).get(index);
  }

  private RecurringExpense create(int type, int typeParam, LocalDate firstOccurrence)
      throws Exception {
    RecurringExpense expense = new RecurringExpense();
    expense.setCategory(category(0));
    expense.setAmount(10);
    expense.setName("gym");
    expense.setType(type);
    expense.setTypeParam(typeParam);
    expense.setNextOccurrence(firstOccurrence);
    return recurringExpenseService.create(expense, currentUser);
  }

  private RecurringExpense stored(RecurringExpense expense) {
    return recurringExpenseRepository.findById(expense.getId()).orElseThrow();
  }

  /** Changes the recurring expense as the client got it and sends it back. */
  private boolean edit(RecurringExpense expense, Consumer<RecurringExpense> change)
      throws Exception {
    RecurringExpense edited = stored(expense);
    change.accept(edited);
    return recurringExpenseService.update(edited, currentUser);
  }

  /** The weekly type parameter of a weekday, the inverse of the conversion in calculateNextDate. */
  private int weeklyParam(DayOfWeek day) {
    return day.getValue() % 7 + 1;
  }

  /** Where a new recurring expense with that schedule would start. */
  private LocalDate nextFromToday(int type, int typeParam) {
    return recurringExpenseService.calculateNextDate(type, typeParam, LocalDate.now());
  }

  private List<LocalDate> bookedDates() {
    return expenseService.getAll(currentUser).stream().map(Expense::getDate).sorted().toList();
  }

  /** Booked a week ago and today, next one in a week. */
  private RecurringExpense bookedWeekly() throws Exception {
    LocalDate today = LocalDate.now();
    RecurringExpense created =
        create(
            RecurringExpense.TYPE_WEEKLY, weeklyParam(today.getDayOfWeek()), today.minusWeeks(1));
    backgroundJob.run();
    RecurringExpense booked = stored(created);
    assertEquals(today, booked.getLastOccurrence());
    assertEquals(today.plusWeeks(1), booked.getNextOccurrence());
    return booked;
  }

  @Test
  public void theConfigTellsClientsTheScheduleCanBeChanged() throws Exception {
    assertEquals(true, applicationController.getConfig().get("canEditRecurringSchedule"));
  }

  @Test
  public void olderClientsChangeTheRestAndKeepTheDates() throws Exception {
    RecurringExpense booked = bookedWeekly();

    assertTrue(
        edit(
            booked,
            e -> {
              e.setName("swimming");
              e.setAmount(25);
              e.setCategory(category(1));
            }));

    RecurringExpense edited = stored(booked);
    assertEquals("swimming", edited.getName());
    assertEquals(25, edited.getAmount());
    assertEquals(category(1).getId(), edited.getCategory().getId());
    assertEquals(booked.getLastOccurrence(), edited.getLastOccurrence());
    assertEquals(booked.getNextOccurrence(), edited.getNextOccurrence());
  }

  @Test
  public void withoutANextOccurrenceTheDatesStay() throws Exception {
    RecurringExpense booked = bookedWeekly();

    edit(
        booked,
        e -> {
          e.setAmount(25);
          e.setNextOccurrence(null);
          e.setLastOccurrence(LocalDate.now().minusYears(3));
        });

    RecurringExpense edited = stored(booked);
    assertEquals(booked.getLastOccurrence(), edited.getLastOccurrence());
    assertEquals(booked.getNextOccurrence(), edited.getNextOccurrence());
  }

  @Test
  public void aNewScheduleStartsAtItsNextOccurrenceFromTodayOn() throws Exception {
    RecurringExpense booked = bookedWeekly();
    // a booked one counts the following ones from its last occurrence, today, a new schedule
    // mustn't
    int dayOfMonth = LocalDate.now().getDayOfMonth() == 15 ? 16 : 15;

    edit(
        booked,
        e -> {
          e.setType(RecurringExpense.TYPE_MONTHLY);
          e.setTypeParam(dayOfMonth);
          e.setNextOccurrence(null);
        });

    RecurringExpense edited = stored(booked);
    assertEquals(
        nextFromToday(RecurringExpense.TYPE_MONTHLY, dayOfMonth), edited.getNextOccurrence());
    assertEquals(dayOfMonth, edited.getNextOccurrence().getDayOfMonth());
    assertEquals(booked.getLastOccurrence(), edited.getLastOccurrence());
  }

  @Test
  public void anotherWeekdayIsANewSchedule() throws Exception {
    RecurringExpense booked = bookedWeekly();
    DayOfWeek tomorrow = LocalDate.now().plusDays(1).getDayOfWeek();

    edit(
        booked,
        e -> {
          e.setTypeParam(weeklyParam(tomorrow));
          e.setNextOccurrence(null);
        });

    assertEquals(LocalDate.now().plusDays(1), stored(booked).getNextOccurrence());
  }

  @Test
  public void theTypeParamOfADailyOneIsntPartOfTheSchedule() throws Exception {
    RecurringExpense daily = create(RecurringExpense.TYPE_DAILY, 0, LocalDate.now().plusDays(5));

    edit(
        daily,
        e -> {
          e.setTypeParam(3);
          e.setNextOccurrence(null);
        });

    assertEquals(LocalDate.now().plusDays(5), stored(daily).getNextOccurrence());
  }

  @Test
  public void aChosenNextOccurrenceIsTaken() throws Exception {
    RecurringExpense booked = bookedWeekly();
    LocalDate next = LocalDate.now().plusMonths(2).withDayOfMonth(15);

    edit(
        booked,
        e -> {
          e.setType(RecurringExpense.TYPE_MONTHLY);
          e.setTypeParam(15);
          e.setNextOccurrence(next);
        });

    assertEquals(next, stored(booked).getNextOccurrence());
    backgroundJob.run();
    // the two weekly ones
    assertEquals(2, bookedDates().size());
  }

  @Test
  public void aChosenNextOccurrenceKeepsTheSchedule() throws Exception {
    RecurringExpense booked = bookedWeekly();
    LocalDate inTwoWeeks = LocalDate.now().plusWeeks(2);

    edit(booked, e -> e.setNextOccurrence(inTwoWeeks));

    assertEquals(inTwoWeeks, stored(booked).getNextOccurrence());
  }

  @Test
  public void aChosenNextOccurrenceMustBeOnTheSchedule() throws Exception {
    RecurringExpense booked = bookedWeekly();

    assertThrows(
        IllegalArgumentException.class,
        () -> edit(booked, e -> e.setNextOccurrence(booked.getNextOccurrence().plusDays(1))));
    assertThrows(
        IllegalArgumentException.class,
        () ->
            edit(
                booked,
                e -> {
                  // what the client got, but not on the new schedule
                  e.setTypeParam(weeklyParam(LocalDate.now().plusDays(1).getDayOfWeek()));
                }));
    assertEquals(booked.getNextOccurrence(), stored(booked).getNextOccurrence());
    assertEquals(booked.getTypeParam(), stored(booked).getTypeParam());
  }

  @Test
  public void aChosenNextOccurrenceBookedMeanwhileMovesAlong() throws Exception {
    // chosen while the dialog was open, and booked by the background job before it was saved
    for (LocalDate date : List.of(LocalDate.now(), LocalDate.now().minusDays(1))) {
      RecurringExpense booked = bookedWeekly();

      assertTrue(
          edit(
              booked,
              e -> {
                e.setName("swimming");
                e.setType(RecurringExpense.TYPE_DAILY);
                e.setTypeParam(0);
                e.setNextOccurrence(date);
              }));

      RecurringExpense edited = stored(booked);
      assertEquals("swimming", edited.getName());
      assertEquals(RecurringExpense.TYPE_DAILY, edited.getType());
      assertEquals(LocalDate.now().plusDays(1), edited.getNextOccurrence());
      recurringExpenseRepository.delete(edited);
    }

    backgroundJob.run();
    // two weekly ones each time
    assertEquals(4, bookedDates().size());
  }

  @Test
  public void aNextOccurrenceBookedSinceTheClientGotItIsIgnored() throws Exception {
    LocalDate today = LocalDate.now();
    RecurringExpense due =
        create(RecurringExpense.TYPE_WEEKLY, weeklyParam(today.getDayOfWeek()), today);
    // the client got it before the background job booked it
    RecurringExpense asTheClientGotIt = stored(due);
    backgroundJob.run();

    asTheClientGotIt.setName("swimming");
    assertTrue(recurringExpenseService.update(asTheClientGotIt, currentUser));

    RecurringExpense edited = stored(due);
    assertEquals("swimming", edited.getName());
    assertEquals(today, edited.getLastOccurrence());
    assertEquals(today.plusWeeks(1), edited.getNextOccurrence());
    backgroundJob.run();
    assertEquals(List.of(today), bookedDates());
  }

  @Test
  public void aNewScheduleDoesntBookTodayAgain() throws Exception {
    RecurringExpense booked = bookedWeekly();

    edit(
        booked,
        e -> {
          e.setType(RecurringExpense.TYPE_DAILY);
          e.setTypeParam(0);
          e.setNextOccurrence(null);
        });

    assertEquals(LocalDate.now().plusDays(1), stored(booked).getNextOccurrence());
    backgroundJob.run();
    assertEquals(2, bookedDates().size());
  }

  @Test
  public void aChosenNextOccurrenceInThePastIsBooked() throws Exception {
    LocalDate today = LocalDate.now();
    // not booked yet
    RecurringExpense daily = create(RecurringExpense.TYPE_DAILY, 0, today.plusDays(3));

    edit(daily, e -> e.setNextOccurrence(today.minusDays(2)));
    backgroundJob.run();

    assertEquals(List.of(today.minusDays(2), today.minusDays(1), today), bookedDates());
    assertEquals(today.plusDays(1), stored(daily).getNextOccurrence());
  }
}
