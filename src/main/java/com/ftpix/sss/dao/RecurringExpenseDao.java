package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.RecurringExpenseRecord;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.RECURRING_EXPENSE;

@Component("recurringExpenseDaoJooq")
public class RecurringExpenseDao implements UserCategoryBasedDao<RecurringExpenseRecord, RecurringExpense> {
    private final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    private final DSLContext dslContext;
    private final List<DaoUserListener<RecurringExpense>> listeners = new ArrayList<>();

    @Autowired
    public RecurringExpenseDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }


    @Override
    public RecurringExpense fromRecord(RecurringExpenseRecord r, Map<Long, Category> categories) {
        try {
            RecurringExpense e = new RecurringExpense();
            e.setId(r.getId());
            e.setType(r.getType());
            e.setLastOccurrence(r.getLastOccurrence() != null && r.getLastOccurrence()
                    .length() > 0 ? df.parse(r.getLastOccurrence()) : null);
            e.setNextOccurrence(r.getNextOccurrence() != null && r.getNextOccurrence()
                    .length() > 0 ? df.parse(r.getNextOccurrence()) : null);
            e.setTypeParam(r.getTypeParam());
            e.setIncome(r.getIncome() != null && r.getIncome().equals(1));
            e.setAmount(r.getAmount());
            e.setName(r.getName());
            e.setCategory(categories.get(r.getCategoryId()));

            return e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addUserBasedListener(DaoUserListener<RecurringExpense> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoUserListener<RecurringExpense>> getUserBasedListeners() {
        return listeners;
    }

    @Override
    public TableImpl<RecurringExpenseRecord> getTable() {
        return RECURRING_EXPENSE;
    }

    @Override
    public RecurringExpenseRecord setRecordData(RecurringExpenseRecord r, RecurringExpense e) {
        if (e.getId() != null) {
            r.setId(e.getId());
        }
        r.setName(e.getName());
        r.setCategoryId(e.getCategory().getId());
        r.setType(e.getType());
        r.setTypeParam(e.getTypeParam());
        r.setLastOccurrence(e.getLastOccurrence() != null ? df.format(e.getLastOccurrence()) : null);
        r.setNextOccurrence(e.getNextOccurrence() != null ? df.format(e.getNextOccurrence()) : null);
        r.setAmount(e.getAmount());
        r.setIncome(e.isIncome() ? 1 : 0);

        return r;
    }

    @Override
    public Field<Long> getCategoryField() {
        return RECURRING_EXPENSE.CATEGORY_ID;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{RECURRING_EXPENSE.ID.asc()};
    }

    public RecurringExpense queryForId(User user, long id) {
        return getOneWhere(user, RECURRING_EXPENSE.ID.eq(id)).orElse(null);
    }

    public boolean deleteById(User user, long id) {
        return deleteWhere(user, RECURRING_EXPENSE.ID.eq(id)) == 1;
    }

    public List<RecurringExpense> queryForAll(List<Category> categories) {
        var categoriesById = categories.stream().collect(Collectors.toMap(Category::getId, Function.identity()));
        return dslContext.select()
                .from(RECURRING_EXPENSE)
                .fetch(r -> fromRecord((RecurringExpenseRecord) r, categoriesById));
    }
}
