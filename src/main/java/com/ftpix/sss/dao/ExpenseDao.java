package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.dsl.tables.records.ExpenseRecord;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.impl.DSL;
import org.jooq.impl.DefaultDSLContext;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.Constants.dateFormatter;
import static com.ftpix.sss.dsl.Tables.EXPENSE;
import static com.ftpix.sss.dsl.Tables.FILES;
import static org.jooq.impl.DSL.lower;

@Component("expenseDaoJooq")
public class ExpenseDao implements UserCategoryBasedDao<ExpenseRecord, Expense>, HouseholdCategoryBaseDao<ExpenseRecord, Expense> {

    private final DefaultDSLContext dslContext;

    private final List<DaoUserListener<Expense>> listeners = new ArrayList<>();

    private final HouseholdDao householdDao;

    @Autowired
    public ExpenseDao(DefaultDSLContext dslContext, HouseholdDao householdDao) {
        this.dslContext = dslContext;
        this.householdDao = householdDao;
    }

    public Optional<Expense> get(User user, long id) {
        return getOneWhere(user, EXPENSE.ID.eq(id));
    }

    @Override
    public void addUserBasedListener(DaoUserListener<Expense> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoUserListener<Expense>> getUserBasedListeners() {
        return listeners;
    }

    public List<Expense> queryForAll(List<Category> categories) {
        var categoriesById = categories.stream().collect(Collectors.toMap(Category::getId, Function.identity()));
        return dslContext.select().from(EXPENSE).fetch(r -> fromRecord((ExpenseRecord) r, categoriesById));
    }

    @Override
    public Expense insert(User user, Expense object) {
        object.setTimeCreated(System.currentTimeMillis());
        return UserCategoryBasedDao.super.insert(user, object);
    }

    /**
     * Gets available months of expenses
     *
     * @param user
     * @return
     */
    public List<String> getMonths(User user, ZoneId zoneId) {
        Map<Long, Category> userCategories = getHouseholdCategories(user);

        return dslContext.select(EXPENSE.TIMESTAMP)
                .from(EXPENSE)
                .where(EXPENSE.CATEGORY_ID.in(userCategories.keySet()))
                .fetch(r -> r.get(EXPENSE.TIMESTAMP))
                .stream()
                .map(s -> ZonedDateTime.ofInstant(Instant.ofEpochMilli(s), zoneId))
                .map(d -> DateTimeFormatter.ofPattern("yyyy-MM").format(d))
                .sorted()
                .distinct()
                .collect(Collectors.toList());
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public TableImpl<ExpenseRecord> getTable() {
        return EXPENSE;
    }

    @Override
    public Expense fromRecord(ExpenseRecord r, Map<Long, Category> categories) {
        Expense e = new Expense();
        e.setId(r.getId());
        e.setCategory(categories.get(r.getCategoryId()));
        e.setType(r.getType());
        e.setAmount(r.getAmount());
        e.setIncome(r.getIncome() != null && r.getIncome().equals(1));
        if (r.getDate() != null) {
            var date = r.getDate();
            e.setDate(LocalDate.parse(date, dateFormatter));
        }
        e.setLatitude(r.getLatitude());
        e.setLongitude(r.getLongitude());
        e.setTime(r.getTime());
        e.setTimestamp(r.getTimestamp());
        e.setNote(r.getNote());
        e.setTimeCreated(r.getTimecreated());
        return e;
    }

    /**
     * Like getWhere but will join the image table to search the tags
     *
     * @param user
     * @param orderBy
     * @param filter
     * @return
     */
    public List<Expense> search(User user, OrderField[] orderBy, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);

        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));
        return getDsl().selectDistinct(EXPENSE.fields())
                .from(getTable())
                .leftJoin(Tables.FILES)
                .on(FILES.EXPENSE_ID.eq(EXPENSE.ID))
                .where(conditions)
                .orderBy(orderBy)
                .fetch(r -> {
                    return fromRecord(r.into(EXPENSE), userCategories);
                });
    }

    @Override
    public ExpenseRecord setRecordData(ExpenseRecord r, Expense o) {
        if (o.getId() != null) {
            r.setId(o.getId());
        }
        r.setCategoryId(o.getCategory().getId());
        r.setType(o.getType());
        r.setAmount(o.getAmount());
        r.setIncome(o.isIncome() ? 1 : 0);
        if (o.getDate() != null) {
            r.setDate(dateFormatter.format(o.getDate()));
        }
        r.setLatitude(o.getLatitude());
        r.setLongitude(o.getLongitude());
        if (o.getTime() != null) {
            r.setTime(o.getTime());
        }
        r.setTimestamp(o.getTimestamp());
        r.setNote(o.getNote());
        r.setTimecreated(o.getTimeCreated());
        return r;
    }

    @Override
    public Field<Long> getCategoryField() {
        return EXPENSE.CATEGORY_ID;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{EXPENSE.DATE.desc()};
    }

    public long countExpenses(User user, long categoryId) {
        Map<Long, Category> userCategories = getUserCategories(user);
        return dslContext.fetchCount(EXPENSE, EXPENSE.CATEGORY_ID.in(userCategories.keySet()), EXPENSE.CATEGORY_ID.eq(categoryId));
    }

    public double sumWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);

        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, getCategoryField().in(userCategories.keySet()));
        return Optional.ofNullable(getDsl().select(DSL.sum(EXPENSE.AMOUNT))
                        .from(getTable())
                        .where(conditions)
                        .fetchOneInto(BigDecimal.class))
                .map(BigDecimal::doubleValue)
                .orElse(0d);
    }

    public List<String> getNotes(User currentUser, long categoryId, double minExpense, double maxExpense) {
        Map<Long, Category> userCategories = getUserCategories(currentUser);
        return dslContext.select(EXPENSE.NOTE)
                .from(EXPENSE)
                .where(EXPENSE.CATEGORY_ID.in(userCategories.keySet()))
                .and(EXPENSE.CATEGORY_ID.eq(categoryId))
                .and(EXPENSE.AMOUNT.ge(minExpense))
                .and(EXPENSE.AMOUNT.le(maxExpense))
                .fetch(EXPENSE.NOTE);
    }

    public List<String> autoCompleteNote(User currentUser, String seed) {
        Map<Long, Category> userCategories = getUserCategories(currentUser);

        return dslContext.select(EXPENSE.NOTE)
                .from(EXPENSE)
                .where(lower(EXPENSE.NOTE).like("%" + seed.toLowerCase() + "%"))
                .and(EXPENSE.CATEGORY_ID.in(userCategories.keySet()))
                .fetch(EXPENSE.NOTE);
    }

    public List<Expense> getFromTo(User user, boolean includeHousehold, long from, long to, boolean includeRecurring) {

        Map<Long, Category> userCategories = includeHousehold ? getHouseholdCategories(user) : getUserCategories(user);

        var query = dslContext.select().from(EXPENSE).where(EXPENSE.TIMESTAMP.between(from, to));

        if (!includeRecurring) {
            query = query.and(EXPENSE.TYPE.ne(Expense.TYPE_RECURRENT));
        }

        return query.fetch(r -> fromRecord((ExpenseRecord) r, userCategories));

    }
}
