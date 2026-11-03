package com.ftpix.sss.services;

import com.ftpix.sss.Constants;
import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.persistence.utils.Specifications;
import com.ftpix.sss.utils.CategoryPredictor;
import com.ftpix.sss.utils.DateUtils;
import com.ftpix.sss.websockets.AfterCommitMessages;
import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.regex.MatchResult;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.ftpix.sss.persistence.utils.ExpenseSpecifications.*;

@Service
public class ExpenseService {
    public static final String DATE = "date";
    private static final String CATEGORY_ID = "CATEGORY_ID";
    private static final int MAX_NOTE_SUGGESTIONS = 20;
    // a tag in a note, e.g. #visa, letters can carry combining marks (accents, vowel signs)
    private static final Pattern TAG = Pattern.compile("#[\\p{L}\\p{M}\\p{N}_-]+");
    // a tag being typed at the end of a note, possibly only the #
    private static final Pattern TYPED_TAG = Pattern.compile("(?:^|\\s)(#[\\p{L}\\p{M}\\p{N}_-]*)$");
    public final CategoryService categoryService;
    public final SettingsService settingsService;
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final SimpleDateFormat monthOnly = new SimpleDateFormat("yyyy-MM");
    private final ZoneId zoneId;

    //    private final ExpenseDao expenseDaoJooq;
    private final FileService fileService;
    //    private final ExpenseDao expenseDao;
    private final AiFileProcessingService aiFileProcessingService;
    private final HouseholdService householdService;
    private final ExpenseRepository expenseRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final EntityManager entityManager;
    private final HouseholdLocks householdLocks;


    @Autowired
    public ExpenseService(CategoryService categoryService, SettingsService settingsService, ZoneId zoneId, FileService fileService, AiFileProcessingService aiFileProcessingService, HouseholdService householdService, ExpenseRepository expenseRepository, UserRepository userRepository, CategoryRepository categoryRepository, EntityManager entityManager, HouseholdLocks householdLocks) throws SQLException {
        this.categoryService = categoryService;
        this.settingsService = settingsService;
        this.zoneId = zoneId;
//        this.expenseDaoJooq = expenseDaoJooq;
        this.fileService = fileService;
//        this.expenseDao = expenseDao;
        this.aiFileProcessingService = aiFileProcessingService;
        this.householdService = householdService;
        this.expenseRepository = expenseRepository;
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
        this.entityManager = entityManager;
        this.householdLocks = householdLocks;
    }


    @Transactional(readOnly = true)
    public List<Expense> getAll(User user) {
        return expenseRepository.findExpenseByUser(user);
    }

    @Transactional(readOnly = true)
    public Expense get(long id, User user) {
        return expenseRepository.findExpenseByIdAndUser(id, user);
    }


    @Transactional
    @EventListener(ApplicationReadyEvent.class)
    public void fixLegacyExpensesTimeZones() throws SQLException {
        householdLocks.shared();

        var migrated = settingsService.getByName(Settings.TIMESTAMP_FIXED);
        if (migrated != null && migrated.getValue().equalsIgnoreCase("1")) {
            logger.info("timestamp migration already done");
            return;
        }

        var users = userRepository.findAll();

        logger.info("Migrating timestamps");

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        for (User user : users) {
            getAll(user).forEach(expense -> {

                var localDate = LocalDateTime.parse(expense.getDate() + " " + Optional.ofNullable(expense.getTime())
                        .orElse("00:00"), dateFormatter);
                var zoned = localDate.atZone(zoneId);

                logger.info("Migrating expense:" + localDate + " zoned: " + zoned + " -> " + (zoned.toEpochSecond() * 1000));
                expense.setTimestamp(zoned.toEpochSecond() * 1000);
                expense.setTimeCreated(expense.getTimestamp());
                expenseRepository.save(expense);
            });
        }


        settingsService.save(new Settings(Settings.TIMESTAMP_FIXED, "1"));

    }

    /**
     * The most used notes of the category, whatever the amount.
     */
    @Transactional(readOnly = true)
    public Map<String, Long> suggestNotes(User currentUser, Expense expense) {
        return countIgnoringCase(expenseRepository.findNotes(currentUser, expense.getCategory()).stream(), MAX_NOTE_SUGGESTIONS);
    }

    /**
     * Notes containing the text. If the text ends with a tag being typed (e.g. "Groceries #vi"), the known tags it
     * could be are suggested as well, as the full note ("Groceries #visa") because picking a suggestion replaces the
     * note.
     */
    @Transactional(readOnly = true)
    public Map<String, Long> autoCompleteNote(User currentUser, String seed) {
        Map<String, Long> suggestions = countIgnoringCase(expenseRepository.autoCompleteNote(currentUser, "%" + seed + "%").stream(), Integer.MAX_VALUE);

        Matcher typedTag = TYPED_TAG.matcher(seed);
        if (typedTag.find()) {
            String beforeTag = seed.substring(0, typedTag.start(1));
            String start = typedTag.group(1);

            // compared character by character: lower casing the whole text can change its length (İ) or depend on
            // the position (Σ), so it wouldn't match what the database finds
            Stream<String> tags = expenseRepository.autoCompleteNote(currentUser, "%" + start + "%")
                    .stream()
                    .filter(Objects::nonNull)
                    .flatMap(note -> TAG.matcher(note).results().map(MatchResult::group))
                    .filter(tag -> tag.regionMatches(true, 0, start, 0, start.length()));

            // a completed tag can be a note already suggested, possibly spelled differently: it's suggested once, under
            // the most used spelling, the existing note when both are used as often. Counts aren't added as they overlap.
            Map<String, String> spellings = suggestions.keySet()
                    .stream()
                    .collect(Collectors.toMap(s -> s.toLowerCase(Locale.ROOT), s -> s));
            countIgnoringCase(tags, Integer.MAX_VALUE).forEach((tag, count) -> {
                String completed = beforeTag + tag;
                String suggested = spellings.get(completed.toLowerCase(Locale.ROOT));
                if (suggested == null) {
                    suggestions.put(completed, count);
                } else if (count > suggestions.get(suggested)) {
                    suggestions.remove(suggested);
                    suggestions.put(completed, count);
                }
            });
        }

        return suggestions;
    }

    /**
     * Counts the texts, merging the ones only differing by their case under their most used spelling, so a single
     * spelling ends up being suggested.
     *
     * @return the most used texts and how often they're used
     */
    private Map<String, Long> countIgnoringCase(Stream<String> texts, int limit) {
        Map<String, Map<String, Long>> spellings = texts.filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isBlank())
                .collect(Collectors.groupingBy(s -> s.toLowerCase(Locale.ROOT), Collectors.groupingBy(s -> s, Collectors.counting())));

        return spellings.values()
                .stream()
                .map(counts -> Map.entry(
                        // the first one in alphabetical order when several are used as often
                        Collections.max(counts.entrySet(), Map.Entry.<String, Long>comparingByValue()
                                .thenComparing(Map.Entry.comparingByKey(Comparator.reverseOrder()))).getKey(),
                        counts.values().stream().mapToLong(Long::longValue).sum()))
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .limit(limit)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, Long::sum, HashMap::new));
    }

    @Transactional(readOnly = true)
    public Map<String, DailyExpense> getByDay(String month, User user, ZoneId userZone) throws Exception {

        ZoneId zone = userZone == null ? zoneId : userZone;
        ZonedDateTime zoned = LocalDate.parse(month + "-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"))
                .atStartOfDay()
                .atZone(zone);
        ZonedDateTime from = zoned.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        ZonedDateTime to = zoned.with(TemporalAdjusters.lastDayOfMonth()).withHour(23).withMinute(59).withSecond(59);

        Map<String, List<Expense>> grouped = expenseRepository.findFromHouseHoldForDates(user, from.toInstant()
                        .toEpochMilli(), to.toInstant().toEpochMilli())
                .stream()
                .collect(Collectors.groupingBy(expense -> Constants.dateFormatter.format(DateUtils.fromTimestamp(expense.getTimestamp(), zone))));


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

    @Transactional
    public Expense update(Expense expense, User user) throws SQLException {
        // the category might belong to a member leaving the household right now
        householdLocks.shared();
        Expense existing = expenseRepository.findExpenseByIdAndUser(expense.getId(), user);
        Category category = categoryService.resolve(expense.getCategory(), user);
        if (existing != null && category != null) {
            // the creator never changes and the category must be one of the household's
            expense.setUser(existing.getUser());
            expense.setCategory(category);

            List<SSSFile> managedFiles = expense.getFiles().stream().map(f -> {
                SSSFile managed = entityManager.merge(f);
                managed.setExpense(expense);
                return managed;
            }).collect(Collectors.toList());
            expense.setFiles(managedFiles);

            expenseRepository.save(expense);


/*
            fileService.clearExpenseFiles(expense.getId());

            expense.getFiles()
                    .forEach(file -> fileService.updateField(file, FILES.EXPENSE_ID, expense.getId()));
*/

            sendMessageToOtherUsers(user);
            return expense;
        } else {
            return null;
        }
    }

    @Transactional
    public Expense create(Expense expense, User user) throws Exception {
        // the category might belong to a member leaving the household right now
        householdLocks.shared();
        Category category = categoryService.resolve(expense.getCategory(), user);
        if (category == null) {
            throw new Exception("Category doesn't exist");
        } else {
            expense.setCategory(category);
        }
        expense.setUser(user);

        if (expense.getType() == 0) {
            expense.setType(Expense.TYPE_NORMAL);
        }

        if (expense.getFiles() != null) {
            List<SSSFile> managedFiles = expense.getFiles().stream().map(f -> {
                SSSFile managed = entityManager.merge(f);
                managed.setExpense(expense);
                return managed;
            }).collect(Collectors.toList());
            expense.setFiles(managedFiles);
        }
        Expense result = expenseRepository.save(expense);

        // we process the files
        // we don't update the files with what we got as it might still be processing, we just take the DB version and assign
        // the expense id
/*
        for (SSSFile sssFile : expense.getFiles()) {
            fileService.getfile(user, sssFile.getId().toString()).ifPresent(file -> {
                fileService.updateField(file, FILES.EXPENSE_ID, result.getId());
            });
        }
*/

        sendMessageToOtherUsers(user);
        return result;
    }

    @Transactional
    public boolean delete(long id, User user) throws Exception {
        // a member leaving the household right now might be moving this expense
        householdLocks.shared();
        final Expense expense = get(id, user);
        // get() only returns expenses created by the user
        if (expense != null) {
            try {
                expenseRepository.delete(expense);
                return true;
            } finally {
                sendMessageToOtherUsers(user);
            }
        } else {
            return false;
        }
    }

    /**
     * @return
     */
    @Transactional(readOnly = true)
    public ExpenseLimits getLimits(User user) {
        Pageable pageable = PageRequest.of(0, 1, Sort.by("timestamp").ascending());

        Slice<Expense> data = expenseRepository.getSlice(user, pageable);

        if (data.getContent().isEmpty()) {
            return new ExpenseLimits(0, 0);
        }
        Expense exp = data.getContent().get(0);
        ZonedDateTime localDate = ZonedDateTime.ofInstant(Instant.ofEpochMilli(exp.getTimestamp()), zoneId);
        ZonedDateTime now = ZonedDateTime.now(zoneId);

        return new ExpenseLimits(ChronoUnit.YEARS.between(localDate, now), ChronoUnit.MONTHS.between(localDate, now));
    }

    @Transactional(readOnly = true)
    public List<String> getMonths(User user, ZoneId zone) throws Exception {

        return expenseRepository.getHouseholdExpenseTimes(user)
                .stream()
                .map(s -> ZonedDateTime.ofInstant(Instant.ofEpochMilli(s), zoneId))
                .map(d -> DateTimeFormatter.ofPattern("yyyy-MM").format(d))
                .sorted()
                .distinct()
                .toList();
    }


    @Transactional(readOnly = true)
    public List<Expense> getFromTo(User user, boolean includeHousehold, long from, long to, boolean includeRecurring) {

        Specification<Expense> spec = Specification.where(betweenTimestamps(from, to))
                .and(includeHousehold ? Specifications.<Expense>onlyIn("category", categoryRepository.getHouseholdCategories(user)) : Specifications.<Expense>createdBy(user));

        if (!includeRecurring) {
            spec = spec.and(excludeRecurring());
        }

        return expenseRepository.findAll(spec);
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
    @Transactional(readOnly = true)
    public double diffWithPreviousPeriod(User user, String userCurrentDay, boolean includeRecurring, ZoneId zone) throws SQLException {

        var date = LocalDate.parse(userCurrentDay, Constants.dateFormatter)
                .atTime(23, 59, 59)
                .atZone(Optional.ofNullable(zone).orElse(zoneId));

        ZonedDateTime start = date.with(TemporalAdjusters.firstDayOfMonth()).withHour(0).withMinute(0).withSecond(0);

        ZonedDateTime end = date;

        var currentSum = getFromTo(user, true, start.toInstant().toEpochMilli(), end.toInstant()
                .toEpochMilli(), includeRecurring).stream().mapToDouble(Expense::getAmount).sum();

        start = start.minusMonths(1);
        end = end.minusMonths(1);


        var previousSum = getFromTo(user, true, start.toInstant().toEpochMilli(), end.toInstant()
                .toEpochMilli(), includeRecurring).stream().mapToDouble(Expense::getAmount).sum();
        if (previousSum == 0) {
            return 0;
        }

        return currentSum / previousSum;
    }

    @Transactional(readOnly = true)
    public List<CategoryPredictor.CategoryPrediction> getExpenseCategorySuggestion(User currentUser, ZoneId timeZone, Double latitude, Double longitude) throws ExecutionException, InterruptedException {
        // we only select expenses that have been created on the spot and not back dated, backdated expenses will have a time of 00:00 of the user's timezone

        // the user's own habits only, the categories might still belong to other household members
        Specification<Expense> spec = Specification.where(createdOnTheSpot())
                .and(Specifications.<Expense>createdBy(currentUser))
                .and(Specifications.greaterThan("timestamp", System.currentTimeMillis() - 1000L * 60 * 60 * 24 * 90));

        var expenses = expenseRepository.findAll(spec, Sort.by("id").ascending());


/*
        var expenses = expenseDaoJooq.getFromHouseholdWhere(currentUser, new OrderField[]{EXPENSE.ID.desc()}, EXPENSE.TIMESTAMP.gt(System.currentTimeMillis() - 1000L * 60 * 60 * 24 * 90), EXPENSE.TYPE.eq(1), EXPENSE.TIMESTAMP.minus(EXPENSE.TIMECREATED)
                .between(-oneMinute, oneMinute)); // get the last 6 months of expenses
*/

        CategoryPredictor categoryPredictor = new CategoryPredictor();
        categoryPredictor.train(expenses, timeZone);

        var now = ZonedDateTime.now(timeZone);

        return categoryPredictor.predict(now.getDayOfWeek(), now.getHour());
    }


    private List<User> getHouseholdOtherMembers(User user) {
        return householdService.getCurrentHousehold(user)
                .map(household -> household.getMembers()
                        .stream()
                        .map(HouseholdMember::getUser)
                        .filter(user1 -> !user1.getId().equals(user.getId()))
                        .toList())
                .orElseGet(List::of);
    }

    /**
     * Sent after the commit, so the other members' clients reload the new expenses and history.
     */
    public void sendMessageToOtherUsers(User currentUser) {
        List<String> recipients = getHouseholdOtherMembers(currentUser).stream()
                .map(user -> user.getId().toString())
                .toList();
        AfterCommitMessages.sendToUsers(recipients, new NewHouseholdExpense());
    }
}
