package com.ftpix.sss.controllers;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sss.controllers.api.RecurringExpenseController;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.notifications.Notifications;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class BackgroundJob implements Runnable {

    private final Logger logger = LogManager.getLogger();
    private ExecutorService exec = Executors.newSingleThreadExecutor();
    private boolean refresh = true;
    private SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    DecimalFormat df2 = new DecimalFormat("#,###,###,##0.00");

    public BackgroundJob() {
        logger.info("Starting Background Tasks");
        exec.execute(this);
    }

    public void shutdown() {
        this.refresh = false;
        logger.info("Stopping background tasks");
        exec.shutdown();
    }

    private List<RecurringExpense> getExpenses() throws SQLException {
        String sql = "SELECT `id` FROM `recurring_expense` WHERE `next_occurrence` <= '" + df.format(new Date()) + "'";

        List<RecurringExpense> recurringExpenses = DB.RECURRING_EXPENSE_DAO.queryBuilder().where().le("next_occurrence", new Date()).query();


        // List<RecurringExpense> recurringExpenses =
        // RecurringExpense.find.where().le("DATE(`next_occurrence`)","'" +
        // df.format(new Date()) + "'").findList();


        logger.info("[{}] recurring expense to process", recurringExpenses.size());
        return recurringExpenses;
    }

    @Override
    public void run() {
        while (refresh) {
            StringBuilder str = new StringBuilder();
            boolean sendNotification = false;
            try {
                List<RecurringExpense> recurringExpenses = getExpenses();
                while (recurringExpenses.size() > 0) {
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
                            DB.EXPENSE_DAO.create(expense);

                            recurring.setLastOccurrence(recurring.getNextOccurrence());
                            recurring.setNextOccurrence(Sparknotation.getController(RecurringExpenseController.class).calculateNextDate(recurring));

                            DB.RECURRING_EXPENSE_DAO.update(recurring);
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

                            str.append(df2.format(recurring.getAmount())).append(" paid as ").append(type).append("  expense, next occurrence: ").append(recurring.getNextOccurrence());
                            str.append("\n");
                            sendNotification = true;
                        } catch (Exception e) {
                            logger.info("Error processing the occurrences", e);
                        }
                    }

                    recurringExpenses = getExpenses();
                }

                if (sendNotification)
                    Notifications.send("Recurring expense summary", str.toString());

                try {
                    Thread.sleep(10000 * 3600);
                } catch (InterruptedException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }

            } catch (Exception e) {
                logger.info("Error getting the occurrences, most probably too early in application lifecycle", e);
                try {
                    Thread.sleep(10000);
                } catch (InterruptedException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }
            }
        }
    }
}

