package controllers.api;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import models.Category;
import models.Expense;
import models.RecurringExpense;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;

public class RecurringExpenseApi extends Controller {
	private final String FIELD_AMOUNT = "amount", FIELD_CATEGORY = "category", FIELD_ID = "id", FIELD_INCOME = "income", FIELD_LAST_OCCURRENCE = "lastOccurrence", FIELD_NAME = "name",
			FIELD_NEXT_OCCURRENCE = "nextOccurrence", FIELD_TYPE = "type", FIELD_WHEN = "typeParam";
	private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").excludeFieldsWithoutExposeAnnotation().create();

	public Result create() {
		Logger.info("RecurringExpenseApi.create()");
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		RecurringExpense expense = new RecurringExpense();

		Category category = Category.find.byId(Long.parseLong(params.get(FIELD_CATEGORY)[0]));
		if (category == null) {
			return badRequest("Category missing");
		} else {
			expense.setCategory(category);
		}

		expense.setAmount(Double.parseDouble(params.get(FIELD_AMOUNT)[0]));

		try {
			expense.setIncome(Boolean.parseBoolean(params.get(FIELD_INCOME)[0]));
		} catch (NullPointerException e) {
			expense.setIncome(false);
		}

		expense.setName(params.get(FIELD_NAME)[0]);
		expense.setType(Integer.parseInt(params.get(FIELD_TYPE)[0]));
		expense.setTypeParam(Integer.parseInt(params.get(FIELD_WHEN)[0]));

		expense.setNextOccurrence(calculateNextDate(expense));

		expense.save();

		return ok(gson.toJson(expense)).as("application/json");
	}

	public Result get() {
		Logger.info("RecurringExpenseApi.get()");
		List<RecurringExpense> expenses = RecurringExpense.find.all();
		expenses.forEach((expense) -> {
			expense.getCategory().getIcon();
		});

		return ok(gson.toJson(expenses)).as("application/json");
	}

	public Result getId(long id) {
		Logger.info("RecurringExpenseApi.get({})", id);
		return ok(gson.toJson(RecurringExpense.find.byId(id))).as("application/json");
	}

	public Result delete(long id) {
		Logger.info("RecurringExpenseApi.delete({})", id);
		RecurringExpense.find.deleteById(id);
		return ok(gson.toJson(true)).as("application/json");
	}

	public Result update(long id) {
		Logger.info("RecurringExpenseApi.create()");
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		RecurringExpense expense = RecurringExpense.find.byId(id);
		try {
			expense.setAmount(Double.parseDouble(params.get(FIELD_AMOUNT)[0]));
		} catch (NullPointerException e) {
		}

		Category category = Category.find.byId(Long.parseLong(params.get(FIELD_CATEGORY)[0]));
		if (category != null) {
			expense.setCategory(category);
		}

		try {
			expense.setIncome(Boolean.parseBoolean(params.get(FIELD_INCOME)[0]));
		} catch (NullPointerException e) {
		}

		try {
			expense.setType(Integer.parseInt(params.get(FIELD_TYPE)[0]));
		} catch (NullPointerException e) {
		}

		try {
			expense.setTypeParam(Integer.parseInt(params.get(FIELD_WHEN)[0]));
		} catch (NullPointerException e) {
		}

		try {
			expense.setName(params.get(FIELD_NAME)[0]);
		} catch (NullPointerException e) {
		}

		expense.save();

		return ok(gson.toJson(expense)).as("application/json");
	}

	public static Date calculateNextDate(RecurringExpense expense) {
		int calendarField;
		Calendar cal = new GregorianCalendar();
		Calendar today = new GregorianCalendar();
		switch (expense.getType()) {
		case RecurringExpense.TYPE_DAILY:
			Logger.info("Daily");
			calendarField = Calendar.DAY_OF_MONTH;
			break;
		case RecurringExpense.TYPE_MONTHLY:
			Logger.info("Monthly");
			calendarField = Calendar.MONTH;
			cal.set(Calendar.DAY_OF_MONTH, expense.getTypeParam());
			break;
		case RecurringExpense.TYPE_WEEKLY:
			Logger.info("Weekly");
			calendarField = Calendar.WEEK_OF_YEAR;
			cal.set(Calendar.DAY_OF_WEEK, expense.getTypeParam());
			break;
		case RecurringExpense.TYPE_YEARLY:
		default:
			Logger.info("Yearly");
			calendarField = Calendar.YEAR;
			cal.set(Calendar.MONTH, expense.getTypeParam());
		}

		Logger.info("Calculated date[{}]", cal.getTime());

		// We don't have a date
		if (expense.getLastOccurrence() == null) {

			Logger.info("No date, must be new recurring expense: let's check if the set date is already past");
			Logger.info("Comparing today[{}] and the set up date[{}]", today.getTime(), cal.getTime());

			if (today.after(cal)) {
				cal.add(calendarField, 1);
				Logger.info("The calculated date is expired, adding the extra time, new date[{}]", cal.getTime());

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
			Logger.info("We already have a preceding payment, just handling the special cases");
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
}
