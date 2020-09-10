package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkGet;
import com.ftpix.sparknnotation.annotations.SparkParam;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryOverall;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;


@SparkController("/API/History")
public class HistoryController {

    private final Logger logger = LogManager.getLogger();

//    @SparkGet(value = "/Yearly/:count", transformer = GsonTransformer.class)
//    public Map<String, TreeMap<String, Double>> yearly(@SparkParam("count") int count) throws SQLException {
//        logger.info("HistoryApi.yearly({})", count);
//
//        Map<String, TreeMap<String, Double>> result = new HashMap<>();
//
//        List<Category> categories = DB.CATEGORY_DAO.queryForAll();
//
//        TreeMap<String, Double> overall = new TreeMap<>();
//
//
//        for (Category category : categories) {
//            TreeMap<String, Double> tmp = new TreeMap<>();
//
//            LocalDate date = LocalDate.now();
//            for (int i = count; i > 0; i--) {
//
//                String yearStr = String.valueOf(date.getYear());
//
//                Map<String, Object> params = new HashMap<>();
//                params.put("income", 0);
//                params.put("category_id", category.getId());
////                List<Expense> expenses = Expense.find.where().eq("income", 0).eq("category_id", category.getId()).like("date", year+"%").findList();
//
//                final LocalDate finalDate = date;
//                double total = DB.EXPENSE_DAO.queryForFieldValues(params)
//                        .stream()
//                        .filter(e -> LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault()).getYear() == finalDate.getYear())
//                        .mapToDouble(Expense::getAmount)
//                        .sum();
//
//                tmp.put(yearStr, total);
//
//                //adding to overall count
//                if (!overall.containsKey(yearStr)) {
//                    overall.put(yearStr, 0d);
//                }
//                overall.put(yearStr, overall.get(yearStr) + total);
//
////                cal.add(Calendar.YEAR, -1);
//                date = date.minusYears(1);
//            }
//
//            result.put(category.getIcon(), tmp);
//        }
//
//        result.put("all", overall);
//
//
//        ValueComparator comparator = new ValueComparator(result);
//        Map<String, TreeMap<String, Double>> sortedMap = new TreeMap<>(comparator);
//        sortedMap.putAll(result);
//        return sortedMap;
//    }

    @SparkGet(value = "/CurrentYear", transformer = GsonTransformer.class)
    public List<CategoryOverall> yearly() throws SQLException {

        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = DB.CATEGORY_DAO.queryForAll();

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1);
        categoryAll.setIcon("all");
        overall.setCategory(categoryAll);


        for (Category category : categories) {
            CategoryOverall tmp = new CategoryOverall();
            tmp.setCategory(category);
            LocalDate date = LocalDate.now();


            double total = getCategoryExpensesForYear(category.getId(), date)
                    .stream()
                    .mapToDouble(Expense::getAmount)
                    .sum();

            tmp.setAmount(total);

            //adding to overall count
            overall.setAmount(overall.getAmount() + total);


            result.add(tmp);
        }

        overall.setTotal(overall.getAmount());
        result.add(overall);


        return result.stream()
                .map(c -> {
                    c.setTotal(overall.getTotal());
                    return c;
                })
                .sorted((c1, c2) -> Double.compare(c2.getAmount(), c1.getAmount()))
                .collect(Collectors.toList());
    }

//    @SparkGet(value = "/Monthly/:count", transformer = GsonTransformer.class)
//    public Map<String, TreeMap<String, Double>> monthly(@SparkParam("count") int count) throws SQLException {
//        logger.info("HistoryApi.monthly({})", count);
//
//        Map<String, TreeMap<String, Double>> result = new HashMap<>();
//
//        List<Category> categories = DB.CATEGORY_DAO.queryForAll();
//
//        TreeMap<String, Double> overall = new TreeMap<>();
//
//
//        for (Category category : categories) {
//            TreeMap<String, Double> tmp = new TreeMap<>();
//            LocalDate runningDate = LocalDate.now();
//            for (int i = count; i > 0; i--) {
//                String date = runningDate.getYear() + "-" + String.format("%02d", runningDate.getMonthValue());
//
//
//                Map<String, Object> params = new HashMap<>();
//                params.put("income", 0);
//                params.put("category_id", category.getId());
//
////                List<Expense> expenses = Expense.find.where().eq("income", 0).eq("category_id", category.getId()).like("date", date + "%").findList();
//                final LocalDate finalDate = runningDate;
//                double total;
//                total = DB.EXPENSE_DAO.queryForFieldValues(params)
//                        .stream()
//                        .filter(e -> {
//                            LocalDateTime tmpDate = LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault());
//                            return tmpDate.getYear() == finalDate.getYear() && tmpDate.getMonthValue() == finalDate.getMonthValue();
//                        })
//                        .mapToDouble(Expense::getAmount)
//                        .sum();
//                tmp.put(date, total);
//
//                //adding to overall count
//                if (!overall.containsKey(date)) {
//                    overall.put(date, 0d);
//                }
//                overall.put(date, overall.get(date) + total);
//
//                runningDate = runningDate.minusMonths(1);
//            }
//
//            result.put(category.getIcon(), tmp);
//        }
//
//        result.put("all", overall);
//
//
//        ValueComparator comparator = new ValueComparator(result);
//        Map<String, TreeMap<String, Double>> sortedMap = new TreeMap<>(comparator);
//        sortedMap.putAll(result);
//        return sortedMap;
//    }

    @SparkGet(value = "/CurrentMonth", transformer = GsonTransformer.class)
    public List<CategoryOverall> monthly() throws SQLException {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = DB.CATEGORY_DAO.queryForAll();

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1);
        categoryAll.setIcon("all");
        overall.setCategory(categoryAll);


        for (Category category : categories) {
            CategoryOverall tmp = new CategoryOverall();
            tmp.setCategory(category);
            LocalDate date = LocalDate.now();


            double total = getCategoryExpensesForMonth(category.getId(), date)
                    .stream()
                    .mapToDouble(Expense::getAmount)
                    .sum();

            tmp.setAmount(total);

            //adding to overall count
            overall.setAmount(overall.getAmount() + total);


            result.add(tmp);
        }

        overall.setTotal(overall.getAmount());
        result.add(overall);


        return result.stream()
                .map(c -> {
                    c.setTotal(overall.getTotal());
                    return c;
                })
                .sorted((c1, c2) -> Double.compare(c2.getAmount(), c1.getAmount()))
                .collect(Collectors.toList());
    }


    /**
     * Get the sum of expenses by year for the past :count years for :Category
     *
     * @param categoryId the category to get expenses from
     * @param count      the number of year from now to :count month in the past
     * @return
     * @throws SQLException
     */
    @SparkGet(value = "/Yearly/:category/:count", transformer = GsonTransformer.class)
    public List<Map<String, Object>> getYearlyHistory(@SparkParam("category") int categoryId, @SparkParam("count") int count) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();

        for (int i = 0; i < count; i++) {
            Map<String, Object> expensesForMonth = new HashMap<>();

            expensesForMonth.put("date", date.getYear());
            expensesForMonth.put("amount", getCategoryExpensesForYear(categoryId, date).stream().mapToDouble(Expense::getAmount).sum());

            date = date.minusYears(1);
            result.add(expensesForMonth);
        }


        return result;
    }

    /**
     * Gets the sum of expenses by month for the past :count month for :category
     *
     * @param categoryId the id of the category to get expenses from
     * @param count      the number of month from now to the :count months in the past
     * @return
     * @throws SQLException
     */
    @SparkGet(value = "/Monthly/:category/:count", transformer = GsonTransformer.class)
    public List<Map<String, Object>> getMonthlyHistory(@SparkParam("category") int categoryId, @SparkParam("count") int count) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();

        for (int i = 0; i < count; i++) {
            Map<String, Object> expensesForMonth = new HashMap<>();

            expensesForMonth.put("date", date.getYear() + "-" + date.getMonthValue());
            expensesForMonth.put("amount", getCategoryExpensesForMonth(categoryId, date).stream().mapToDouble(Expense::getAmount).sum());

            date = date.minusMonths(1);
            result.add(expensesForMonth);
        }


        return result;
    }

    /**
     * Returns the expenses for a specific year
     *
     * @param category thhe category to query against
     * @param date     the date where the eay and month will be extracted
     * @return a list of expenses
     * @throws SQLException
     */
    private List<Expense> getCategoryExpensesForYear(long category, LocalDate date) throws SQLException {
        Map<String, Object> params = new HashMap<>();
        params.put("income", 0);
        if (category >= 0) {
            params.put("category_id", category);
        }


        return DB.EXPENSE_DAO.queryForFieldValues(params)
                .stream()
                .filter(e -> {
                    LocalDateTime tmpDate = LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault());
                    return tmpDate.getYear() == date.getYear();
                })
                .collect(Collectors.toList());
    }

    /**
     * Returns the expenses for a specific month
     *
     * @param category thhe category to query against
     * @param date     the date where the eay and month will be extracted
     * @return a list of expenses
     * @throws SQLException
     */
    private List<Expense> getCategoryExpensesForMonth(long category, LocalDate date) throws SQLException {
        Map<String, Object> params = new HashMap<>();
        params.put("income", 0);
        if (category >= 0) {
            params.put("category_id", category);
        }


        return DB.EXPENSE_DAO.queryForFieldValues(params)
                .stream()
                .filter(e -> {
                    LocalDateTime tmpDate = LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault());
                    return tmpDate.getYear() == date.getYear() && tmpDate.getMonthValue() == date.getMonthValue();
                })
                .collect(Collectors.toList());
    }


    class ValueComparator implements Comparator<String> {

        Map<String, CategoryOverall> base;

        public ValueComparator(Map<String, CategoryOverall> base) {
            this.base = base;
        }

        // Note: this comparator imposes orderings that are inconsistent with equals.
        public int compare(String a, String b) {
            return Double.compare(base.get(a).getAmount(), base.get(b).getAmount());
        }
    }
}
