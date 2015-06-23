package controllers.api;

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
	private final Gson gson = new GsonBuilder().setDateFormat("yy-MM-dd").excludeFieldsWithoutExposeAnnotation().create();

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

		expense.save();

		return ok(gson.toJson(expense)).as("application/json");
	}

	public Result get() {
		Logger.info("RecurringExpenseApi.get()");
		return ok(gson.toJson(RecurringExpense.find.all())).as("application/json");
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

}
