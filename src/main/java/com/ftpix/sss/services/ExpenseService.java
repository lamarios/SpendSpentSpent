package com.ftpix.sss.services;

import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.DailyExpense;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    public Map<String, DailyExpense> getByDay(String month, User user) throws Exception {


        Map<String, List<Expense>> grouped = expenseDaoJooq.getWhere(user, EXPENSE.DATE.like(month + "%"))
                .stream()
                .collect(Collectors.groupingBy(expense -> df.format(expense.getDate())));

        Map<String, DailyExpense> result = new HashMap<>();

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

        expenseDaoJooq.create(user, expense);

        return expense;
    }

    public boolean delete(long id, User user) throws Exception {
        final Expense expense = get(id, user);
        if (expense.getCategory().getUser().getId().equals(user.getId())) {
            return expenseDaoJooq.delete(user, expense);
        } else {
            return false;
        }
    }

    public List<String> getMonths(User user) throws Exception {
        return expenseDaoJooq.getMonths(user);
    }

    public List<Expense> getForDateLikeAndCategory(User user, String date, Category category) throws SQLException {
        return expenseDaoJooq.getWhere(user, EXPENSE.DATE.like(date + "%"), EXPENSE.CATEGORY_ID.eq(category.getId()));
    }

}
