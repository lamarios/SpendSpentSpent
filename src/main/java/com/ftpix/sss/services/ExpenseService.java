package com.ftpix.sss.services;

import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.j256.ormlite.stmt.QueryBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ExpenseService {
    public static final String DATE = "date";
    private static final String CATEGORY_ID = "CATEGORY_ID";
    public final CategoryService categoryService;
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    @Autowired
    public ExpenseService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    public List<Expense> getAll(User user) throws Exception {
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
        if (!userCategoriesId.isEmpty()) {
            return DB.EXPENSE_DAO.queryBuilder()
                    .where()
                    .in(CATEGORY_ID, userCategoriesId)
                    .query();
        } else {
            return new ArrayList<Expense>(0);
        }
    }

    public Expense get(long id, User user) throws Exception {
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
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

    public Map<String, Map<String, Object>> getByDay(String from, String to, String month, User user) throws Exception {
        String sql = "SELECT DISTINCT `date` FROM `expense`";

        // this should already throw exception if the user is not allowed
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);

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

            logger.info("String SQL: [" + sql + "]");
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

    public Expense create(Expense expense, User user) throws Exception {
        Category category = categoryService.get(expense.getCategory().getId(), user);
        if (category == null) {
            throw new Exception("Category doesn't exist");
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
    }

    public boolean delete(long id, User user) throws Exception {
        final Expense expense = get(id, user);
        if (expense.getCategory().getUser().getId().equals(user.getId())) {
            DB.EXPENSE_DAO.deleteById(id);
            return true;
        } else {
            return false;
        }
    }

    public List<String> getMonths(User user) throws Exception {
        // this should already throw exception if the user is not allowed
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
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
}
