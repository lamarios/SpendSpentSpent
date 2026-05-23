package com.ftpix.sss.services;

import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.MonthlyHistoryRepository;
import com.ftpix.sss.persistence.YearlyHistoryRepository;
import com.ftpix.sss.persistence.utils.Specifications;
import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class HistoryService {
    private final static Logger logger = LogManager.getLogger();

    /*
        private final ExpenseDao expenseDaoJooq;
        private final CategoryDao categoryDaoJooq;
        private final MonthlyHistoryDao monthlyHistoryDaoJooq;
        private final YearlyHistoryDao yearlyHistoryDaoJooq;
    */
    private final ExpenseRepository expenseRepository;
    private final CategoryRepository categoryRepository;
    private final YearlyHistoryRepository yearlyHistoryRepository;
    private final MonthlyHistoryRepository monthlyHistoryRepository;
    private final ZoneId zoneId;
    @PersistenceContext
    private final EntityManager entityManager;

    @Autowired
    public HistoryService(ExpenseRepository expenseRepository, CategoryRepository categoryRepository, YearlyHistoryRepository yearlyHistoryRepository, MonthlyHistoryRepository monthlyHistoryRepository, ZoneId zoneId, EntityManager entityManager) {
        this.expenseRepository = expenseRepository;
        this.categoryRepository = categoryRepository;
        this.yearlyHistoryRepository = yearlyHistoryRepository;
        this.monthlyHistoryRepository = monthlyHistoryRepository;
        this.zoneId = zoneId;

//        this.expenseDaoJooq.addUserBasedListener(expenseDaoListener);
//        this.categoryDaoJooq.addUserBasedListener(categoryDaoListener);
        this.entityManager = entityManager;
    }


    @EventListener(ApplicationReadyEvent.class)
    @Transactional
    public void recreateViews() {
        // very dirty way to recreate the views on startup but the timezone can change so we don't really have a choice
        List.of("DROP MATERIALIZED VIEW IF EXISTS monthly_history;", """
                CREATE MATERIALIZED VIEW monthly_history AS
                SELECT category_id,
                       to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYYMM')::INTEGER AS date,
                       ROUND(SUM(amount)::NUMERIC, 2)                                                     AS total,
                       COUNT(*)                                                                           AS expenses
                FROM expense
                GROUP BY category_id, to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYYMM')::INTEGER;
                """.formatted(zoneId.toString(), zoneId.toString()), "DROP MATERIALIZED VIEW IF EXISTS yearly_history;", """
                CREATE MATERIALIZED VIEW yearly_history AS
                SELECT category_id,
                       to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYY')::INTEGER AS date,
                       ROUND(SUM(amount)::NUMERIC, 2)                  AS total,
                       COUNT(*)                                        AS expenses
                FROM expense
                GROUP BY category_id, to_char(to_timestamp(timestamp / 1000) AT TIME ZONE '%s', 'YYYY')::INTEGER;
                """.formatted(zoneId.toString(), zoneId.toString()), "CREATE UNIQUE INDEX yearly_index on yearly_history (category_id, date);", "CREATE UNIQUE INDEX monthly_index on monthly_history (category_id, date);"

        ).forEach(sql -> entityManager.createNativeQuery(sql).executeUpdate());
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void refreshMaterializedViews() {
        var now = System.currentTimeMillis();
        List.of("REFRESH MATERIALIZED VIEW CONCURRENTLY yearly_history;", "REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_history;")
                .forEach(sql -> entityManager.createNativeQuery(sql).executeUpdate());
        logger.info("Refreshing materialized views in {}ms", System.currentTimeMillis() - now);
    }


    /**
     * Gets expense sum for each categories for the current year
     *
     * @param user which user to query for
     * @return the list of category yearly summary
     * @throws Exception if anything goes wrong
     */
    @Transactional(readOnly = true)
    public List<CategoryOverall> yearly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = categoryRepository.getHouseholdCategories(user);

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1L);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);

        ZonedDateTime now = ZonedDateTime.now(zoneId);
        int year = now.getYear();

        var yearly = yearlyHistoryRepository.findAllByUserAndYear(user, year);
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
                .peek(c -> c.setTotal(overall.getTotal()))
                .sorted(Comparator.comparing(CategoryOverall::getAmount)
                        .reversed()
                        .thenComparingLong(o -> o.getCategory().getId()))
                .collect(Collectors.toList());
    }


    /**
     * Gets expense sum for each categories for the current month
     *
     * @param user which user to query for
     * @return the list of category monthly summary
     * @throws Exception if anything goes wrong
     */
    @Transactional(readOnly = true)
    public List<CategoryOverall> monthly(User user) throws Exception {
        List<CategoryOverall> result = new ArrayList<>();

        List<Category> categories = categoryRepository.getHouseholdCategories(user);

        CategoryOverall overall = new CategoryOverall();
        Category categoryAll = new Category();
        categoryAll.setId(-1L);
        categoryAll.setIcon("all");
        categoryAll.setUser(user);
        overall.setCategory(categoryAll);

        LocalDate now = LocalDate.now();
        int date = (now.getYear() * 100) + now.getMonthValue();

//        List<MonthlyHistory> monthly = monthlyHistoryDaoJooq.getFromHouseholdWhere(user, MONTHLY_HISTORY.DATE.eq(date));
        var monthly = monthlyHistoryRepository.findAllByUserAndMonth(user, date);
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
                .peek(c -> c.setTotal(overall.getTotal()))
                .sorted(Comparator.comparing(CategoryOverall::getAmount)
                        .reversed()
                        .thenComparingLong(o -> o.getCategory().getId()))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getYearlyHistory(long categoryId, int count, User user) {
        List<Map<String, Object>> result = new ArrayList<>();

        LocalDate date = LocalDate.now();
        List<Integer> data = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            data.add(date.getYear());
            date = date.minusYears(1);
        }

        List<Category> householdCategories = categoryRepository.getHouseholdCategories(user);

        Specification<YearlyHistory> spec = Specification.where(Specifications.<YearlyHistory>in("id.category", householdCategories))
                .and(Specifications.in("id.date", data));
//        List<Condition> conditions = new ArrayList<>();
//        conditions.add(YEARLY_HISTORY.DATE.in(data));
        if (categoryId >= 0) {
            spec = spec.and(Specifications.equal("id.category.id", categoryId));
//            conditions.add(YEARLY_HISTORY.CATEGORY_ID.eq(categoryId));
        }

        ;
//        Map<Integer, List<YearlyHistory>> history = yearlyHistoryDaoJooq.getFromHouseholdWhere(user, conditions.toArray(new Condition[0]))
        Map<Integer, List<YearlyHistory>> history = yearlyHistoryRepository.findAll(spec)
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

    @Transactional(readOnly = true)
    public List<Map<String, Object>> getMonthlyHistory(long categoryId, int count, User user) {
        List<Map<String, Object>> result = new ArrayList<>();

        ZonedDateTime date = ZonedDateTime.now(zoneId);
        List<Integer> data = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            data.add((date.getYear() * 100) + date.getMonthValue());
            date = date.minusMonths(1);
        }

        List<Category> householdCategories = categoryRepository.getHouseholdCategories(user);

        Specification<MonthlyHistory> spec = Specification.where(Specifications.<MonthlyHistory>in("id.category", householdCategories))
                .and(Specifications.in("id.date", data));
//        List<Condition> conditions = new ArrayList<>();
//        conditions.add(MONTHLY_HISTORY.DATE.in(data));
        if (categoryId >= 0) {
            spec = spec.and(Specifications.equal("id.category.id", categoryId));
//            conditions.add(MONTHLY_HISTORY.CATEGORY_ID.eq(categoryId));
        }

//        Map<Integer, List<MonthlyHistory>> history = monthlyHistoryDaoJooq.getFromHouseholdWhere(user, conditions.toArray(new Condition[0]))
        Map<Integer, List<MonthlyHistory>> history = monthlyHistoryRepository.findAll(spec)
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

    @Transactional(readOnly = true)
    public double getMonthTotal(User user, int month) {
        var expenses = monthlyHistoryRepository.findAllByUserAndMonth(user, month);
//        var expenses = monthlyHistoryDaoJooq.getFromHouseholdWhere(user, MONTHLY_HISTORY.DATE.eq(month));
        return expenses.stream().mapToDouble(MonthlyHistory::getTotal).sum();
    }
}
