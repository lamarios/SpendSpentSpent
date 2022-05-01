package com.ftpix.sss.controllers;

import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.dao.RecurringExpenseDao;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.RecurringExpenseService;
import com.ftpix.sss.services.UserService;
import com.j256.ormlite.dao.Dao;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class BackgroundJob {

    private final Logger logger = LogManager.getLogger();
    private final RecurringExpenseService recurringExpenseService;
    private final ExpenseDao expenseDaoJooq;
    private final RecurringExpenseDao recurringExpenseDaoJooq;
    private final UserService userService;
    private final EmailService emailService;

    @Autowired
    public BackgroundJob(RecurringExpenseService recurringExpenseService, ExpenseDao expenseDaoJooq, RecurringExpenseDao recurringExpenseDaoJooq, UserService userService, EmailService emailService) {
        this.recurringExpenseService = recurringExpenseService;
        this.expenseDaoJooq = expenseDaoJooq;
        this.recurringExpenseDaoJooq = recurringExpenseDaoJooq;
        this.userService = userService;
        this.emailService = emailService;
    }


    @Scheduled(fixedRate = 100 * 60 * 1000, initialDelay = 60 * 60 * 1000)
//    @Scheduled(fixedRate = 10 * 1000)
    public void run() throws Exception {
        final List<User> users = userService.getAll().getData();
        for (User user : users) {
            List<RecurringExpense> recurringExpenses = recurringExpenseService.getToProcessForUser(user);
            logger.info("{} Recurring expense process for user {}", recurringExpenses.size(), user.getId());
            for (RecurringExpense recurring : recurringExpenses) {
                try {
                    logger.info("Recurring payment: category[{}], amount[{}], lastOccurrence[{}], nextOccurence[{}]", recurring.getCategory().getIcon(), recurring.getAmount(),
                            recurring.getLastOccurrence(), recurring.getNextOccurrence());
                    Expense expense = new Expense();
                    expense.setType(Expense.TYPE_RECURRENT);
                    expense.setAmount(recurring.getAmount());
                    expense.setCategory(recurring.getCategory());
                    expense.setDate(recurring.getNextOccurrence());
                    expense.setIncome(false);

                    if (recurring.getName() != null && recurring.getName().trim().length() > 0) {
                        expense.setNote(recurring.getName().trim());
                    }

                    expenseDaoJooq.insert(user, expense);

                    recurring.setLastOccurrence(recurring.getNextOccurrence());
                    recurring.setNextOccurrence(recurringExpenseService.calculateNextDate(recurring));

                    recurringExpenseDaoJooq.update(user, recurring);
                    logger.info("Expense added, next occurence:[{}]", recurring.getNextOccurrence());

                    String type = "";
                    switch (recurring.getType()) {
                        case RecurringExpense.TYPE_DAILY:
                            type = "daily";
                            break;
                        case RecurringExpense.TYPE_WEEKLY:
                            type = "weekly";
                            break;
                        case RecurringExpense.TYPE_MONTHLY:
                            type = "monthly";
                            break;
                        case RecurringExpense.TYPE_YEARLY:
                            type = "yearly";
                            break;

                    }

                } catch (Exception e) {
                    logger.info("Error processing the occurrences", e);
                }
            }

            if (!recurringExpenses.isEmpty()) {
                Map<String, Object> templateData = new HashMap<>();
                templateData.put("firstName", user.getFirstName());
                templateData.put("expenses", recurringExpenses);
                emailService.sendTemplate(user.getEmail(), "Recurring expense report", "email/recurring-expense.ftl", templateData);
            }

        }
    }
}

