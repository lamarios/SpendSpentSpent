package com.ftpix.sss.services;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryOverall;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class HistoryService {
    private final CategoryService categoryService;
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final Dao<Expense, Long> expenseDao;


    @Autowired
    public HistoryService(CategoryService categoryService, Dao<Expense, Long> expenseDao) {
        this.categoryService = categoryService;
        this.expenseDao = expenseDao;
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
}
