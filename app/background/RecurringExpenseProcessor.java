package background;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import models.Expense;
import models.RecurringExpense;
import play.Logger;
import play.inject.ApplicationLifecycle;
import play.libs.F;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.SqlRow;
import com.google.inject.Inject;
import com.google.inject.Singleton;

import controllers.api.RecurringExpenseApi;

@Singleton
public class RecurringExpenseProcessor implements Runnable {
	private ExecutorService exec = Executors.newSingleThreadExecutor();
	private boolean refresh = true;
	private SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	@Inject
	public RecurringExpenseProcessor(ApplicationLifecycle lifeCycle) {
		Logger.info("Starting Background Tasks");
		exec.execute(this);

		lifeCycle.addStopHook(() -> {
			shutdown();
			return F.Promise.pure(null);
		});
	}

	public void shutdown() {
		this.refresh = false;
		Logger.info("Stopping background tasks");
		exec.shutdown();
	}

	private List<RecurringExpense> getExpenses() {
		String sql = "SELECT `id` FROM `recurring_expense` WHERE DATE(`next_occurrence`) <= '" + df.format(new Date()) + "'";
		List<RecurringExpense> recurringExpenses = new ArrayList<RecurringExpense>();
		// List<RecurringExpense> recurringExpenses =
		// RecurringExpense.find.where().le("DATE(`next_occurrence`)","'" +
		// df.format(new Date()) + "'").findList();

		List<SqlRow> rows = Ebean.createSqlQuery(sql).findList();

		rows.forEach((row) -> {
			recurringExpenses.add(RecurringExpense.find.byId(row.getLong("id")));
		});

		Logger.info("[{}] recurring expense to process", recurringExpenses.size());
		return recurringExpenses;
	}

	@Override
	public void run() {
		while (refresh) {
			try {
				List<RecurringExpense> recurringExpenses = getExpenses();
				while (recurringExpenses.size() > 0) {
					for (RecurringExpense recurring : recurringExpenses) {
						try {
							Logger.info("Recurring payment: category[{}], amount[{}], lastOccurrence[{}], nextOccurence[{}]", recurring.getCategory().getIcon(), recurring.getAmount(),
									recurring.getLastOccurrence(), recurring.getNextOccurrence());
							Expense expense = new Expense();
							expense.setType(Expense.TYPE_RECURRENT);
							expense.setAmount(recurring.getAmount());
							expense.setCategory(recurring.getCategory());
							expense.setDate(recurring.getNextOccurrence());
							expense.setIncome(false);
							expense.save();

							recurring.setLastOccurrence(recurring.getNextOccurrence());
							recurring.setNextOccurrence(RecurringExpenseApi.calculateNextDate(recurring));

							recurring.save();
							Logger.info("Expense added, next occurence:[{}]", recurring.getNextOccurrence());
						} catch (Exception e) {
							Logger.info("Error processing the occurrences", e);
						}
					}

					recurringExpenses = getExpenses();
				}

				try {
					Thread.sleep(10000 * 3600);
				} catch (InterruptedException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			} catch (Exception e) {
				Logger.info("Error getting the occurrences, most probably too early in application lifecycle", e);
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