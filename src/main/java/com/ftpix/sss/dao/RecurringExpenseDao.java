package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.RecurringExpenseRecord;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import edu.emory.mathcs.backport.java.util.Collections;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.*;

@Component("recurringExpenseDaoJooq")
public class RecurringExpenseDao {
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    private final DSLContext dslContext;

    @Autowired
    public RecurringExpenseDao(DSLContext dslContext) {
        this.dslContext = dslContext;
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


    public RecurringExpense getOneWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, RECURRING_EXPENSE.CATEGORY_ID.in(userCategories.keySet()));

        if (userCategories.size() > 0) {
            RecurringExpenseRecord recurringExpenseRecord = dslContext.fetchOne(RECURRING_EXPENSE, conditions);
            return fromRecord(recurringExpenseRecord, userCategories.values());
        } else {
            return null;
        }
    }

    public List<RecurringExpense> getWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, RECURRING_EXPENSE.CATEGORY_ID.in(userCategories.keySet()));

        if (userCategories.size() > 0) {
            return dslContext.fetch(RECURRING_EXPENSE, conditions).stream().map(r -> fromRecord(r, userCategories.values())).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    private RecurringExpense fromRecord(RecurringExpenseRecord r, Collection<Category> categories) {
        try {
            RecurringExpense e = new RecurringExpense();
            e.setId(r.getId());
            e.setType(r.getType());
            e.setLastOccurrence(df.parse(r.getLastOccurrence()));
            e.setNextOccurrence(df.parse(r.getNextOccurrence()));
            e.setTypeParam(r.getTypeParam());
            e.setIncome(r.getIncome().equals((byte) 1));
            e.setAmount(r.getAmount());
            e.setName(r.getName());
            e.setCategory(categories.stream().filter(c -> c.getId() == r.getCategoryId()).findFirst().get());

            return e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private RecurringExpenseRecord toRecord(RecurringExpense e) {
        RecurringExpenseRecord r = new RecurringExpenseRecord();
        r.setId(e.getId());
        r.setName(e.getName());
        r.setCategoryId(e.getCategory().getId());
        r.setType(e.getType());
        r.setTypeParam(e.getTypeParam());
        r.setLastOccurrence(df.format(e.getLastOccurrence()));
        r.setNextOccurrence(df.format(e.getNextOccurrence()));
        r.setAmount(e.getAmount());
        r.setIncome((byte) (e.isIncome() ? 1 : 0));

        return r;
    }

    public void create(RecurringExpense expense) {
        RecurringExpenseRecord recurringExpenseRecord = toRecord(expense);
        dslContext.executeInsert(recurringExpenseRecord);
    }

    public RecurringExpense queryForId(User user, long id) {
        return getOneWhere(user, RECURRING_EXPENSE.ID.eq(id));
    }

    public boolean deleteById(User user, long id) {
        Map<Long, Category> userCategories = getUserCategories(user);
        return dslContext.delete(RECURRING_EXPENSE)
                .where(RECURRING_EXPENSE.CATEGORY_ID.in(userCategories.values()), RECURRING_EXPENSE.ID.eq(id))
                .execute() == 1;
    }

    public void deleteWhere(User user, Condition... filter) {
        Map<Long, Category> userCategories = getUserCategories(user);
        Condition[] conditions = (Condition[]) ArrayUtils.add(filter, RECURRING_EXPENSE.CATEGORY_ID.in(userCategories.keySet()));

        if (userCategories.isEmpty()) {
            return;
        }

        dslContext.delete(RECURRING_EXPENSE)
                .where(conditions)
                .execute();
    }

    public void update(RecurringExpense recurring) {
        RecurringExpenseRecord recurringExpenseRecord = toRecord(recurring);
        dslContext.executeUpdate(recurringExpenseRecord);
    }
}
