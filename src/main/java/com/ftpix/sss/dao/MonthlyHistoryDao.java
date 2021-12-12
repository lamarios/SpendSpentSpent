package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.MonthlyHistoryRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.MonthlyHistory;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.MONTHLY_HISTORY;

@Component("monthlyHistoryDaoJooq")
public class MonthlyHistoryDao implements Dao<MonthlyHistoryRecord, MonthlyHistory>, UserCategoryBasedDao<MonthlyHistoryRecord, MonthlyHistory> {
    private final DSLContext dslContext;
    private final List<DaoListener<MonthlyHistory>> listeners = new ArrayList<>();
    private final List<DaoUserListener<MonthlyHistory>> userListeners = new ArrayList<>();

    @Autowired
    public MonthlyHistoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addUserBasedListener(DaoUserListener<MonthlyHistory> listener) {
        userListeners.add(listener);
    }

    @Override
    public List<DaoUserListener<MonthlyHistory>> getUserBasedListeners() {
        return userListeners;
    }

    @Override
    public void addListener(DaoListener<MonthlyHistory> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<MonthlyHistory>> getListeners() {
        return listeners;
    }

    @Override
    public TableImpl<MonthlyHistoryRecord> getTable() {
        return MONTHLY_HISTORY;
    }

    @Override
    public MonthlyHistory fromRecord(MonthlyHistoryRecord r, Map<Long, Category> categories) {
        MonthlyHistory h = new MonthlyHistory();
        h.setId(UUID.fromString(r.getId()));
        h.setCategory(categories.get(r.getCategoryId()));
        h.setDate(r.getDate());
        h.setTotal(r.getTotal());

        return h;
    }

    @Override
    public MonthlyHistory fromRecord(MonthlyHistoryRecord r) {
        Category category = getCategory(r.getCategoryId());
        Map<Long, Category> categoryMap = new HashMap<>();
        categoryMap.put(category.getId(), category);

        return fromRecord(r, categoryMap);
    }

    @Override
    public MonthlyHistoryRecord setRecordData(MonthlyHistoryRecord r, MonthlyHistory o) {
        r.setId(o.getId().toString());
        r.setCategoryId(o.getCategory().getId());
        r.setDate(o.getDate());
        r.setTotal(o.getTotal());
        return r;
    }

    @Override
    public Field<Long> getCategoryField() {
        return null;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{MONTHLY_HISTORY.TOTAL.desc()};
    }

    private Category getCategory(long id) {
        return dslContext.select()
                .from(CATEGORY)
                .where(CATEGORY.ID.eq(id))
                .fetchOne(r -> {
                    return r.into(Category.class);
                });
    }

    @Override
    public MonthlyHistory insert(MonthlyHistory object) {
        object.setId(UUID.randomUUID());
        return Dao.super.insert(object);
    }
}
