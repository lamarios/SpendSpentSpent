package com.ftpix.sss.services;

import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.controllers.ApplicationController;
import com.ftpix.sss.controllers.BackgroundJob;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import com.ftpix.sss.utils.MockEmailService;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

/** Clients can send the first occurrence of a new recurring expense, older clients send none. */
@Import(TestConfig.class)
public class RecurringExpenseFirstOccurrenceTest extends TestContainerTest {

  @Autowired private RecurringExpenseService recurringExpenseService;
  @Autowired private RecurringExpenseRepository recurringExpenseRepository;
  @Autowired private ExpenseService expenseService;
  @Autowired private BackgroundJob backgroundJob;
  @Autowired private ApplicationController applicationController;
  @Autowired private CategoryRepository categoryRepository;
  @Autowired private ObjectMapper objectMapper;

  @Autowired
  // by name, the bean of the TestConfig
  private EmailService emailService;

  private MockEmailService mails;

  @BeforeEach
  public void mockEmails() {
    mails = (MockEmailService) emailService;
  }

  private Category house() {
    return categoryRepository.findAllByUser(currentUser).getFirst();
  }

  private RecurringExpense newRecurring(int type, int typeParam, LocalDate firstOccurrence) {
    RecurringExpense expense = new RecurringExpense();
    expense.setCategory(house());
    expense.setAmount(10);
    expense.setName("gym");
    expense.setType(type);
    expense.setTypeParam(typeParam);
    expense.setNextOccurrence(firstOccurrence);
    return expense;
  }

  /** The weekly type parameter of a weekday, the inverse of the conversion in calculateNextDate. */
  private int weeklyParam(DayOfWeek day) {
    return day.getValue() % 7 + 1;
  }

  private List<LocalDate> bookedDates() {
    return expenseService.getAll(currentUser).stream().map(Expense::getDate).sorted().toList();
  }

  @Test
  public void withoutFirstOccurrenceItStartsAtTheNextOne() throws Exception {
    LocalDate today = LocalDate.now();
    for (RecurringExpense expense :
        List.of(
            newRecurring(RecurringExpense.TYPE_DAILY, 0, null),
            newRecurring(
                RecurringExpense.TYPE_WEEKLY, weeklyParam(today.minusDays(1).getDayOfWeek()), null),
            newRecurring(RecurringExpense.TYPE_MONTHLY, 1, null),
            newRecurring(RecurringExpense.TYPE_YEARLY, today.getMonthValue() - 1, null),
            newRecurring(RecurringExpense.TYPE_YEARLY, (today.getMonthValue() + 10) % 12, null))) {
      LocalDate expected = recurringExpenseService.calculateNextDate(expense);

      RecurringExpense created = recurringExpenseService.create(expense, currentUser);

      assertEquals(
          expected,
          created.getNextOccurrence(),
          "type " + expense.getType() + " " + expense.getTypeParam());
      assertFalse(created.getNextOccurrence().isBefore(today));
    }
  }

  @Test
  public void theConfigTellsClientsTheFirstOccurrenceIsTakenIntoAccount() throws Exception {
    // older servers don't send it, clients mustn't offer the first occurrence then
    assertEquals(true, applicationController.getConfig().get("canChooseRecurringFirstOccurrence"));
  }

  @Test
  public void theFirstOccurrenceIsReadFromTheJsonOfTheClients() throws Exception {
    RecurringExpense expense =
        objectMapper.readValue(
            "{\"type\":2,\"typeParam\":15,\"amount\":10,\"nextOccurrence\":\"2027-01-15\"}",
            RecurringExpense.class);
    assertEquals(LocalDate.of(2027, 1, 15), expense.getNextOccurrence());

    RecurringExpense legacy =
        objectMapper.readValue(
            "{\"type\":2,\"typeParam\":15,\"amount\":10}", RecurringExpense.class);
    assertNull(legacy.getNextOccurrence());
  }

  @Test
  public void theReportSaysHowOftenItWasBooked() throws Exception {
    LocalDate today = LocalDate.now();
    RecurringExpense weekly =
        recurringExpenseService.create(
            newRecurring(
                RecurringExpense.TYPE_WEEKLY,
                weeklyParam(today.getDayOfWeek()),
                today.minusWeeks(2)),
            currentUser);
    recurringExpenseService.create(
        newRecurring(RecurringExpense.TYPE_DAILY, 0, today), currentUser);
    mails.getEmails().clear();

    backgroundJob.run();

    assertEquals(1, mails.getEmails().size());
    String report = mails.getEmails().peek().processedTemplate();
    assertTrue(report.contains("&times; 3"), report);
    assertEquals(1, report.split("&times;").length - 1, report);
    assertTrue(report.contains(today.plusWeeks(1).toString()), report);
    assertEquals(
        today.plusWeeks(1),
        recurringExpenseRepository.findById(weekly.getId()).orElseThrow().getNextOccurrence());
  }

  @Test
  public void aFirstOccurrenceInThePastIsBookedWithTheFollowingOnes() throws Exception {
    LocalDate today = LocalDate.now();
    LocalDate first = today.minusWeeks(2);
    RecurringExpense created =
        recurringExpenseService.create(
            newRecurring(RecurringExpense.TYPE_WEEKLY, weeklyParam(first.getDayOfWeek()), first),
            currentUser);
    assertEquals(first, created.getNextOccurrence());
    assertNull(created.getLastOccurrence());

    backgroundJob.run();

    // all of them in one run
    assertEquals(List.of(first, today.minusWeeks(1), today), bookedDates());
    RecurringExpense processed = recurringExpenseRepository.findById(created.getId()).orElseThrow();
    assertEquals(today, processed.getLastOccurrence());
    assertEquals(today.plusWeeks(1), processed.getNextOccurrence());

    backgroundJob.run();
    assertEquals(3, bookedDates().size());
  }

  @Test
  public void aFirstOccurrenceInTheFutureIsKept() throws Exception {
    LocalDate first = LocalDate.now().plusMonths(2).withDayOfMonth(15);
    RecurringExpense created =
        recurringExpenseService.create(
            newRecurring(RecurringExpense.TYPE_MONTHLY, 15, first), currentUser);

    assertEquals(first, created.getNextOccurrence());
    backgroundJob.run();
    assertTrue(bookedDates().isEmpty());
  }

  @Test
  public void theFirstOccurrenceMustBeOnTheSchedule() throws Exception {
    LocalDate monday = LocalDate.now().with(DayOfWeek.MONDAY);

    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_WEEKLY, weeklyParam(DayOfWeek.TUESDAY), monday),
                currentUser));
    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_MONTHLY, 15, monday.withDayOfMonth(14)),
                currentUser));
    // yearly type parameters are months from 0
    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_YEARLY, 2, monday.withMonth(2)), currentUser));
    // the clients offer days up to the 28th, later ones don't exist in every month
    LocalDate nextJanuary31 = LocalDate.of(monday.getYear() + 1, 1, 31);
    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_MONTHLY, 31, nextJanuary31), currentUser));
    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_YEARLY, 0, nextJanuary31), currentUser));
    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_YEARLY, 1, LocalDate.of(2028, 2, 29)),
                currentUser));
    assertTrue(recurringExpenseService.get(currentUser).isEmpty());

    assertNotNull(
        recurringExpenseService.create(
            newRecurring(RecurringExpense.TYPE_WEEKLY, weeklyParam(DayOfWeek.MONDAY), monday),
            currentUser));
    assertNotNull(
        recurringExpenseService.create(
            newRecurring(
                RecurringExpense.TYPE_WEEKLY,
                weeklyParam(DayOfWeek.SUNDAY),
                monday.with(DayOfWeek.SUNDAY)),
            currentUser));
    assertNotNull(
        recurringExpenseService.create(
            newRecurring(RecurringExpense.TYPE_MONTHLY, 15, monday.withDayOfMonth(15)),
            currentUser));
    assertNotNull(
        recurringExpenseService.create(
            newRecurring(RecurringExpense.TYPE_YEARLY, 2, monday.withMonth(3).withDayOfMonth(1)),
            currentUser));
    assertNotNull(
        recurringExpenseService.create(
            newRecurring(RecurringExpense.TYPE_DAILY, 0, monday), currentUser));
  }

  @Test
  public void theFirstOccurrenceIsAtMostAYearAgo() throws Exception {
    LocalDate yearAgo = LocalDate.now().minusYears(1);

    assertThrows(
        IllegalArgumentException.class,
        () ->
            recurringExpenseService.create(
                newRecurring(RecurringExpense.TYPE_DAILY, 0, yearAgo.minusDays(1)), currentUser));
    assertTrue(recurringExpenseService.get(currentUser).isEmpty());

    recurringExpenseService.create(
        newRecurring(RecurringExpense.TYPE_DAILY, 0, yearAgo), currentUser);
    backgroundJob.run();
    assertEquals(ChronoUnit.DAYS.between(yearAgo, LocalDate.now()) + 1, bookedDates().size());
  }

  @Test
  public void aLastOccurrenceSentByTheClientIsIgnored() throws Exception {
    RecurringExpense expense = newRecurring(RecurringExpense.TYPE_DAILY, 0, LocalDate.now());
    expense.setLastOccurrence(LocalDate.now().minusDays(1));

    RecurringExpense created = recurringExpenseService.create(expense, currentUser);

    assertNull(
        recurringExpenseRepository.findById(created.getId()).orElseThrow().getLastOccurrence());
  }
}
