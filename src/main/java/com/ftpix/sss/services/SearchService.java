package com.ftpix.sss.services;

import com.ftpix.sss.Constants;
import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.models.*;
import org.jooq.Condition;
import org.jooq.OrderField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static com.ftpix.sss.Constants.dateFormatter;
import static com.ftpix.sss.dsl.Tables.EXPENSE;
import static org.jooq.impl.DSL.upper;

@Service
public class SearchService {
    private final CategoryService categoryService;
    private final ExpenseDao expenseDao;

    @Autowired
    public SearchService(CategoryService categoryService, ExpenseDao expenseDao) {
        this.categoryService = categoryService;
        this.expenseDao = expenseDao;
    }

    public SearchParameters getSearchParameters(User currentUser, Long categoryId) throws SQLException {


        List<Category> categories = categoryService.getAll(currentUser);

        Condition categoryCondition = categoryId != null ? EXPENSE.CATEGORY_ID.eq(categoryId) : null;


        int minAmount = expenseDao.getPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.AMOUNT.asc()}, categoryCondition)
                .getData()
                .stream()
                .map(Expense::getAmount)
                .map(Double::intValue)
                .findFirst()
                .orElse(0);

        int maxAmount = expenseDao.getPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.AMOUNT.desc()}, categoryCondition)
                .getData()
                .stream()
                .map(Expense::getAmount)
                .map(Double::intValue)
                .map(i -> i + 1)
                .findFirst()
                .orElse(0);

        LocalDate minDate = expenseDao.getPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.DATE.asc()})
                .getData()
                .stream()
                .map(Expense::getDate)
                .findFirst()
                .orElse(LocalDate.now());

        LocalDate maxDate = expenseDao.getPaginatedWhere(currentUser, 0, 1, new OrderField[]{EXPENSE.DATE.desc()})
                .getData()
                .stream()
                .map(Expense::getDate)
                .findFirst()
                .orElse(LocalDate.now());

        return new SearchParameters(categories, minAmount, maxAmount, minDate, maxDate, "");
    }

    public Map<String, DailyExpense> search(User currentUser, SearchParameters parameters) {
        List<Condition> conditions = new ArrayList<>();

        if (parameters.maxAmount() >= 0) {
            conditions.add(EXPENSE.AMOUNT.le((double) parameters.maxAmount()));
        }

        if (parameters.minAmount() >= 0) {
            conditions.add(EXPENSE.AMOUNT.ge((double) parameters.minAmount()));
        }

        if (parameters.categories() != null && !parameters.categories().isEmpty()) {
            conditions.add(EXPENSE.CATEGORY_ID.in(parameters.categories().stream().map(Category::getId).toList()));
        }

        //TODO: handle dates
        if (parameters.note() != null && !parameters.note().trim().isEmpty()) {
            conditions.add(upper(EXPENSE.NOTE).like("%" + parameters.note().toUpperCase() + "%"));
        }

        Map<String, List<Expense>> grouped = expenseDao.getWhere(currentUser, new OrderField[]{EXPENSE.DATE.desc()}, conditions.toArray(new Condition[0]))
                .stream()
                .collect(Collectors.groupingBy(expense -> dateFormatter.format(expense.getDate())));

        Map<String, DailyExpense> result = new TreeMap<>(Collections.reverseOrder());

        grouped.forEach((s, expenses) -> {
            DailyExpense exp = new DailyExpense();
            exp.setDate(s);
            exp.setExpenses(expenses);
            exp.setTotal(expenses.stream().mapToDouble(Expense::getAmount).sum());
            result.put(s, exp);
        });

        return result;
    }
}
