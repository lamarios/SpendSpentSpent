package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.dsl.tables.records.ResetPasswordRecord;
import com.ftpix.sss.models.ResetPassword;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.*;

@Component("resetPasswordDaoJooq")
public class ResetPasswordDao {
    private final DSLContext dslContext;

    public ResetPasswordDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public int deleteWhere(Condition... conditions) {
        if (conditions.length > 0) {
            return dslContext.delete(RESET_PASSWORD).where(conditions).execute();
        } else {
            return 0;
        }
    }

    public void create(ResetPassword resetPassword) {
        resetPassword.setId(UUID.randomUUID());
        dslContext.executeInsert(toRecord(resetPassword));
    }

    public Optional<ResetPassword> getById(UUID id) {
        return dslContext.fetchOptional(RESET_PASSWORD, RESET_PASSWORD.ID.eq(id.toString()))
                .map(this::fromRecord);
    }

    private ResetPassword fromRecord(ResetPasswordRecord r) {
        return r.into(ResetPassword.class);
    }

    private ResetPasswordRecord toRecord(ResetPassword p) {
        ResetPasswordRecord r = new ResetPasswordRecord();
        r.setId(p.getId().toString());
        r.setUserId(p.getUser().getId().toString());
        r.setExpirydate(p.getExpiryDate());
        return r;
    }

    public void delete(ResetPassword resetPassword) {
        ResetPasswordRecord resetPasswordRecord = toRecord(resetPassword);
        dslContext.executeDelete(resetPasswordRecord);
    }
}
