package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.transformer.GsonBodyTransformer;
import com.ftpix.sss.transformer.GsonTransformer;
import com.j256.ormlite.stmt.QueryBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

import static com.ftpix.sss.controllers.api.ApiController.TOKEN;
import static com.ftpix.sss.controllers.api.UserSessionController.UNAUTHORIZED_SUPPLIER;
import static com.ftpix.sss.controllers.api.UserSessionController.getCurrentUser;

@SparkController("/API/Expense")
public class ExpenseController {
    public static final String DATE = "date";
    private static final String FILTER_MONTH = "month";
    private static final String FIELD_AMOUNT = "amount", FIELD_CATEGORY = "category",
            FIELD_DATE = "date", FIELD_INCOME = "income", FIELD_TYPE = "type", FIELD_LATITUDE = "latitude", FIELD_LONGITUDE = "longitude";
    private static final String FIELD_NOTE = "note";
    private static final String CATEGORY_ID = "CATEGORY_ID";
    private final Logger logger = LogManager.getLogger();
    private final String FILTER_FROM = "from", FILTER_TO = "to", FILTER_LIMIT = "limit", FILTER_OFFSET = "offset", FILTER_ORDERING = "ordering";
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");


    /**
     * Gets all expenses
     *
     * @return the list of expenses
     * @throws SQLException
     */
    @SparkGet(accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<Expense> getAll(@SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        return getAll(u);
                    } catch (Exception e) {
                        logger.error("Couldn't get categories", e);
                        throw new RuntimeException(e);
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);
    }

    public List<Expense> getAll(User user) throws Exception {
        final List<Long> userCategoriesId = Sparknotation.getController(CategoryController.class).getUserCategoriesId(user);
        if (!userCategoriesId.isEmpty()) {
            return DB.EXPENSE_DAO.queryBuilder()
                    .where()
                    .in(CATEGORY_ID, userCategoriesId)
                    .query();
        } else {
            return new ArrayList<Expense>(0);
        }
    }

    /**
     * GEts a single Expense
     *
     * @param id the id of the expense to get
     * @return the Expense
     * @throws SQLException
     */
    @SparkGet(value = "/ById/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Expense get(@SparkParam("id") long id, @SparkHeader(TOKEN) String token) throws Exception {
        getCurrentUser(token).orElseThrow(UNAUTHORIZED_SUPPLIER);

        final List<Long> userCategoriesId = Sparknotation.getController(CategoryController.class).getUserCategoriesId(token);
        if (!userCategoriesId.isEmpty()) {
            return DB.EXPENSE_DAO.queryBuilder()
                    .where()
                    .in(CATEGORY_ID, userCategoriesId)
                    .and()
                    .eq("ID", id)
                    .queryForFirst();
        } else {
            return null;
        }

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
    public Map<String, Map<String, Object>> getByDay(@SparkQueryParam(FILTER_FROM) String from, @SparkQueryParam(FILTER_TO) String to, @SparkQueryParam(FILTER_MONTH) String month, @SparkHeader(TOKEN) String token) throws Exception {
        String sql = "SELECT DISTINCT `date` FROM `expense`";

        // this should already throw exception if the user is not allowed
        final List<Long> userCategoriesId = Sparknotation.getController(CategoryController.class).getUserCategoriesId(token);

        if (!userCategoriesId.isEmpty()) {
            QueryBuilder<Expense, Long> builder = DB.EXPENSE_DAO.queryBuilder().distinct().selectColumns(DATE);

            if (from != null && to != null) {
//            sql += " WHERE `date` >= '" + query.get(FILTER_FROM)[0] + "' AND `date`<= '" + query.get(FILTER_TO)[0] + "'";
                sql += " WHERE `date` >= '" + from + "' AND `date`<= '" + to + "'";
                builder.setWhere(builder.where().ge(DATE, df.parse(from)).and().le(DATE, df.parse(to)));
//            builder.setWhere(builder.where().ge(DATE, df.parse(from)).and().le(DATE, df.parse(to)));
            } else if (from != null) {
//            sql += " WHERE `date` >= '" + query.get(FILTER_FROM)[0] + "'";
                sql += " WHERE `date` >= '" + from + "'";
                builder.setWhere(builder.where().ge(DATE, df.parse(from)));
            } else if (to != null) {
//            sql += " WHERE `date`<= '" + query.get(FILTER_TO)[0] + "'";
                sql += " WHERE `date`<= '" + to + "'";
                builder.setWhere(builder.where().le(DATE, df.parse(to)));
            } else if (month != null) {
//            sql += " WHERE `date` LIKE '" + query.get("month")[0] + "%'";
                sql += " WHERE `date` LIKE '" + month + "%'";
                final Date fromDate = df.parse(month + "-01");
                Calendar c = Calendar.getInstance();
                c.setTime(fromDate);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                System.out.println(c.getTime());
                builder.setWhere(builder.where().ge(DATE, fromDate).and().le(DATE, c.getTime()));
            }

            sql += " ORDER BY `date` DESC";
            builder = builder.orderBy(DATE, false);

            logger.info("String SQL: [{}]", sql);
//        List<SqlRow> rows = Ebean.createSqlQuery(sql).findList();


            Map<String, Map<String, Object>> result = new LinkedHashMap<>();
//        List<String[]> sqlResults = DB.EXPENSE_DAO.queryRaw(sql).getResults();

            List<String[]> sqlResults = builder.queryRaw().getResults();
            sqlResults.forEach((row) -> {
                String date = row[0];
                try {
//            List<Expense> expenses = Expense.find.select("*").where().eq(DATE, date).findList();

                    Map<String, Object> fields = new HashMap<>();
                    fields.put(DATE, df.parse(date));
                    final List<Expense> expenses = DB.EXPENSE_DAO.queryBuilder()
                            .where()
                            .in(CATEGORY_ID, userCategoriesId)
                            .and()
                            .eq(DATE, df.parse(date))
                            .query();

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
                        tmp.put(DATE, date);

                        result.put(date, tmp);
                    }
                } catch (SQLException | ParseException e) {
                    logger.error("Couldn't get the expenses for date {}", e);
                }

            });

            return result;
        } else {
            return new HashMap<>();
        }
    }


    /**
     * Get the list of months where expenses are available
     *
     * @return
     */
    @SparkGet(value = "/GetMonths", accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<String> getMonths(@SparkHeader(TOKEN) String token) throws Exception {
        // this should already throw exception if the user is not allowed
        final List<Long> userCategoriesId = Sparknotation.getController(CategoryController.class).getUserCategoriesId(token);
//        String sql = "SELECT `date` FROM `expense`  ORDER BY `date` ASC";

        return DB.EXPENSE_DAO.queryBuilder()
                .distinct()
                .selectColumns(DATE)
                .orderBy(DATE, true)
                .where()
                .in(CATEGORY_ID, userCategoriesId).queryRaw()
                .getResults()
                .stream()
                .map(r -> r[0])
                .map(s -> s.substring(0, 7))
                .distinct()
                .collect(Collectors.toList());
    }


    /**
     * create an Expense
     *
     * @return the expense
     * @throws SQLException
     */
    @SparkPost(transformer = GsonTransformer.class)
    public Expense create(@SparkBody(GsonBodyTransformer.class) Expense expense, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        Category category = Sparknotation.getController(CategoryController.class).get(expense.getCategory().getId(), token);
                        if (category == null) {
                            Spark.halt(503, "Category missing");
                        } else {
                            expense.setCategory(category);
                        }

                        Date now = new Date();

                        if (expense.getDate() == null) {
                            expense.setDate(now);
                        }
                        Date expenseDate = expense.getDate();

                        // if the expense is today, we set the time as now
                        if (expenseDate.getMonth() == now.getMonth() && expenseDate.getYear() == now.getYear() && expenseDate.getDate() == now.getDate()) {
                            expense.setTime(String.format("%02d", now.getHours()) + ":" + String.format("%02d", now.getMinutes()));
                        }


                        if (expense.getType() == 0) {
                            expense.setType(Expense.TYPE_NORMAL);
                        }

                        DB.EXPENSE_DAO.create(expense);

                        return expense;
                    } catch (Exception e) {
                        logger.error("Error while creating expense", e);
                        throw new RuntimeException(e);
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);
    }

    /**
     * Deletes an expense by its ID
     *
     * @param id the id of the expense to delete
     * @return true if it went well
     * @throws SQLException
     */
    @SparkDelete(value = "/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public boolean delete(@SparkParam("id") long id, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        final Expense expense = get(id, token);
                        if (expense.getCategory().getUser().getId().equals(u.getId())) {
                            DB.EXPENSE_DAO.deleteById(id);
                            return true;
                        } else {
                            return false;
                        }
                    } catch (Exception e) {
                        logger.error("Couldn't delete expense", e);
                        throw new RuntimeException(e);
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);

    }
}
