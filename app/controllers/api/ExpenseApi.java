package controllers.api;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import models.Category;
import models.Expense;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.ExpressionList;
import com.avaje.ebean.SqlRow;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class ExpenseApi extends Controller {
	public static final String FIELD_AMOUNT = "amount", FIELD_CATEGORY = "category", FIELD_DATE = "date", FIELD_INCOME = "income", FIELD_TYPE = "type";
	private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").excludeFieldsWithoutExposeAnnotation().create();

	private final String FILTER_FROM = "from", FILTER_TO = "to", FILTER_LIMIT = "limit", FILTER_OFFSET = "offset", FILTER_ORDERING = "ordering";
	SimpleDateFormat df = new SimpleDateFormat("yy-MM-dd");

	public Result create() {
		Logger.info("ExpenseApi.create()");
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		Expense expense = new Expense();
		expense.setAmount(Double.parseDouble(params.get(FIELD_AMOUNT)[0]));

		Category category = Category.find.byId(Long.parseLong(params.get(FIELD_CATEGORY)[0]));
		if (category == null) {
			return badRequest("Category missing");
		} else {
			expense.setCategory(category);
		}
		try {
			expense.setDate(df.parse(params.get(FIELD_DATE)[0]));
		} catch (NullPointerException | ParseException e) {
			expense.setDate(new Date());
		}
		try {
			expense.setIncome(Boolean.parseBoolean(params.get(FIELD_INCOME)[0]));
		} catch (NullPointerException e) {
			expense.setIncome(false);
		}
		try {
			expense.setType(Integer.parseInt(params.get(FIELD_TYPE)[0]));
		} catch (NullPointerException e) {
			expense.setType(Expense.TYPE_NORMAL);
		}

		expense.save();

		return ok(gson.toJson(expense)).as("application/json");
	}

	public Result get() {
		Logger.info("ExpenseApi.get()");

		ExpressionList<Expense> sqlQuery = Expense.find.where();

		int count = 0;
		Map<String, String[]> query = request().queryString();
		for (String key : query.keySet()) {
			String value = query.get(key)[0];
			switch (key) {
			case FILTER_FROM:
				sqlQuery = sqlQuery.ge("date", value);
				break;
			case FILTER_TO:
				sqlQuery = sqlQuery.le("date", value);
				break;
			default:
				sqlQuery = sqlQuery.eq(key, value);
				break;
			}
			Logger.info("Filter {} => {}", key, value);
			count++;
		}
		if (count == 0) {
			return ok(gson.toJson(Expense.find.all())).as("application/json");
		} else {
			return ok(gson.toJson(sqlQuery.findList())).as("application/json");
		}
	}

	public Result getId(long id) {
		Logger.info("ExpenseApi.get({})", id);
		return ok(gson.toJson(Expense.find.byId(id))).as("application/json");
	}

	public Result getByDay() {
		Logger.info("ExpenseApi.getByDay()");
		String sql = "SELECT DISTINCT `date` FROM `expense`";
		Map<String, String[]> query = request().queryString();

		if (query.containsKey(FILTER_FROM) && query.containsKey(FILTER_TO)) {
			sql += " WHERE `date` >= '" + query.get(FILTER_FROM)[0] + "' AND `date`<= '" + query.get(FILTER_TO)[0] + "'";
		} else if (query.containsKey(FILTER_FROM)) {
			sql += " WHERE `date` >= '" + query.get(FILTER_FROM)[0] + "'";
		} else if (query.containsKey(FILTER_TO)) {
			sql += " WHERE `date`<= '" + query.get(FILTER_TO)[0] + "'";
		}else if(query.containsKey("month")){
			sql += " WHERE `date` LIKE '" + query.get("month")[0] + "%'";
		}
		
		sql+= " ORDER BY `date` DESC";

		Logger.info("SQL: [{}]", sql);
		List<SqlRow> rows = Ebean.createSqlQuery(sql).findList();
		
		Map<String, Map<String, Object>> result = new LinkedHashMap<>();
		
		rows.forEach((row) ->{
			String date = row.getString("date");
			List<Expense> expenses = Expense.find.select("*").where().eq("date", date).findList();
			if(!expenses.isEmpty()){
				double outcome = 0, income = 0;
				for(Expense expense:expenses){
					if(expense.isIncome()){
						income += expense.getAmount();
					}else{
						outcome += expense.getAmount();
					}
					
					//Weird bug, not showing category and color if not calling this…
					expense.getCategory().getIcon();
				}
				
				Map<String, Object> tmp = new HashMap<>();
				tmp.put("outcome", outcome);
				tmp.put("income", income);
				tmp.put("expenses", expenses);
				tmp.put("date", date);
				
				result.put(date, tmp);
			}
			
		});
		
		return ok(gson.toJson(result)).as("application/json");

	}
	
	//Get all months where there is expense
	public Result getMonths(){
		Logger.info("ExpenseApi.getMonths()");
		List<String> months = new ArrayList<>();
		
		String sql = "SELECT DISTINCT FORMATDATETIME(`date`, 'Y-MM') as `month` FROM `expense`  ORDER BY `month` ASC";
		List<SqlRow> rows = Ebean.createSqlQuery(sql).findList();
		rows.forEach((row) ->{
			months.add(row.getString("month"));
		});
		return ok(gson.toJson(months)).as("application/json");

	}

	public Result delete(long id) {
		Logger.info("ExpenseApi.delete({})", id);
		Expense.find.deleteById(id);
		return ok(gson.toJson(true));
	}

	public Result update(long id) {
		Logger.info("ExpenseApi.create()");
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		Expense expense = Expense.find.byId(id);
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
			expense.setDate(df.parse(params.get(FIELD_DATE)[0]));
		} catch (Exception e) {
		}

		try {
			expense.setType(Integer.parseInt(params.get(FIELD_TYPE)[0]));
		} catch (NullPointerException e) {
		}

		expense.save();

		return ok(gson.toJson(expense)).as("application/json");
	}
}
