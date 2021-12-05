package com.ftpix.sss.dao;

import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.google.common.base.Functions;
import edu.emory.mathcs.backport.java.util.Collections;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.Condition;
import org.jooq.Record;
import org.jooq.Record1;
import org.jooq.impl.DefaultDSLContext;
import org.springframework.beans.InvalidPropertyException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.EXPENSE;

@Component("expenseDaoJooq")
public class ExpenseDao {

    private final DefaultDSLContext dslContext;
    private final DateTimeFormatter date = DateTimeFormatter.ofPattern("yyyy-MM-dd");
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
                    Expense into = record.into(Expense.class);
                    into.setCategory(userCategories.get(record.get(EXPENSE.CATEGORY_ID)));
                    return into;
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

        LocalDateTime now = LocalDateTime.now();
        Long id = dslContext.insertInto(EXPENSE,
                        EXPENSE.AMOUNT,
                        EXPENSE.CATEGORY_ID,
                        EXPENSE.DATE,
                        EXPENSE.TYPE,
                        EXPENSE.LATITUDE,
                        EXPENSE.LONGITUDE,
                        EXPENSE.NOTE,
                        EXPENSE.TIME,
                        EXPENSE.TIMESTAMP
                ).values(
                        expense.getAmount(),
                        expense.getCategory().getId(),
                        now.format(date),
                        expense.getType(),
                        expense.getLatitude(),
                        expense.getLongitude(),
                        expense.getNote(),
                        now.format(time),
                        System.currentTimeMillis()
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
     * Base filter to get any expense
     *
     * @param user
     * @return
     */
    private Map<Long, Category> getUserCategories(User user) {
        return dslContext.select().from(CATEGORY)
                .where(CATEGORY.USER_ID.eq(user.getId().toString()))
                .fetch(record -> record.into(Category.class))
                .stream().collect(Collectors.toMap(Category::getId, Function.identity()));
    }

    public List<Expense> getWhere(User user, Condition... filter) throws SQLException {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, EXPENSE.CATEGORY_ID.in(userCategories.keySet()));

        if (userCategories.size() > 0) {
            List<Expense> expenses = dslContext.select()
                    .from(EXPENSE)
                    .where(conditions)
                    .fetch(record -> {
                        Expense into = record.into(Expense.class);
                        into.setCategory(userCategories.get(record.getValue(EXPENSE.CATEGORY_ID)));
                        return into;
                    });

            return expenses;
        } else {
            return Collections.emptyList();
        }
    }
}
