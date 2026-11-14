package com.ftpix.sss.controllers;

import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.HouseholdCategoryMergeService;
import com.ftpix.sss.services.HouseholdLocks;
import com.ftpix.sss.services.HouseholdSeparationService;
import com.ftpix.sss.services.RecurringExpenseService;
import com.ftpix.sss.services.UserService;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

@Service
public class BackgroundJob {

  private final Logger logger = LogManager.getLogger();
  private final RecurringExpenseService recurringExpenseService;
  private final UserService userService;
  private final EmailService emailService;
  private final ZoneId zoneId;
  private final ExpenseRepository expenseRepository;
  private final RecurringExpenseRepository recurringExpenseRepository;
  private final HouseholdSeparationService householdSeparationService;
  private final HouseholdLocks householdLocks;
  private final HouseholdCategoryMergeService householdCategoryMergeService;
  private final TransactionTemplate transactionTemplate;

  @Autowired
  public BackgroundJob(
      RecurringExpenseService recurringExpenseService,
      UserService userService,
      EmailService emailService,
      ZoneId zoneId,
      ExpenseRepository expenseRepository,
      RecurringExpenseRepository recurringExpenseRepository,
      HouseholdSeparationService householdSeparationService,
      HouseholdLocks householdLocks,
      HouseholdCategoryMergeService householdCategoryMergeService,
      PlatformTransactionManager transactionManager) {
    this.recurringExpenseService = recurringExpenseService;
    this.userService = userService;
    this.emailService = emailService;
    this.zoneId = zoneId;
    this.expenseRepository = expenseRepository;
    this.recurringExpenseRepository = recurringExpenseRepository;
    this.householdSeparationService = householdSeparationService;
    this.householdLocks = householdLocks;
    this.householdCategoryMergeService = householdCategoryMergeService;
    this.transactionTemplate = new TransactionTemplate(transactionManager);
  }

  /**
   * Runs at every start so rolling back and forth between versions stays consistent:
   *
   * <ul>
   *   <li>expenses and recurring expenses created by older versions don't have a creator, they get
   *       attributed to the owner of their category
   *   <li>older versions don't separate the entries of members leaving a household, this catches up
   *   <li>households created before categories were shared, or older versions, can have several
   *       categories with the same icon, they are merged
   * </ul>
   */
  @EventListener(ApplicationReadyEvent.class)
  @Transactional
  public void repairOwnership() {
    householdLocks.exclusive();
    int expenses = expenseRepository.assignMissingOwners();
    int recurring = recurringExpenseRepository.assignMissingOwners();
    if (expenses > 0 || recurring > 0) {
      logger.info(
          "Assigned an owner to {} expenses and {} recurring expenses", expenses, recurring);
    }

    householdSeparationService.separateEntriesOutsideHousehold();
    householdCategoryMergeService.mergeDuplicateCategories();
  }

  /**
   * Each user's recurring expenses are processed in their own transaction, the shared household
   * lock is only held while they are, and the report is sent once they are committed.
   */
  @Scheduled(fixedRate = 100 * 60 * 1000, initialDelay = 60 * 60 * 1000)
  //    @Scheduled(fixedRate = 10 * 1000)
  public void run() throws Exception {
    final List<User> users = userService.getAll().getData();
    for (User user : users) {
      try {
        List<RecurringExpense> processed =
            transactionTemplate.execute(status -> processRecurringExpenses(user));
        if (processed != null && !processed.isEmpty()) {
          Map<String, Object> templateData = new HashMap<>();
          templateData.put("firstName", user.getFirstName());
          templateData.put("expenses", processed);
          emailService.sendTemplate(
              user.getEmail(),
              "Recurring expense report",
              "email/recurring-expense.ftl",
              templateData);
        }
      } catch (Exception e) {
        logger.error("Error processing the recurring expenses of user {}", user.getId(), e);
      }
    }
  }

  private List<RecurringExpense> processRecurringExpenses(User user) {
    List<RecurringExpense> recurringExpenses;
    try {
      recurringExpenses = recurringExpenseService.getToProcessForUser(user);
    } catch (Exception e) {
      throw new IllegalStateException(e);
    }
    logger.info("{} Recurring expense process for user {}", recurringExpenses.size(), user.getId());
    for (RecurringExpense recurring : recurringExpenses) {
      try {
        logger.info(
            "Recurring payment: category[{}], amount[{}], lastOccurrence[{}], nextOccurence[{}]",
            recurring.getCategory().getIcon(),
            recurring.getAmount(),
            recurring.getLastOccurrence(),
            recurring.getNextOccurrence());
        Expense expense = new Expense();
        expense.setType(Expense.TYPE_RECURRENT);
        expense.setAmount(recurring.getAmount());
        expense.setCategory(recurring.getCategory());
        expense.setUser(recurring.getUser());
        expense.setDate(recurring.getNextOccurrence());
        expense.setIncome(false);
        expense.setTimestamp(
            recurring.getNextOccurrence().atStartOfDay().atZone(zoneId).toInstant().toEpochMilli());

        if (recurring.getName() != null && recurring.getName().trim().length() > 0) {
          expense.setNote(recurring.getName().trim());
        }

        expenseRepository.save(expense);

        recurring.setLastOccurrence(recurring.getNextOccurrence());
        recurring.setNextOccurrence(recurringExpenseService.calculateNextDate(recurring));

        recurringExpenseRepository.save(recurring);
        logger.info("Expense added, next occurence:[{}]", recurring.getNextOccurrence());

      } catch (Exception e) {
        logger.info("Error processing the occurrences", e);
      }
    }
    return recurringExpenses;
  }
}
