package com.ftpix.sss.controllers;

import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.services.RecurringExpenseService;
import com.j256.ormlite.dao.Dao;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;


@Service
public class BackgroundJob {

    private final Logger logger = LogManager.getLogger();
    private final RecurringExpenseService recurringExpenseService;
    private final Dao<Expense, Long> expenseDao;
    private final Dao<RecurringExpense, Long> recurringExpenseDao;

    @Autowired
    public BackgroundJob(RecurringExpenseService recurringExpenseService, Dao<Expense, Long> expenseDao, Dao<RecurringExpense, Long> recurringExpenseDao) {
        this.recurringExpenseService = recurringExpenseService;
        this.expenseDao = expenseDao;
        this.recurringExpenseDao = recurringExpenseDao;
    }


    @Scheduled(fixedRate = 100 * 60 * 1000)
//    @Scheduled(fixedRate = 10 * 1000)
    public void run() throws SQLException {
        logger.info("Recurring expense process");
        List<RecurringExpense> recurringExpenses = recurringExpenseService.getToProcess();
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
                expenseDao.create(expense);

                recurring.setLastOccurrence(recurring.getNextOccurrence());
                recurring.setNextOccurrence(recurringExpenseService.calculateNextDate(recurring));

                recurringExpenseDao.update(recurring);
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
    }
}

