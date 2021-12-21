package com.ftpix.sss.services;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.dao.MonthlyHistoryDao;
import com.ftpix.sss.dao.YearlyHistoryDao;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.*;
import com.ftpix.sss.utils.DateUtils;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.Condition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.*;

@Service
public class HistoryService {
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final CategoryService categoryService;
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private final DateTimeFormatter historyDateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMM");
    private final DateTimeFormatter monthlyHistoryDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
    private final DateTimeFormatter yearlyHistoryDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
    private final ExpenseService expenseService;

    private final Dao<Expense, Long> expenseDao;
    private final ExpenseDao expenseDaoJooq;
    private final CategoryDao categoryDaoJooq;
    private final MonthlyHistoryDao monthlyHistoryDaoJooq;
    private final YearlyHistoryDao yearlyHistoryDaoJooq;

    private final DaoUserListener<Category> categoryDaoListener = new DaoUserListener<Category>() {
        @Override
        public void afterInsert(User user, Category newRecord) {

        }

        @Override
        public void afterDelete(User user, Category deleted) {
            monthlyHistoryDaoJooq.deleteWhere(MONTHLY_HISTORY.CATEGORY_ID.eq(deleted.getId()));
            yearlyHistoryDaoJooq.deleteWhere(YEARLY_HISTORY.CATEGORY_ID.eq(deleted.getId()));
        }
    };

    private final DaoUserListener<Expense> expenseDaoListener = new DaoUserListener<Expense>() {
        @Override
        public void afterInsert(User user, Expense newRecord) {
            try {
                cacheForExpense(user, newRecord);
            } catch (SQLException e) {
                logger.error(e);
            }
        }

        @Override
        public void afterDelete(User user, Expense deleted) {
            try {
                cacheForExpense(user, deleted);
            } catch (SQLException e) {
                logger.error(e);
            }
        }
    };


    @Autowired
    public HistoryService(CategoryService categoryService, ExpenseService expenseService, Dao<Expense, Long> expenseDao, ExpenseDao expenseDaoJooq, CategoryDao categoryDaoJooq, MonthlyHistoryDao monthlyHistoryDaoJooq, YearlyHistoryDao yearlyHistoryDaoJooq) {
        this.categoryService = categoryService;
        this.expenseService = expenseService;
        this.expenseDao = expenseDao;
        this.expenseDaoJooq = expenseDaoJooq;
        this.categoryDaoJooq = categoryDaoJooq;
        this.monthlyHistoryDaoJooq = monthlyHistoryDaoJooq;
        this.yearlyHistoryDaoJooq = yearlyHistoryDaoJooq;

        this.expenseDaoJooq.addUserBasedListener(expenseDaoListener);
        this.categoryDaoJooq.addUserBasedListener(categoryDaoListener);
    }

    public List<CategoryOverall> yearly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = categoryService.getAll(user);

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1L);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);

        LocalDate now = LocalDate.now();
        int year = now.getYear();

        List<YearlyHistory> yearly = yearlyHistoryDaoJooq.getWhere(user, YEARLY_HISTORY.DATE.eq(year));
        Map<Long, YearlyHistory> byCategory = yearly.stream().collect(Collectors.toMap(y -> y.getCategory().getId(), Function.identity()));
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


        return result.stream().map(c -> {
            c.setTotal(overall.getTotal());
            return c;
        }).sorted(Comparator.comparing(CategoryOverall::getAmount).reversed().thenComparingLong(o -> o.getCategory().getId())).collect(Collectors.toList());
    }


    public List<CategoryOverall> monthly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = categoryService.getAll(user);

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1L);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);

        LocalDate now = LocalDate.now();
        int date = (now.getYear() * 100) + now.getMonthValue();

        List<MonthlyHistory> yearly = monthlyHistoryDaoJooq.getWhere(user, MONTHLY_HISTORY.DATE.eq(date));
        Map<Long, MonthlyHistory> byCategory = yearly.stream().collect(Collectors.toMap(y -> y.getCategory().getId(), Function.identity()));
        double total = yearly.stream().mapToDouble(MonthlyHistory::getTotal).sum();

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


        return result.stream().map(c -> {
            c.setTotal(overall.getTotal());
            return c;
        }).sorted(Comparator.comparing(CategoryOverall::getAmount).reversed().thenComparingLong(o -> o.getCategory().getId())).collect(Collectors.toList());
    }

    /**
     * Returns the expenses for a specific month
     *
     * @param category thhe category to query against
     * @param date     the date where the eay and month will be extracted
     * @return a list of expenses
     * @throws SQLException
     */
    private List<Expense> getCategoryExpensesForMonth(long category, LocalDate date, User user) throws Exception {
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
        if (userCategoriesId.isEmpty()) {
            return Collections.emptyList();
        }

        Where<Expense, Long> categoryFilter = expenseDao.queryBuilder().where().in("category_id", userCategoriesId);

        if (category >= 0) {
            categoryFilter = categoryFilter.and().eq("category_id", category);
        }

        LocalDate start = date.withDayOfMonth(1);
        LocalDate end = date.withDayOfMonth(date.lengthOfMonth()).plusDays(1);
        Date startDate = Date.from(start.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDate = Date.from(end.atStartOfDay(ZoneId.systemDefault()).toInstant());

        categoryFilter = categoryFilter.and().ge("date", startDate);
        categoryFilter = categoryFilter.and().lt("date", endDate);

        final QueryBuilder<Expense, Long> queryBuilder = expenseDao.queryBuilder();
        queryBuilder.setWhere(categoryFilter);

        return queryBuilder.query().stream().filter(e -> {
            LocalDateTime tmpDate = LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault());
            return tmpDate.getYear() == date.getYear() && tmpDate.getMonthValue() == date.getMonthValue();
        }).collect(Collectors.toList());
    }


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

        Map<Integer, List<YearlyHistory>> history = yearlyHistoryDaoJooq.getWhere(user, conditions.toArray(new Condition[0]))
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

    public List<Map<String, Object>> getMonthlyHistory(long categoryId, int count, User user) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();
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

        Map<Integer, List<MonthlyHistory>> history = monthlyHistoryDaoJooq.getWhere(user, conditions.toArray(new Condition[0]))
                .stream()
                .collect(Collectors.groupingBy(MonthlyHistory::getDate));

        for (Integer dateInt : data) {
            Map<String, Object> expensesForMonth = new HashMap<>();

            int year = Math.floorDiv(dateInt, 100);
            int month = Math.floorMod(dateInt, 100);

            expensesForMonth.put("date", year + "-" + String.format("%02d", month));

            if (history.containsKey(dateInt)) {
                expensesForMonth.put("amount", history.get(dateInt).stream().mapToDouble(MonthlyHistory::getTotal).sum());
            } else {
                expensesForMonth.put("amount", 0);
            }
            result.add(expensesForMonth);
        }


        return result;
    }

    public void cacheForExpense(User user, Expense expense) throws SQLException {
        logger.info("History for expense " + expense.getId() + " of category " + expense.getCategory().getId());
        LocalDate localDate = DateUtils.convertToLocalDateViaInstant(expense.getDate());
        String date = localDate.format(historyDateTimeFormatter);

        cacheForCategory(user, Integer.parseInt(date), expense.getCategory());
    }

    /**
     * date in format YYYYMM
     *
     * @param date
     * @param category
     */
    public void cacheForCategory(User user, int date, Category category) throws SQLException {
//        logger.info("Refreshing cache for category :" + category.getId());

        cacheForCategoryMonthly(user, date, category);
        cacheForCategoryYearly(user, Math.floorDiv(date, 100), category);
    }

    /**
     * @param date     in formay yyyy-DD
     * @param category
     */
    private void cacheForCategoryYearly(User user, int date, Category category) throws SQLException {

        List<Expense> forDateLikeAndCategory = expenseService.getForDateLikeAndCategory(user, Integer.toString(date), category);
        double sum = forDateLikeAndCategory.stream().mapToDouble(Expense::getAmount).sum();

        Optional<YearlyHistory> history = yearlyHistoryDaoJooq.getOneWhere(YEARLY_HISTORY.CATEGORY_ID.eq(category.getId()), YEARLY_HISTORY.DATE.eq(date));

        YearlyHistory yearlyHistory;
        if (history.isEmpty()) {
            yearlyHistory = new YearlyHistory();
            yearlyHistory.setCategory(category);
            yearlyHistory.setDate(date);
            yearlyHistoryDaoJooq.insert(yearlyHistory);
        } else {
            yearlyHistory = history.get();
        }

        yearlyHistory.setTotal(sum);

        yearlyHistoryDaoJooq.update(yearlyHistory);
    }

    /**
     * @param date     in format YYYY
     * @param category
     */
    private void cacheForCategoryMonthly(User user, int date, Category category) throws SQLException {
        int year = Math.floorDiv(date, 100);
        int month = Math.floorMod(date, 100);
        List<Expense> forDateLikeAndCategory = expenseService.getForDateLikeAndCategory(user, year + "-" + String.format("%02d", month), category);
        double sum = forDateLikeAndCategory.stream().mapToDouble(Expense::getAmount).sum();

        Optional<MonthlyHistory> history = monthlyHistoryDaoJooq.getOneWhere(MONTHLY_HISTORY.CATEGORY_ID.eq(category.getId()), MONTHLY_HISTORY.DATE.eq(date));

        MonthlyHistory monthlyHistory;
        if (history.isEmpty()) {
            monthlyHistory = new MonthlyHistory();
            monthlyHistory.setCategory(category);
            monthlyHistory.setDate(date);
            monthlyHistoryDaoJooq.insert(monthlyHistory);
        } else {
            monthlyHistory = history.get();
        }

        monthlyHistory.setTotal(sum);

        monthlyHistoryDaoJooq.update(monthlyHistory);
    }


}
