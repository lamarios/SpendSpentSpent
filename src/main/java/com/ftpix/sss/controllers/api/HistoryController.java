package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkGet;
import com.ftpix.sparknnotation.annotations.SparkParam;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;


@SparkController("/API/History")
public class HistoryController {

    private final Logger logger = LogManager.getLogger();


    @SparkGet(value = "/Yearly/:count", transformer = GsonTransformer.class)
    public Map<String, TreeMap<String, Double>> yearly(@SparkParam("count") int count) throws SQLException {
        logger.info("HistoryApi.yearly({})", count);

        Map<String, TreeMap<String, Double>> result = new HashMap<>();

        List<Category> categories = DB.CATEGORY_DAO.queryForAll();

        TreeMap<String, Double> overall = new TreeMap<>();


        for (Category category : categories) {
            TreeMap<String, Double> tmp = new TreeMap<>();

            LocalDate date = LocalDate.now();
            for (int i = count; i > 0; i--) {

                String yearStr = String.valueOf(date.getYear());

                Map<String, Object> params = new HashMap<>();
                params.put("income", 0);
                params.put("category_id", category.getId());
//                List<Expense> expenses = Expense.find.where().eq("income", 0).eq("category_id", category.getId()).like("date", year+"%").findList();

                final LocalDate finalDate = date;
                double total = DB.EXPENSE_DAO.queryForFieldValues(params)
                        .stream()
                        .filter(e -> LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault()).getYear() == finalDate.getYear())
                        .mapToDouble(Expense::getAmount)
                        .sum();

                tmp.put(yearStr, total);

                //adding to overall count
                if (!overall.containsKey(yearStr)) {
                    overall.put(yearStr, 0d);
                }
                overall.put(yearStr, overall.get(yearStr) + total);

//                cal.add(Calendar.YEAR, -1);
                date = date.minusYears(1);
            }

            result.put(category.getIcon(), tmp);
        }

        result.put("all", overall);


        ValueComparator comparator = new ValueComparator(result);
        Map<String, TreeMap<String, Double>> sortedMap = new TreeMap<>(comparator);
        sortedMap.putAll(result);
        return sortedMap;
    }


    @SparkGet(value = "/Monthly/:count", transformer = GsonTransformer.class)
    public Map<String, TreeMap<String, Double>> monthly(@SparkParam("count") int count) throws SQLException {
        logger.info("HistoryApi.monthly({})", count);

        Map<String, TreeMap<String, Double>> result = new HashMap<>();

        List<Category> categories = DB.CATEGORY_DAO.queryForAll();

        TreeMap<String, Double> overall = new TreeMap<>();


        for (Category category : categories) {
            TreeMap<String, Double> tmp = new TreeMap<>();
            LocalDate runningDate = LocalDate.now();
            for (int i = count; i > 0; i--) {
                String date = runningDate.getYear() + "-" + String.format("%02d", runningDate.getMonthValue());


                Map<String, Object> params = new HashMap<>();
                params.put("income", 0);
                params.put("category_id", category.getId());

//                List<Expense> expenses = Expense.find.where().eq("income", 0).eq("category_id", category.getId()).like("date", date + "%").findList();
                final LocalDate finalDate = runningDate;
                double total;
                total = DB.EXPENSE_DAO.queryForFieldValues(params)
                        .stream()
                        .filter(e -> {
                            LocalDateTime tmpDate = LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault());
                            return tmpDate.getYear() == finalDate.getYear() && tmpDate.getMonthValue() == finalDate.getMonthValue();
                        })
                        .mapToDouble(Expense::getAmount)
                        .sum();
                tmp.put(date, total);

                //adding to overall count
                if (!overall.containsKey(date)) {
                    overall.put(date, 0d);
                }
                overall.put(date, overall.get(date) + total);

                runningDate = runningDate.minusMonths(1);
            }

            result.put(category.getIcon(), tmp);
        }

        result.put("all", overall);


        ValueComparator comparator = new ValueComparator(result);
        Map<String, TreeMap<String, Double>> sortedMap = new TreeMap<>(comparator);
        sortedMap.putAll(result);
        return sortedMap;
    }


    class ValueComparator implements Comparator<String> {

        Map<String, TreeMap<String, Double>> base;

        public ValueComparator(Map<String, TreeMap<String, Double>> base) {
            this.base = base;
        }

        // Note: this comparator imposes orderings that are inconsistent with equals.
        public int compare(String a, String b) {
            //getting last item from each map
            if (getLast(base.get(a)) >= getLast(base.get(b))) {
                return -1;
            } else {
                return 1;
            } // returning 0 would merge keys
        }

        private double getLast(TreeMap<String, Double> map) {

            double last = 0;

            Set<String> keys = map.keySet();
            for (String key : keys) {
                last = map.get(key);
            }

            return last;
        }
    }
}
