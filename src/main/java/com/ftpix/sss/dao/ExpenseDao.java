package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.ExpenseRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import edu.emory.mathcs.backport.java.util.Collections;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.*;
import org.jooq.Record;
import org.jooq.impl.DefaultDSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import springfox.bean.validators.plugins.parameter.ExpandedParameterPatternAnnotationPlugin;

import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.EXPENSE;

@Component("expenseDaoJooq")
public class ExpenseDao {

    private final DefaultDSLContext dslContext;
    private final DateTimeFormatter date = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    private final DateTimeFormatter time = DateTimeFormatter.ofPattern("HH:mm");

    private List<DaoListener<Expense>> listeners = new ArrayList<>();

    @Autowired
    public ExpenseDao(DefaultDSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public Optional<Expense> get(User user, long id) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (userCategories.isEmpty()) {
            return Optional.empty();
        }

        return Optional.ofNullable(dslContext.select().from(EXPENSE)
                .where(EXPENSE.CATEGORY_ID.in(userCategories.keySet()), EXPENSE.ID.eq(id))
                .fetchOne(record -> {
                    try {
                        Expense into = fromRecord(record);
                        into.setCategory(userCategories.get(record.get(EXPENSE.CATEGORY_ID)));
                        return into;
                    } catch (ParseException e) {
                        throw new RuntimeException(e);
                    }
                }));
    }

    public void addListener(DaoListener<Expense> listener) {
        listeners.add(listener);
    }

    public Expense create(User user, Expense expense) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (!userCategories.containsKey(expense.getCategory().getId())) {
            throw new InvalidParameterException("User can't add expense to this category");
        }

        Long id = dslContext.insertInto(EXPENSE,
                        EXPENSE.AMOUNT,
                        EXPENSE.CATEGORY_ID,
                        EXPENSE.DATE,
                        EXPENSE.TYPE,
                        EXPENSE.LATITUDE,
                        EXPENSE.LONGITUDE,
                        EXPENSE.NOTE,
                        EXPENSE.TIME,
                        EXPENSE.TIMESTAMP,
                        EXPENSE.INCOME
                ).values(
                        expense.getAmount(),
                        expense.getCategory().getId(),
                        dateFormat.format(expense.getDate()),
                        expense.getType(),
                        expense.getLatitude(),
                        expense.getLongitude(),
                        expense.getNote(),
                        timeFormat.format(expense.getDate()),
                        System.currentTimeMillis(),
                        (byte) (expense.isIncome() ? 1 : 0)
                ).returningResult(EXPENSE.ID)
                .fetchOne(r -> r.into(Long.class));

        expense.setId(id);

        listeners.forEach(l -> l.afterInsert(user, expense));

        return expense;
    }

    public boolean delete(User user, Expense expense) {
        Map<Long, Category> userCategories = getUserCategories(user);

        if (!userCategories.containsKey(expense.getCategory().getId())) {
            throw new InvalidParameterException("User can't delete expense tfrom this category");
        }

        int affected = dslContext.delete(EXPENSE)
                .where(EXPENSE.CATEGORY_ID.in(userCategories.keySet()), EXPENSE.ID.eq(expense.getId()))
                .execute();

        listeners.forEach(l -> l.afterDelete(user, expense));

        return affected > 0;
    }

    /**
     * Gets available months of expenses
     *
     * @param user
     * @return
     */
    public List<String> getMonths(User user) {
        Map<Long, Category> userCategories = getUserCategories(user);

        return dslContext.selectDistinct(EXPENSE.DATE)
                .from(EXPENSE)
                .where(EXPENSE.CATEGORY_ID.in(userCategories.keySet()))
                .fetch(r -> r.get(EXPENSE.DATE))
                .stream()
                .map(s -> s.substring(0, 7))
                .sorted()
                .distinct()
                .collect(Collectors.toList());
    }

    /**
     * Base filter to get any expense
     *
     * @param user
     * @return
     */
    private Map<Long, Category> getUserCategories(User user) {
        return dslContext.select().from(CATEGORY)
                .where(CATEGORY.USER_ID.eq(user.getId().toString()))
                .fetch(record -> {
                    Category into = record.into(Category.class);
                    into.setUser(user);
                    return into;
                })
                .stream().collect(Collectors.toMap(Category::getId, Function.identity()));
    }

    public List<Expense> getWhere(User user, Condition... filter) throws SQLException {
        return getWhere(user, null, null, filter);
    }

    public List<Expense> getWhere(User user, Integer limit, Integer offset, Condition... filter) throws SQLException {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, EXPENSE.CATEGORY_ID.in(userCategories.keySet()));

        if (userCategories.size() > 0) {
            Select<Record> select = dslContext.select()
                    .from(EXPENSE)
                    .where(conditions)
                    .limit(limit != null ? limit : Integer.MAX_VALUE)
                    .offset(offset != null ? offset : 0);

            List<Expense> expenses = select
                    .fetch(record -> {
                        try {
                            Expense into = fromRecord(record);

                            into.setCategory(userCategories.get(record.getValue(EXPENSE.CATEGORY_ID)));
                            return into;
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                    });

            return expenses;
        } else {
            return Collections.emptyList();
        }
    }

    private Expense fromRecord(Record record) throws ParseException {
        Expense exp = record.into(Expense.class);
        String text = record.get(EXPENSE.DATE);
        exp.setDate(dateFormat.parse(text));

        return exp;
    }

    public void deleteWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, EXPENSE.CATEGORY_ID.in(userCategories.keySet()));

        if (userCategories.isEmpty()) {
            return;
        }

        dslContext.delete(EXPENSE)
                .where(conditions)
                .execute();
    }


    public long countExpenses(User user, long categoryId) {
        Map<Long, Category> userCategories = getUserCategories(user);
        return dslContext.fetchCount(EXPENSE, EXPENSE.CATEGORY_ID.in(userCategories.keySet()), EXPENSE.CATEGORY_ID.eq(categoryId));
    }
}
