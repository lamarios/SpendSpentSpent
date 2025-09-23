package com.ftpix.sss.services;

import com.ftpix.sss.dao.*;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.*;
import com.ftpix.sss.utils.DateUtils;
import com.ftpix.sss.utils.PaginationUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.Condition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
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
    private final HouseholdDao householdDao;
    private final MonthlyHistoryDao monthlyHistoryDaoJooq;
    private final YearlyHistoryDao yearlyHistoryDaoJooq;
    private final UserDao userDao;
    private final ZoneId zoneId;

    @Autowired
    public HistoryService(CategoryService categoryService, ExpenseService expenseService, ExpenseDao expenseDaoJooq, CategoryDao categoryDaoJooq, HouseholdDao householdDao, MonthlyHistoryDao monthlyHistoryDaoJooq, YearlyHistoryDao yearlyHistoryDaoJooq, UserDao userDao, ZoneId zoneId) {
        this.categoryService = categoryService;
        this.expenseService = expenseService;
        this.expenseDaoJooq = expenseDaoJooq;
        this.categoryDaoJooq = categoryDaoJooq;
        this.householdDao = householdDao;
        this.monthlyHistoryDaoJooq = monthlyHistoryDaoJooq;
        this.yearlyHistoryDaoJooq = yearlyHistoryDaoJooq;
        this.userDao = userDao;
        this.zoneId = zoneId;

        this.expenseDaoJooq.addUserBasedListener(expenseDaoListener);
        this.categoryDaoJooq.addUserBasedListener(categoryDaoListener);
        recalculateStats();
    }


    private void recalculateStats() {
        logger.info("Recalculating stats cache");
        for (User user : userDao.getWhere()) {
            boolean hasMore;
            int page = PaginationUtils.DEFAULT_PAGE;
            do {
                logger.info("Refreshing cache for user" + user.getId().toString() + " page: " + page);
                PaginatedResults<Expense> expenses = expenseDaoJooq.getPaginatedWhere(user, page, 100);
                expenses.getData().forEach(expense -> {
                    try {
                        cacheForExpense(user, expense);
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                });

                hasMore = expenses.getData().size() == 100;
                page++;
            } while (hasMore);
        }
    }

    private final DaoUserListener<Category> categoryDaoListener = new DaoUserListener<Category>() {
        @Override
        public void afterInsert(User user, Category newRecord) {

        }

        @Override
        public void afterUpdate(User user, Category newRecord) {

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
        public void afterUpdate(User user, Expense updatedRecord) {
            try {
                cacheForExpense(user, updatedRecord);
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


    /**
     * Gets expense sum for each categories for the current year
     *
     * @param user
     * @return
     * @throws Exception
     */
    public List<CategoryOverall> yearly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = monthlyHistoryDaoJooq.getHouseholdCategories(user).values().stream().toList();

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

    public void cacheForExpense(User user, Expense expense) throws SQLException {
        logger.info("History for expense " + expense.getId() + " of category " + expense.getCategory().getId());
        ZonedDateTime expenseDate = DateUtils.fromTimestamp(expense.getTimestamp(), zoneId);

        cacheForCategory(user, expenseDate, expense.getCategory());
    }

    /**
     * date in format YYYYMM
     *
     * @param date
     * @param category
     */
    public void cacheForCategory(User user, ZonedDateTime date, Category category) throws SQLException {
//        logger.info("Refreshing cache for category :" + category.getId());

        cacheForCategoryMonthly(user, date, category);
        cacheForCategoryYearly(user, date, category);
    }

    /**
     * @param date     in formay yyyy-DD
     * @param category
     */
    private void cacheForCategoryYearly(User user, ZonedDateTime date, Category category) throws SQLException {

        double sum = expenseService.getSumWhere(user, DateUtils.getMonthBoundaries(date, zoneId), category);

        int formattedDate = Integer.parseInt(DateTimeFormatter.ofPattern("yyyy").format(date));
        Optional<YearlyHistory> history = yearlyHistoryDaoJooq.getOneWhere(YEARLY_HISTORY.CATEGORY_ID.eq(category.getId()), YEARLY_HISTORY.DATE.eq(formattedDate));

        YearlyHistory yearlyHistory;
        if (history.isEmpty()) {
            yearlyHistory = new YearlyHistory();
            yearlyHistory.setCategory(category);
            yearlyHistory.setDate(formattedDate);
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
    private void cacheForCategoryMonthly(User user, ZonedDateTime date, Category category) throws SQLException {

        double sum = expenseService.getSumWhere(user, DateUtils.getMonthBoundaries(date, zoneId), category);

        int formattedDate = Integer.parseInt(DateTimeFormatter.ofPattern("yyyyMM").format(date));
        Optional<MonthlyHistory> history = monthlyHistoryDaoJooq.getOneWhere(MONTHLY_HISTORY.CATEGORY_ID.eq(category.getId()), MONTHLY_HISTORY.DATE.eq(formattedDate));

        MonthlyHistory monthlyHistory;
        if (history.isEmpty()) {
            monthlyHistory = new MonthlyHistory();
            monthlyHistory.setCategory(category);
            monthlyHistory.setDate(formattedDate);
            monthlyHistoryDaoJooq.insert(monthlyHistory);
        } else {
            monthlyHistory = history.get();
        }

        monthlyHistory.setTotal(sum);

        monthlyHistoryDaoJooq.update(monthlyHistory);
    }


}
