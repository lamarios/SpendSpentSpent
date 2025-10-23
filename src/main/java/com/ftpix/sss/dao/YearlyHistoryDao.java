package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.YearlyHistoryRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.listeners.DaoUserListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.YearlyHistory;
import org.checkerframework.checker.units.qual.C;
import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.OrderField;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.Year;
import java.util.*;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.YEARLY_HISTORY;

@Component("yearlyHistoryDaoJooq")
public class YearlyHistoryDao implements Dao<YearlyHistoryRecord, YearlyHistory>, UserCategoryBasedDao<YearlyHistoryRecord, YearlyHistory>, HouseholdCategoryBaseDao<YearlyHistoryRecord, YearlyHistory> {

    private final DSLContext dslContext;
    private final List<DaoListener<YearlyHistory>> listeners = new ArrayList<>();
    private final List<DaoUserListener<YearlyHistory>> userListeners = new ArrayList<>();

    @Autowired
    public YearlyHistoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addUserBasedListener(DaoUserListener<YearlyHistory> listener) {
        userListeners.add(listener);
    }

    @Override
    public List<DaoUserListener<YearlyHistory>> getUserBasedListeners() {
        return userListeners;
    }

    @Override
    public void addListener(DaoListener<YearlyHistory> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<YearlyHistory>> getListeners() {
        return listeners;
    }

    @Override
    public TableImpl<YearlyHistoryRecord> getTable() {
        return YEARLY_HISTORY;
    }

    @Override
    public YearlyHistory fromRecord(YearlyHistoryRecord r, Map<Long, Category> categories) {
        YearlyHistory h = new YearlyHistory();
        h.setCategory(categories.get(r.getCategoryId()));
        h.setDate(r.getDate());
        h.setTotal(r.getTotal());

        return h;
    }

    @Override
    public YearlyHistory fromRecord(YearlyHistoryRecord r) {
        Category category = getCategory(r.getCategoryId());
        Map<Long, Category> categoryMap = new HashMap<>();
        categoryMap.put(category.getId(), category);

        return fromRecord(r, categoryMap);
    }

    @Override
    public YearlyHistoryRecord setRecordData(YearlyHistoryRecord r, YearlyHistory o) {
        r.setCategoryId(o.getCategory().getId());
        r.setDate(o.getDate());
        r.setTotal(o.getTotal());
        return r;
    }

    @Override
    public Field<Long> getCategoryField() {
        return YEARLY_HISTORY.CATEGORY_ID;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{YEARLY_HISTORY.TOTAL.desc()};
    }

    private Category getCategory(long id) {
        return dslContext.select()
                .from(CATEGORY)
                .where(CATEGORY.ID.eq(id))
                .fetchOne(r -> {
                    return r.into(Category.class);
                });
    }
}
