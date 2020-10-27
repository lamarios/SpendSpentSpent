package com.ftpix.sss.services;

import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryOverall;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.Where;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class HistoryService {
    private final CategoryService categoryService;

    @Autowired
    public HistoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
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
                .sorted((c1, c2) -> Double.compare(c2.getAmount(), c1.getAmount()))
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
                .sorted((c1, c2) -> Double.compare(c2.getAmount(), c1.getAmount()))
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

        Where<Expense, Long> categoryFilter = DB.EXPENSE_DAO.queryBuilder().where()
                .in("category_id", userCategoriesId);

        if (category >= 0) {
            categoryFilter = categoryFilter.and().eq("category_id", category);
        }

        final QueryBuilder<Expense, Long> queryBuilder = DB.EXPENSE_DAO.queryBuilder();
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

        Where<Expense, Long> categoryFilter = DB.EXPENSE_DAO.queryBuilder().where()
                .in("category_id", userCategoriesId);

        if (category >= 0) {
            categoryFilter = categoryFilter.and().eq("category_id", category);
        }

        final QueryBuilder<Expense, Long> queryBuilder = DB.EXPENSE_DAO.queryBuilder();
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
            Map<String, Object> expensesForMonth = new HashMap<>();

            expensesForMonth.put("date", date.getYear() + "-" + date.getMonthValue());
            expensesForMonth.put("amount", getCategoryExpensesForMonth(categoryId, date, user).stream().mapToDouble(Expense::getAmount).sum());

            date = date.minusMonths(1);
            result.add(expensesForMonth);
        }


        return result;
    }
}
