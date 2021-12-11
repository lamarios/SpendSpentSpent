package com.ftpix.sss.services;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.dao.MonthlyHistoryDao;
import com.ftpix.sss.dao.YearlyHistoryDao;
import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.*;
import com.ftpix.sss.utils.DateUtils;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

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

    private final ExecutorService cacheUpdateThread = Executors.newSingleThreadExecutor();
    private final DaoUserListener<Category> categoryDaoListener = new DaoUserListener<Category>() {
        @Override
        public void afterInsert(User user, Category newRecord) {

        }

        @Override
        public void afterDelete(User user, Category deleted) {
            monthlyHistoryDaoJooq.deleteWhere(Tables.MONTHLY_HISTORY.CATEGORY_ID.eq(deleted.getId()));
            yearlyHistoryDaoJooq.deleteWhere(Tables.YEARLY_HISTORY.CATEGORY_ID.eq(deleted.getId()));
        }
    };

    private final DaoUserListener<Expense> expenseDaoListener = new DaoUserListener<Expense>() {
        @Override
        public void afterInsert(User user, Expense newRecord) {
            cacheUpdateThread.execute(() -> {
                try {
                    cacheForExpense(user, newRecord);
                } catch (SQLException e) {
                    logger.error(e);
                }
            });
        }

        @Override
        public void afterDelete(User user, Expense deleted) {
            cacheUpdateThread.execute(() -> {
                try {
                    cacheForExpense(user, deleted);
                } catch (SQLException e) {
                    logger.error(e);
                }
            });
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

        this.expenseDaoJooq.addListener(expenseDaoListener);
        this.categoryDaoJooq.addListener(categoryDaoListener);
    }

    public List<CategoryOverall> yearly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = categoryService.getAll(user);

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);


        for (Category category : categories) {
            CategoryOverall tmp = new CategoryOverall();
            tmp.setCategory(category);
            LocalDate date = LocalDate.now();


            double total = getCategoryExpensesForYear(category.getId(), date, user)
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
                .sorted(Comparator.comparing(CategoryOverall::getAmount).reversed().thenComparingLong(o -> o.getCategory().getId()))
                .collect(Collectors.toList());
    }


    public List<CategoryOverall> monthly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = categoryService.getAll(user);

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);


        for (Category category : categories) {
            CategoryOverall tmp = new CategoryOverall();
            tmp.setCategory(category);
            LocalDate date = LocalDate.now();


            double total = getCategoryExpensesForMonth(category.getId(), date, user)
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
                .sorted(Comparator.comparing(CategoryOverall::getAmount).reversed().thenComparingLong(o -> o.getCategory().getId()))
                .collect(Collectors.toList());
    }

    /**
     * Returns the expenses for a specific year
     *
     * @param category thhe category to query against
     * @param date     the date where the eay and month will be extracted
     * @return a list of expenses
     * @throws SQLException
     */
    private List<Expense> getCategoryExpensesForYear(long category, LocalDate date, User user) throws Exception {
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
        if (userCategoriesId.isEmpty()) {
            return Collections.emptyList();
        }

        Where<Expense, Long> categoryFilter = expenseDao.queryBuilder().where()
                .in("category_id", userCategoriesId);

        if (category >= 0) {
            categoryFilter = categoryFilter.and().eq("category_id", category);
        }

        LocalDate start = date.withDayOfYear(1);
        LocalDate end = date.plusYears(1).withDayOfYear(1);
        Date startDate = Date.from(start.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDate = Date.from(end.atStartOfDay(ZoneId.systemDefault()).toInstant());

        categoryFilter = categoryFilter.and().ge("date", startDate);
        categoryFilter = categoryFilter.and().lt("date", endDate);

        final QueryBuilder<Expense, Long> queryBuilder = expenseDao.queryBuilder();
        queryBuilder.setWhere(categoryFilter);

        return queryBuilder.query()
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
    private List<Expense> getCategoryExpensesForMonth(long category, LocalDate date, User user) throws Exception {
        final List<Long> userCategoriesId = categoryService.getUserCategoriesId(user);
        if (userCategoriesId.isEmpty()) {
            return Collections.emptyList();
        }

        Where<Expense, Long> categoryFilter = expenseDao.queryBuilder().where()
                .in("category_id", userCategoriesId);

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

        return queryBuilder.query()
                .stream()
                .filter(e -> {
                    LocalDateTime tmpDate = LocalDateTime.ofInstant(e.getDate().toInstant(), ZoneId.systemDefault());
                    return tmpDate.getYear() == date.getYear() && tmpDate.getMonthValue() == date.getMonthValue();
                })
                .collect(Collectors.toList());
    }


    public List<Map<String, Object>> getYearlyHistory(long categoryId, int count, User user) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();

        for (int i = 0; i < count; i++) {
            Map<String, Object> expensesForMonth = new HashMap<>();

            expensesForMonth.put("date", date.getYear());
            expensesForMonth.put("amount", getCategoryExpensesForYear(categoryId, date, user).stream().mapToDouble(Expense::getAmount).sum());

            date = date.minusYears(1);
            result.add(expensesForMonth);
        }


        return result;
    }

    public List<Map<String, Object>> getMonthlyHistory(long categoryId, int count, User user) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();

        for (int i = 0; i < count; i++) {
            int finalI = i;
            Map<String, Object> expensesForMonth = new HashMap<>();
            final LocalDate localDate = date.minusMonths(finalI);
            expensesForMonth.put("date", localDate.format(DateTimeFormatter.ofPattern("yyyy-MM")));
            final List<Expense> expenses = getCategoryExpensesForMonth(categoryId, localDate, user);
            expensesForMonth.put("amount", expenses.stream().mapToDouble(Expense::getAmount).sum());

            result.add(expensesForMonth);
        }

        return result;
    }

    public void cacheForExpense(User user, Expense expense) throws SQLException {
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
        logger.info("Refreshing cache for category :" + category.getId());

        cacheForCategoryMonthly(user, date, category);
        cacheForCategoryYearly(user, Math.floorDiv(date, 100), category);
    }

    /**
     * @param date     in formay yyyy-DD
     * @param category
     */
    private void cacheForCategoryYearly(User user, int date, Category category) throws SQLException {

        List<Expense> forDateLikeAndCategory = expenseService.getForDateLikeAndCategory(user, Integer.toString(date), category);
        double sum = forDateLikeAndCategory.stream().mapToDouble(Expense::getAmount)
                .sum();

        Optional<YearlyHistory> history = yearlyHistoryDaoJooq.getOneWhere(Tables.YEARLY_HISTORY.CATEGORY_ID.eq(category.getId()), Tables.YEARLY_HISTORY.DATE.eq(date));

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
        List<Expense> forDateLikeAndCategory = expenseService.getForDateLikeAndCategory(user, year + "-" + month, category);
        double sum = forDateLikeAndCategory.stream().mapToDouble(Expense::getAmount)
                .sum();

        Optional<MonthlyHistory> history = monthlyHistoryDaoJooq.getOneWhere(Tables.MONTHLY_HISTORY.CATEGORY_ID.eq(category.getId()), Tables.MONTHLY_HISTORY.DATE.eq(date));

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
