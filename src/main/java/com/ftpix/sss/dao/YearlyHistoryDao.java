package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.YearlyHistoryRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.YearlyHistory;
import org.jooq.DSLContext;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.YEARLY_HISTORY;

@Component("yearlyHistoryDaoJooq")
public class YearlyHistoryDao implements Dao<YearlyHistoryRecord, YearlyHistory> {

    private final DSLContext dslContext;
    private final List<DaoListener<YearlyHistory>> listeners = new ArrayList<>();

    @Autowired
    public YearlyHistoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
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
    public YearlyHistory fromRecord(YearlyHistoryRecord r) {
        YearlyHistory h = new YearlyHistory();
        h.setId(UUID.fromString(r.getId()));
        h.setCategory(getCategory(r.getCategoryId()));
        h.setDate(r.getDate());
        h.setTotal(r.getTotal());

        return h;
    }

    @Override
    public YearlyHistoryRecord toRecord(YearlyHistory o) {
        YearlyHistoryRecord r = new YearlyHistoryRecord();
        r.setId(o.getId().toString());
        r.setCategoryId(o.getCategory().getId());
        r.setDate(o.getDate());
        r.setTotal(o.getTotal());
        return r;
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
    public boolean insert(YearlyHistory object) {
        object.setId(UUID.randomUUID());
        return Dao.super.insert(object);
    }
}
