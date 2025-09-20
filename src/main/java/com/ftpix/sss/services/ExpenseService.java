package com.ftpix.sss.services;

import com.ftpix.sss.Constants;
import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.*;
import com.ftpix.sss.utils.CategoryPredictor;
import com.ftpix.sss.utils.DateUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.OrderField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.EXPENSE;
import static com.ftpix.sss.dsl.Tables.FILES;

@Service
public class ExpenseService {
    public static final String DATE = "date";
    private static final String CATEGORY_ID = "CATEGORY_ID";
    public final CategoryService categoryService;
    public final SettingsService settingsService;
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final SimpleDateFormat monthOnly = new SimpleDateFormat("yyyy-MM");
    private final ZoneId zoneId;

    private final ExpenseDao expenseDaoJooq;
    private final FileService fileService;
    private final ExpenseDao expenseDao;
    private final AiFileProcessingService aiFileProcessingService;
    private final CategoryDao categoryDao;
    private final UserDao userDao;


    @Autowired
    public ExpenseService(CategoryService categoryService, SettingsService settingsService, ZoneId zoneId, ExpenseDao expenseDaoJooq, FileService fileService, ExpenseDao expenseDao, AiFileProcessingService aiFileProcessingService, CategoryDao categoryDao, UserDao userDao) throws SQLException {
        this.categoryService = categoryService;
        this.settingsService = settingsService;
        this.zoneId = zoneId;
        this.expenseDaoJooq = expenseDaoJooq;
        this.fileService = fileService;
        this.expenseDao = expenseDao;
        this.aiFileProcessingService = aiFileProcessingService;
        this.categoryDao = categoryDao;

        this.userDao = userDao;
        fixLegacyExpensesTimeZones();
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

    public void fixLegacyExpensesTimeZones() throws SQLException {

        var migrated = settingsService.getByName(Settings.TIMESTAMP_FIXED);
        if (migrated != null && migrated.getValue().equalsIgnoreCase("1")) {
            logger.info("timestamp migration already done");
            return;
        }

        var users = userDao.getWhere();

        logger.info("Migrating timestamps");

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        for (User user : users) {
            expenseDaoJooq.getWhere(user).forEach(expense -> {

                var localDate = LocalDateTime.parse(expense.getDate() + " " + Optional.ofNullable(expense.getTime())
                        .orElse("00:00"), dateFormatter);
                var zoned = localDate.atZone(zoneId);

                logger.info("Migrating expense:" + localDate + " zoned: " + zoned + " -> " + (zoned.toEpochSecond() * 1000));
                expense.setTimestamp(zoned.toEpochSecond() * 1000);
                expense.setTimeCreated(expense.getTimestamp());
                expenseDaoJooq.update(user, expense);
            });
        }


        settingsService.save(new Settings(Settings.TIMESTAMP_FIXED, "1"));

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

    public Map<String, DailyExpense> getByDay(String month, User user, ZoneId userZone) throws Exception {

        ZoneId zone = userZone == null ? zoneId : userZone;
        ZonedDateTime zoned = LocalDate.parse(month + "-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"))
                .atStartOfDay()
                .atZone(zone);
        ZonedDateTime from = zoned.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        ZonedDateTime to = zoned.with(TemporalAdjusters.lastDayOfMonth()).withHour(23).withMinute(59).withSecond(59);

        Map<String, List<Expense>> grouped = expenseDaoJooq.getFromHouseholdWhere(user, expenseDao.getDefaultOrderBy(), EXPENSE.TIMESTAMP.ge(from.toInstant()
                        .toEpochMilli()).and(EXPENSE.TIMESTAMP.le(to.toInstant().toEpochMilli())))
                .stream()
                .collect(Collectors.groupingBy(expense -> Constants.dateFormatter.format(DateUtils.fromTimestamp(expense.getTimestamp(), zone))));

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
                .forEach(file -> fileService.updateField(file, FILES.EXPENSE_ID, expense.getId()));

        return expense;
    }

    public Expense create(Expense expense, User user) throws Exception {
        Category category = categoryService.get(expense.getCategory().getId(), user);
        if (category == null) {
            throw new Exception("Category doesn't exist");
        } else {
            expense.setCategory(category);
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
                fileService.updateField(file, FILES.EXPENSE_ID, result.getId());
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
        PaginatedResults<Expense> data = expenseDaoJooq.getPaginatedWhere(user, 0, 1, new OrderField[]{EXPENSE.TIMESTAMP.asc()});
        if (data.getData().isEmpty()) {
            return new ExpenseLimits(0, 0);
        }
        Expense exp = data.getData().get(0);
        ZonedDateTime localDate = ZonedDateTime.ofInstant(Instant.ofEpochMilli(exp.getTimestamp()), zoneId);
        ZonedDateTime now = ZonedDateTime.now(zoneId);

        return new ExpenseLimits(ChronoUnit.YEARS.between(localDate, now), ChronoUnit.MONTHS.between(localDate, now));
    }

    public List<String> getMonths(User user, ZoneId zone) throws Exception {
        return expenseDaoJooq.getMonths(user, Optional.ofNullable(zone).orElse(zoneId));
    }

    public double getSumWhere(User user, Pair<ZonedDateTime, ZonedDateTime> date, Category category) {
        return expenseDaoJooq.sumWhere(user, EXPENSE.TIMESTAMP.ge(date.getLeft()
                .toInstant()
                .toEpochMilli()), EXPENSE.TIMESTAMP.le(date.getRight()
                .toInstant()
                .toEpochMilli()), EXPENSE.CATEGORY_ID.eq(category.getId()));
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
    public double diffWithPreviousPeriod(User user, String userCurrentDay, boolean includeRecurring, ZoneId zone) throws SQLException {

        var date = LocalDate.parse(userCurrentDay, Constants.dateFormatter)
                .atTime(23, 59, 59)
                .atZone(Optional.ofNullable(zone).orElse(zoneId));

        ZonedDateTime start = date.with(TemporalAdjusters.firstDayOfMonth())
                .withHour(0)
                .withMinute(0)
                .withSecond(0);

        ZonedDateTime end = date;

        var currentSum = expenseDaoJooq.getFromTo(user, true, start.toInstant().toEpochMilli(), end.toInstant()
                        .toEpochMilli(), includeRecurring)
                .stream()
                .mapToDouble(Expense::getAmount)
                .sum();

        start = start.minusMonths(1);
        end = end.minusMonths(1);


        var previousSum = expenseDaoJooq.getFromTo(user, true, start.toInstant().toEpochMilli(), end.toInstant()
                        .toEpochMilli(), includeRecurring)
                .stream()
                .mapToDouble(Expense::getAmount)
                .sum();
        if (previousSum == 0) {
            return 0;
        }

        return currentSum / previousSum;
    }

    public List<CategoryPredictor.CategoryPrediction> getExpenseCategorySuggestion(User currentUser, ZoneId timeZone, Double latitude, Double longitude) throws ExecutionException, InterruptedException {
        // we only select expenses that have been created on the spot and not back dated, backdated expenses will have a time of 00:00 of the user's timezone
        long oneMinute = 1000 * 60L;
        var expenses = expenseDaoJooq.getFromHouseholdWhere(currentUser, new OrderField[]{EXPENSE.ID.desc()}, EXPENSE.TIMESTAMP.gt(System.currentTimeMillis() - 1000L * 60 * 60 * 24 * 90), EXPENSE.TYPE.eq(1), EXPENSE.TIMESTAMP.minus(EXPENSE.TIMECREATED)
                .between(-oneMinute, oneMinute)); // get the last 6 months of expenses

        CategoryPredictor categoryPredictor = new CategoryPredictor();
        categoryPredictor.train(expenses, timeZone);

        var now = ZonedDateTime.now(timeZone);

        return categoryPredictor.predict(now.getDayOfWeek(), now.getHour());
    }
}
