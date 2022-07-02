package com.ftpix.sss.services;

import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.models.*;
import com.ftpix.sss.utils.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.OrderField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Period;
import java.util.*;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.EXPENSE;

@Service
public class ExpenseService {
    public static final String DATE = "date";
    private static final String CATEGORY_ID = "CATEGORY_ID";
    public final CategoryService categoryService;
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    private final SimpleDateFormat monthOnly = new SimpleDateFormat("yyyy-MM");

    private final ExpenseDao expenseDaoJooq;

    @Autowired
    public ExpenseService(CategoryService categoryService, ExpenseDao expenseDaoJooq) {
        this.categoryService = categoryService;
        this.expenseDaoJooq = expenseDaoJooq;
    }

    public List<Expense> getAll(User user) throws Exception {
        return expenseDaoJooq.getWhere(user);
    }

    public Expense get(long id, User user) throws Exception {
        return expenseDaoJooq.get(user, id).orElse(null);
    }

    public Map<String, Long> suggestNotes(User currentUser, Expense expense) {
        double minExpense = expense.getAmount() * 0.8;
        double maxExpense = expense.getAmount() * 1.2;

        return expenseDaoJooq.getNotes(currentUser, expense.getCategory().getId(), minExpense, maxExpense)
                .stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> s.length() > 0)
                .collect(Collectors.groupingBy(s -> s, Collectors.counting()));


    }

    public Map<String, DailyExpense> getByDay(String month, User user) throws Exception {


        Map<String, List<Expense>> grouped = expenseDaoJooq.getWhere(user, EXPENSE.DATE.like(month + "%"))
                .stream()
                .collect(Collectors.groupingBy(expense -> df.format(expense.getDate())));

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

        return expenseDaoJooq.insert(user, expense);
    }

    public boolean delete(long id, User user) throws Exception {
        final Expense expense = get(id, user);
        if (expense.getCategory().getUser().getId().equals(user.getId())) {
            return expenseDaoJooq.delete(user, expense);
        } else {
            return false;
        }
    }

    /**
     * @return
     */
    public ExpenseLimits getLimits(User user) {
        PaginatedResults<Expense> data = expenseDaoJooq.getPaginatedWhere(user, 0, 1, new OrderField[]{EXPENSE.DATE.asc()});
        if (data.getData().isEmpty()) {
            return new ExpenseLimits(0, 0);
        }
        Expense exp = data.getData().get(0);
        LocalDate localDate = DateUtils.convertToLocalDateViaInstant(exp.getDate());
        Period diff = Period.between(localDate, LocalDate.now());
        return new ExpenseLimits(diff.getYears(), (int) diff.toTotalMonths());
    }

    public List<String> getMonths(User user) throws Exception {
        return expenseDaoJooq.getMonths(user);
    }

    public double getSumWhere(User user, String date, Category category) {
        return expenseDaoJooq.sumWhere(user, EXPENSE.DATE.like(date + "%"), EXPENSE.CATEGORY_ID.eq(category.getId()));
    }

    public List<Expense> getForDateLikeAndCategory(User user, String date, Category category) throws SQLException {
        return expenseDaoJooq.getWhere(user, EXPENSE.DATE.like(date + "%"), EXPENSE.CATEGORY_ID.eq(category.getId()));
    }

}
