package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.dsl.tables.records.UserRecord;
import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.PaginationService;
import org.checkerframework.checker.units.qual.C;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.Record;
import org.jooq.SelectConditionStep;
import org.jooq.impl.DSL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.*;

@Component("userDaoJooq")
public class UserDao {
    private final DSLContext dslContext;

    @Autowired
    public UserDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public Optional<User> getOneWhere(Condition... conditions) {
        if (conditions.length > 0) {
            return dslContext.select().from(USER)
                    .where(conditions)
                    .fetchOptional(r -> r.into(User.class));
        } else {
            return Optional.empty();
        }
    }

    public PaginatedResults<User> getWhere(int page, int pageSize, Condition... conditions) {
        SelectConditionStep<Record> where = dslContext.select().from(USER)
                .where(conditions);

        return PaginationService.getPaginatedResults(where, page, pageSize, r -> r.into(User.class));
    }

    public int countUsers(Condition... conditions) {


        return dslContext.select(DSL.count()).from(USER).where(conditions).fetchOne(r -> r.into(Integer.class));
    }

    public User create(User user) {
        user.setId(UUID.randomUUID());
        UserRecord userRecord = toRecord(user);
        dslContext.executeInsert(userRecord);
        return user;
    }

    private UserRecord toRecord(User user) {
        UserRecord record = new UserRecord();
        record.setId(user.getId().toString());
        record.setPassword(user.getPassword());
        record.setEmail(user.getEmail());
        record.setFirstname(user.getFirstName());
        record.setLastname(user.getLastName());
        record.setSubscriptionexpirydate(user.getSubscriptionExpiryDate());
        record.setShowannouncement((byte) (user.isShowAnnouncement() ? 1 : 0));
        record.setIsadmin((byte) (user.isAdmin() ? 1 : 0));

        return record;
    }

    public void delete(User user) {
        dslContext.delete(USER).where(USER.ID.eq(user.getId().toString())).execute();
    }

    public void update(User u) {
        UserRecord userRecord = toRecord(u);
        dslContext.executeUpdate(userRecord);
    }
}
