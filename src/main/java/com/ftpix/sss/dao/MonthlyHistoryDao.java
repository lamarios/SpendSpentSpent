package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.dsl.tables.records.MonthlyHistoryRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.MonthlyHistory;
import com.ftpix.sss.services.HistoryService;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.CATEGORY;
import static com.ftpix.sss.dsl.Tables.MONTHLY_HISTORY;

@Component("monthlyHistoryDaoJooq")
public class MonthlyHistoryDao implements Dao<MonthlyHistoryRecord, MonthlyHistory> {
    private final DSLContext dslContext;
    private final List<DaoListener<MonthlyHistory>> listeners = new ArrayList<>();

    @Autowired
    public MonthlyHistoryDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
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
    public MonthlyHistory fromRecord(MonthlyHistoryRecord r) {
        MonthlyHistory h = new MonthlyHistory();
        h.setId(UUID.fromString(r.getId()));
        h.setCategory(getCategory(r.getCategoryId()));
        h.setDate(r.getDate());
        h.setTotal(r.getTotal());

        return h;
    }

    @Override
    public MonthlyHistoryRecord toRecord(MonthlyHistory o) {
        MonthlyHistoryRecord r = new MonthlyHistoryRecord();
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
    public boolean insert(MonthlyHistory object) {
        object.setId(UUID.randomUUID());
        return Dao.super.insert(object);
    }
}
