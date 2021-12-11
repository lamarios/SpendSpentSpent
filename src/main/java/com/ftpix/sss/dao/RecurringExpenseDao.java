package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.RecurringExpenseRecord;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import edu.emory.mathcs.backport.java.util.Collections;
import org.apache.commons.lang.ArrayUtils;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.ftpix.sss.dsl.Tables.*;

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
            e.setLastOccurrence(df.parse(r.getLastOccurrence()));
            e.setNextOccurrence(df.parse(r.getNextOccurrence()));
            e.setTypeParam(r.getTypeParam());
            e.setIncome(r.getIncome() != null && r.getIncome().equals((byte) 1));
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
    public void addListener(DaoUserListener<RecurringExpense> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoUserListener<RecurringExpense>> getListeners() {
        return listeners;
    }

    @Override
    public TableImpl<RecurringExpenseRecord> getTable() {
        return RECURRING_EXPENSE;
    }

    @Override
    public RecurringExpenseRecord toRecord(RecurringExpense e) {
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

    @Override
    public Field<Long> getCategoryField() {
        return RECURRING_EXPENSE.CATEGORY_ID;
    }

    public RecurringExpense queryForId(User user, long id) {
        return getOneWhere(user, RECURRING_EXPENSE.ID.eq(id)).orElse(null);
    }

    public boolean deleteById(User user, long id) {
        return deleteWhere(user, RECURRING_EXPENSE.ID.eq(id)) == 1;
    }
}
