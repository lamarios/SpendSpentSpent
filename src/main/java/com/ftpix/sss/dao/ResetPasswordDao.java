package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.ResetPasswordRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.ResetPassword;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.OrderField;
import org.jooq.impl.TableImpl;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.*;

@Component("resetPasswordDaoJooq")
public class ResetPasswordDao implements Dao<ResetPasswordRecord, ResetPassword> {
    private final DSLContext dslContext;
    private final List<DaoListener<ResetPassword>> listeners = new ArrayList<>();

    public ResetPasswordDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addListener(DaoListener<ResetPassword> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<ResetPassword>> getListeners() {
        return listeners;
    }

    public int deleteWhere(Condition... conditions) {
        if (conditions.length > 0) {
            return dslContext.delete(RESET_PASSWORD).where(conditions).execute();
        } else {
            return 0;
        }
    }

    public Optional<ResetPassword> getById(UUID id) {
        return this.getOneWhere(RESET_PASSWORD.ID.eq(id.toString()));
    }

    @Override
    public ResetPassword fromRecord(ResetPasswordRecord r) {
        return r.into(ResetPassword.class);
    }

    @Override
    public ResetPasswordRecord setRecordData(ResetPasswordRecord r, ResetPassword p) {
        r.setId(p.getId().toString());
        r.setUserId(p.getUser().getId().toString());
        r.setExpirydate(p.getExpiryDate());
        return r;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{RESET_PASSWORD.EXPIRYDATE.desc()};
    }

    @Override
    public TableImpl<ResetPasswordRecord> getTable() {
        return RESET_PASSWORD;
    }

    @Override
    public ResetPassword insert(ResetPassword object) {
        object.setId(UUID.randomUUID());
        return Dao.super.insert(object);
    }
}
