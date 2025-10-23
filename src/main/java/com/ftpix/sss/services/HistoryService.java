package com.ftpix.sss.services;

import com.ftpix.sss.dao.*;
import com.ftpix.sss.models.*;
import jakarta.annotation.PostConstruct;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.Condition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.MONTHLY_HISTORY;
import static com.ftpix.sss.dsl.Tables.YEARLY_HISTORY;

@Service
public class HistoryService {
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final CategoryService categoryService;
    private final DateTimeFormatter historyDateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMM");
    private final DateTimeFormatter monthlyHistoryDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
    private final DateTimeFormatter yearlyHistoryDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
    private final ExpenseService expenseService;

    private final ExpenseDao expenseDaoJooq;
    private final CategoryDao categoryDaoJooq;
    private final MonthlyHistoryDao monthlyHistoryDaoJooq;
    private final YearlyHistoryDao yearlyHistoryDaoJooq;
    private final UserDao userDao;
    private final ZoneId zoneId;

    @Autowired
    public HistoryService(CategoryService categoryService, ExpenseService expenseService, ExpenseDao expenseDaoJooq, CategoryDao categoryDaoJooq, MonthlyHistoryDao monthlyHistoryDaoJooq, YearlyHistoryDao yearlyHistoryDaoJooq, UserDao userDao, ZoneId zoneId) {
        this.categoryService = categoryService;
        this.expenseService = expenseService;
        this.expenseDaoJooq = expenseDaoJooq;
        this.categoryDaoJooq = categoryDaoJooq;
        this.monthlyHistoryDaoJooq = monthlyHistoryDaoJooq;
        this.yearlyHistoryDaoJooq = yearlyHistoryDaoJooq;
        this.userDao = userDao;
        this.zoneId = zoneId;

//        this.expenseDaoJooq.addUserBasedListener(expenseDaoListener);
//        this.categoryDaoJooq.addUserBasedListener(categoryDaoListener);
    }


    @PostConstruct
    public void recreateViews() {
        // very dirty way to recreate the views on startup but the zimezone can change so we don't really have a choice
        String sql = """
                DROP VIEW IF EXISTS monthly_history;
                CREATE VIEW monthly_history AS
                SELECT category_id,
                       to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYYMM')::INTEGER AS date,
                       ROUND(SUM(amount)::NUMERIC, 2)                                                     AS total,
                       COUNT(*)                                                                           AS expenses
                FROM expense
                GROUP BY category_id, to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYYMM')::INTEGER;
                
                
                DROP VIEW IF EXISTS yearly_history;
                CREATE or replace VIEW yearly_history AS
                SELECT category_id,
                       to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYY')::INTEGER AS date,
                       ROUND(SUM(amount)::NUMERIC, 2)                  AS total,
                       COUNT(*)                                        AS expenses
                FROM expense
                GROUP BY category_id, to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYY')::INTEGER;
                """.formatted(zoneId.toString(), zoneId.toString(), zoneId.toString(), zoneId.toString());

        yearlyHistoryDaoJooq.getDsl().execute(sql);


    }


    /**
     * Gets expense sum for each categories for the current year
     *
     * @param user
     * @return
     * @throws Exception
     */
    @Transactional(readOnly = true)
    public List<CategoryOverall> yearly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = yearlyHistoryDaoJooq.getHouseholdCategories(user).values().stream().toList();

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1L);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);

        ZonedDateTime now = ZonedDateTime.now(zoneId);
        int year = now.getYear();

        List<YearlyHistory> yearly = yearlyHistoryDaoJooq.getFromHouseholdWhere(user, YEARLY_HISTORY.DATE.eq(year));
        Map<Long, YearlyHistory> byCategory = yearly.stream()
                .collect(Collectors.toMap(y -> y.getCategory().getId(), Function.identity()));
        double total = yearly.stream().mapToDouble(YearlyHistory::getTotal).sum();

        overall.setAmount(total);
        overall.setTotal(total);

        for (Category category : categories) {
            CategoryOverall tmp = new CategoryOverall();
            tmp.setCategory(category);
            tmp.setTotal(total);

            if (byCategory.containsKey(category.getId())) {
                tmp.setAmount(byCategory.get(category.getId()).getTotal());
            } else {
                tmp.setAmount(0);
            }

            result.add(tmp);
        }

        result.add(overall);


        return result.stream()
                .map(c -> {
                    c.setTotal(overall.getTotal());
                    return c;
                })
                .sorted(Comparator.comparing(CategoryOverall::getAmount)
                        .reversed()
                        .thenComparingLong(o -> o.getCategory().getId()))
                .collect(Collectors.toList());
    }


    /**
     * Gets expense sum for each categories for the current month
     *
     * @param user
     * @return
     * @throws Exception
     */
    @Transactional(readOnly = true)
    public List<CategoryOverall> monthly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = monthlyHistoryDaoJooq.getHouseholdCategories(user).values().stream().toList();

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1L);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);

        LocalDate now = LocalDate.now();
        int date = (now.getYear() * 100) + now.getMonthValue();

        List<MonthlyHistory> monthly = monthlyHistoryDaoJooq.getFromHouseholdWhere(user, MONTHLY_HISTORY.DATE.eq(date));
        Map<Long, MonthlyHistory> byCategory = monthly.stream()
                .collect(Collectors.toMap(y -> y.getCategory().getId(), Function.identity()));
        double total = monthly.stream().mapToDouble(MonthlyHistory::getTotal).sum();

        overall.setAmount(total);
        overall.setTotal(total);

        for (Category category : categories) {
            CategoryOverall tmp = new CategoryOverall();
            tmp.setCategory(category);
            tmp.setTotal(total);

            if (byCategory.containsKey(category.getId())) {
                tmp.setAmount(byCategory.get(category.getId()).getTotal());
            } else {
                tmp.setAmount(0);
            }

            result.add(tmp);
        }

        result.add(overall);


        return result.stream()
                .map(c -> {
                    c.setTotal(overall.getTotal());
                    return c;
                })
                .sorted(Comparator.comparing(CategoryOverall::getAmount)
                        .reversed()
                        .thenComparingLong(o -> o.getCategory().getId()))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getYearlyHistory(long categoryId, int count, User user) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();
        List<Integer> data = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            data.add(date.getYear());
            date = date.minusYears(1);
        }

        List<Condition> conditions = new ArrayList<>();
        conditions.add(YEARLY_HISTORY.DATE.in(data));
        if (categoryId >= 0) {
            conditions.add(YEARLY_HISTORY.CATEGORY_ID.eq(categoryId));
        }

        Map<Integer, List<YearlyHistory>> history = yearlyHistoryDaoJooq.getFromHouseholdWhere(user, conditions.toArray(new Condition[0]))
                .stream()
                .collect(Collectors.groupingBy(YearlyHistory::getDate));

        for (Integer year : data) {
            Map<String, Object> expensesForMonth = new HashMap<>();

            expensesForMonth.put("date", year);
            if (history.containsKey(year)) {
                expensesForMonth.put("amount", history.get(year).stream().mapToDouble(YearlyHistory::getTotal).sum());
            } else {
                expensesForMonth.put("amount", 0);
            }
            result.add(expensesForMonth);
        }


        return result;
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getMonthlyHistory(long categoryId, int count, User user) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();

        ZonedDateTime date = ZonedDateTime.now(zoneId);
        List<Integer> data = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            data.add((date.getYear() * 100) + date.getMonthValue());
            date = date.minusMonths(1);
        }

        List<Condition> conditions = new ArrayList<>();
        conditions.add(MONTHLY_HISTORY.DATE.in(data));
        if (categoryId >= 0) {
            conditions.add(MONTHLY_HISTORY.CATEGORY_ID.eq(categoryId));
        }

        Map<Integer, List<MonthlyHistory>> history = monthlyHistoryDaoJooq.getFromHouseholdWhere(user, conditions.toArray(new Condition[0]))
                .stream()
                .collect(Collectors.groupingBy(MonthlyHistory::getDate));

        for (Integer dateInt : data) {
            Map<String, Object> expensesForMonth = new HashMap<>();

            int year = Math.floorDiv(dateInt, 100);
            int month = Math.floorMod(dateInt, 100);

            expensesForMonth.put("date", year + "-" + String.format("%02d", month));

            if (history.containsKey(dateInt)) {
                expensesForMonth.put("amount", history.get(dateInt)
                        .stream()
                        .mapToDouble(MonthlyHistory::getTotal)
                        .sum());
            } else {
                expensesForMonth.put("amount", 0);
            }
            result.add(expensesForMonth);
        }


        return result;
    }

    @Transactional(readOnly = true)
    public double getMonthTotal(User user, int month) {
        var expenses = monthlyHistoryDaoJooq.getFromHouseholdWhere(user, MONTHLY_HISTORY.DATE.eq(month));
        return expenses.stream().mapToDouble(MonthlyHistory::getTotal).sum();
    }
}
