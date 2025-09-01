package com.ftpix.sss.services;

import com.ftpix.sss.Constants;
import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.models.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.OrderField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.*;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.EXPENSE;

@Service
public class ExpenseService {
    public static final String DATE = "date";
    private static final String CATEGORY_ID = "CATEGORY_ID";
    public final CategoryService categoryService;
    public final SettingsService settingsService;
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final SimpleDateFormat monthOnly = new SimpleDateFormat("yyyy-MM");

    private final ExpenseDao expenseDaoJooq;
    private final FileService fileService;
    private final ExpenseDao expenseDao;

    @Autowired
    public ExpenseService(CategoryService categoryService, SettingsService settingsService, ExpenseDao expenseDaoJooq, FileService fileService, ExpenseDao expenseDao) {
        this.categoryService = categoryService;
        this.settingsService = settingsService;
        this.expenseDaoJooq = expenseDaoJooq;
        this.fileService = fileService;
        this.expenseDao = expenseDao;
    }

    public List<Expense> getAll(User user) throws Exception {
        List<Expense> expenses = expenseDaoJooq.getWhere(user);
        getFiles(expenses);
        return expenses;
    }

    public Expense get(long id, User user) throws Exception {
        return expenseDaoJooq.get(user, id).map(expense -> {
            getFiles(List.of(expense));
            return expense;
        }).orElse(null);
    }

    private void getFiles(List<Expense> expenses) {
        List<SSSFile> files = fileService.getFiles(expenses);

        files.forEach(file -> expenses.stream().filter(e -> Objects.equals(e.getId(), file.getExpenseId()))
                .forEach(expense -> expense.getFiles().add(file)));
    }

    public Map<String, Long> suggestNotes(User currentUser, Expense expense) {
        double minExpense = expense.getAmount() * 0.8;
        double maxExpense = expense.getAmount() * 1.2;

        return expenseDaoJooq.getNotes(currentUser, expense.getCategory().getId(), minExpense, maxExpense)
                .stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isBlank())
                .collect(Collectors.groupingBy(s -> s, Collectors.counting()));
    }

    public Map<String, Long> autoCompleteNote(User currentUser, String seed) {
        return expenseDaoJooq.autoCompleteNote(currentUser, seed)
                .stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isBlank())
                .collect(Collectors.groupingBy(s -> s, Collectors.counting()));
    }


    public Map<String, DailyExpense> getByDay(String month, User user) throws Exception {


        Map<String, List<Expense>> grouped = expenseDaoJooq.getWhere(user, EXPENSE.DATE.like(month + "%"))
                .stream()
                .collect(Collectors.groupingBy(expense -> Constants.dateFormatter.format(expense.getDate())));

        getFiles(grouped.values().stream().flatMap(Collection::stream).toList());


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

    public Expense update(Expense expense, User user) {
        expenseDao.update(user, expense);

        fileService.clearExpenseFiles(expense.getId());

        expense.getFiles()
                .stream()
                .peek(file -> file.setExpenseId(expense.getId()))
                .forEach(fileService::updateFile);

        return expense;
    }

    public Expense create(Expense expense, User user) throws Exception {
        Category category = categoryService.get(expense.getCategory().getId(), user);
        if (category == null) {
            throw new Exception("Category doesn't exist");
        } else {
            expense.setCategory(category);
        }

        LocalDateTime now = LocalDateTime.now();

        if (expense.getDate() == null) {
            expense.setDate(now.toLocalDate());
        }
        LocalDate expenseDate = expense.getDate();

        // if the expense is today, we set the time as now
        if (expenseDate.getMonth() == now.getMonth() && expenseDate.getYear() == now.getYear() && expenseDate.getDayOfMonth() == now.getDayOfMonth()) {
            expense.setTime(String.format("%02d", now.getHour()) + ":" + String.format("%02d", now.getMinute()));
        }


        if (expense.getType() == 0) {
            expense.setType(Expense.TYPE_NORMAL);
        }

        Expense result = expenseDaoJooq.insert(user, expense);

        // we process the files
        // we don't update the files with what we got as it might still be processing, we just take the DB version and assign
        // the expense id
        for (SSSFile sssFile : expense.getFiles()) {
            fileService.getfile(user, sssFile.getId().toString()).ifPresent(file -> {
                file.setExpenseId(result.getId());
                fileService.updateFile(file);
            });
        }

        return result;
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
        LocalDate localDate = exp.getDate();
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

    /**
     * this method show the amount of money that was spent in the last month within the same period
     * ex: we're currently the 10 of july, this should retrieve the amount spent in june from the first to the 10th of june
     *
     * @param user
     * @param userCurrentDay   current date in yyyy-MM-dd format this should be sent by the front end as it might not always be at the same day of the server
     * @param includeRecurring
     * @return
     */
    public double diffWithPreviousPeriod(User user, String userCurrentDay, boolean includeRecurring) throws SQLException {
        // find starting point, it should be the beginning of the userCurrentDay month - 1
        var split = userCurrentDay.split("-");
        if (split.length != 3) {
            throw new InvalidParameterException("dates shoud be yyyy-MM-dd format");
        }

        int year = Integer.parseInt(split[0]);
        int month = Integer.parseInt(split[1]);
        int day = Integer.parseInt(split[2]);

        String start = "%02d-%02d-%02d".formatted(year, month, 1);
        String end = userCurrentDay;
        var currentSum = expenseDaoJooq.getFromTo(user, start, end, includeRecurring)
                .stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        if (split[1].equalsIgnoreCase("01")) {
            year--;
            month = 12;
        } else {
            month--;
        }

        start = "%02d-%02d-%02d".formatted(year, month, 1);
        end = "%02d-%02d-%02d".formatted(year, month, day);


        var previousSum = expenseDaoJooq.getFromTo(user, start, end, includeRecurring)
                .stream()
                .mapToDouble(Expense::getAmount)
                .sum();
        if (previousSum == 0) {
            return 0;
        }

        return currentSum / previousSum;
    }

}
