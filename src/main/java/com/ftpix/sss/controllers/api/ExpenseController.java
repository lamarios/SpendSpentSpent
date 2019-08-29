package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@SparkController("/API/Expense")
public class ExpenseController {
    private static final String FILTER_MONTH = "month";
    private static final String FIELD_AMOUNT = "amount", FIELD_CATEGORY = "category", FIELD_DATE = "date", FIELD_INCOME = "income", FIELD_TYPE = "type", FIELD_LATITUDE = "latitude", FIELD_LONGITUDE = "longitude";
    private static final String FIELD_NOTE = "note";

    private final Logger logger = LogManager.getLogger();
    private final String FILTER_FROM = "from", FILTER_TO = "to", FILTER_LIMIT = "limit", FILTER_OFFSET = "offset", FILTER_ORDERING = "ordering";
    private final SimpleDateFormat df = new SimpleDateFormat("yy-MM-dd");

    /**
     * Gets all expenses
     *
     * @return the list of expenses
     * @throws SQLException
     */
    @SparkGet(accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<Expense> getAll() throws SQLException {
        return DB.EXPENSE_DAO.queryForAll();
    }


    /**
     * GEts a single Expense
     *
     * @param id the id of the expense to get
     * @return the Expense
     * @throws SQLException
     */
    @SparkGet(value = "/ById/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Expense get(@SparkParam("id") long id) throws SQLException {
        return DB.EXPENSE_DAO.queryForId(id);
    }


    /**
     * Gets the expenses in dending on dates given as parameter
     *
     * @param from  yyy-mm-dd
     * @param to    yyyy-mm-dd
     * @param month yyyy-mm if only requesting for a specific month
     * @return
     * @throws SQLException
     * @throws ParseException
     */
    @SparkGet(value = "/ByDay", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Map<String, Map<String, Object>> getByDay(@SparkQueryParam(FILTER_FROM) String from, @SparkQueryParam(FILTER_TO) String to, @SparkQueryParam(FILTER_MONTH) String month) throws SQLException, ParseException {
        String sql = "SELECT DISTINCT `date` FROM `expense`";


//        QueryBuilder<Expense, Integer> builder = DB.EXPENSE_DAO.queryBuilder().distinct().selectColumns("date");

        if (from != null && to != null) {
//            sql += " WHERE `date` >= '" + query.get(FILTER_FROM)[0] + "' AND `date`<= '" + query.get(FILTER_TO)[0] + "'";
            sql += " WHERE `date` >= '" + from + "' AND `date`<= '" + to + "'";
//            builder.setWhere(builder.where().ge("date", df.parse(from)).and().le("date", df.parse(to)));
        } else if (from != null) {
//            sql += " WHERE `date` >= '" + query.get(FILTER_FROM)[0] + "'";
            sql += " WHERE `date` >= '" + from + "'";
//            builder.setWhere(builder.where().ge("date", df.parse(from)));
        } else if (to != null) {
//            sql += " WHERE `date`<= '" + query.get(FILTER_TO)[0] + "'";
            sql += " WHERE `date`<= '" + to + "'";
//            builder.setWhere(builder.where().le("date", df.parse(to)));
        } else if (month != null) {
//            sql += " WHERE `date` LIKE '" + query.get("month")[0] + "%'";
            sql += " WHERE `date` LIKE '" + month + "%'";
//            builder.setWhere(builder.where().like("date", month + "%"));
        }

        sql += " ORDER BY `date` DESC";
//        builder = builder.orderBy("date", false);

//        logger.info("SQL: [{}]", builder.toString());
        logger.info("SQL: [{}]", sql);
//        List<SqlRow> rows = Ebean.createSqlQuery(sql).findList();


        Map<String, Map<String, Object>> result = new LinkedHashMap<>();
        List<String[]> sqlResults = DB.EXPENSE_DAO.queryRaw(sql).getResults();
        sqlResults.forEach((row) -> {
            String date = row[0];
            try {
//            List<Expense> expenses = Expense.find.select("*").where().eq("date", date).findList();
                Map<String, Object> fields = new HashMap<>();
                fields.put("date", df.parse(date));
                List<Expense> expenses = DB.EXPENSE_DAO.queryForFieldValues(fields);
                if (!expenses.isEmpty()) {
                    double outcome = 0, income = 0;
                    for (Expense expense : expenses) {
                        outcome += expense.getAmount();
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
            } catch (SQLException | ParseException e) {
                logger.error("Couldn't get the expenses for date {}", e);
            }

        });

        return result;
    }


    /**
     * Get the list of months where expenses are available
     *
     * @return
     */
    @SparkGet(value = "/GetMonths", accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<String> getMonths() throws SQLException {

        String sql = "SELECT `date` FROM `expense`  ORDER BY `date` ASC";
        List<String> months = DB.EXPENSE_DAO.queryRaw(sql).getResults()
                .stream()
                .map(r -> r[0])
                .map(s -> s.substring(0, 7))
                .distinct()
                .collect(Collectors.toList());
        return months;
    }


    /**
     * create an Expense
     *
     * @param amount     the  amount
     * @param categoryId the  category id
     * @param dateString the  date
     * @param income     the  income
     * @param type       the  type
     * @param latitude   the  latitude
     * @param longitude  the  longitude
     * @return the expense
     * @throws SQLException
     */
    @SparkPost(transformer = GsonTransformer.class)
    public Expense create(
            @SparkQueryParam(FIELD_AMOUNT) double amount,
            @SparkQueryParam(FIELD_CATEGORY) long categoryId,
            @SparkQueryParam(FIELD_DATE) String dateString,
            @SparkQueryParam(FIELD_INCOME) boolean income,
            @SparkQueryParam(FIELD_TYPE) int type,
            @SparkQueryParam(FIELD_LATITUDE) double latitude,
            @SparkQueryParam(FIELD_LONGITUDE) double longitude,
            @SparkQueryParam(FIELD_NOTE) String note
    ) throws SQLException {
        Expense expense = new Expense();
        expense.setAmount(amount);

        Category category = DB.CATEGORY_DAO.queryForId(categoryId);
        if (category == null) {
            Spark.halt(503, "Category missing");
        } else {
            expense.setCategory(category);
        }
        try {
            Date expenseDate = df.parse(dateString);
            Date now = new Date();
            expense.setDate(expenseDate);

            // if the expense is today, we set the time as now
            if (expenseDate.getMonth() == now.getMonth() && expenseDate.getYear() == now.getYear() && expenseDate.getDate() == now.getDate()) {
                expense.setTime(String.format("%02d", now.getHours()) + ":" + String.format("%02d", now.getMinutes()));
            }
        } catch (NullPointerException | ParseException e) {
            expense.setDate(new Date());
        }
        try {
            expense.setIncome(income);
        } catch (NullPointerException e) {
            expense.setIncome(false);
        }
        try {
            expense.setType(type);
        } catch (NullPointerException e) {
            expense.setType(Expense.TYPE_NORMAL);
        }

        try {
            expense.setLatitude(latitude);
        } catch (NullPointerException e) {
            expense.setLatitude(0);
        }

        try {
            expense.setLongitude(longitude);
        } catch (NullPointerException e) {
            expense.setLongitude(0);
        }

        try {
            expense.setNote(note);
        } catch (NullPointerException e) {
            expense.setLongitude(0);
        }

        DB.EXPENSE_DAO.create(expense);

        return expense;
    }

    /**
     * Deletes an expense by its ID
     *
     * @param id the id of the expense to delete
     * @return true if it went well
     * @throws SQLException
     */
    @SparkDelete(value = "/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public boolean delete(@SparkParam("id") long id) throws SQLException {
        DB.EXPENSE_DAO.deleteById(id);
        return true;
    }
}
