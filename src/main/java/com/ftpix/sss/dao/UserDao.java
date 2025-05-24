package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.tables.records.UserRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.User;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.jooq.OrderField;
import org.jooq.impl.DSL;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.*;

@Component("userDaoJooq")
public class UserDao implements Dao<UserRecord, User> {
    private final DSLContext dslContext;
    private final List<DaoListener<User>> listeners = new ArrayList<>();

    @Autowired
    public UserDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addListener(DaoListener<User> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<User>> getListeners() {
        return listeners;
    }

    public int countUsers(Condition... conditions) {
        return dslContext.select(DSL.count()).from(USER).where(conditions).fetchOne(r -> r.into(Integer.class));
    }

    @Override
    public UserRecord setRecordData(UserRecord record, User user) {
        record.setId(user.getId().toString());
        record.setPassword(user.getPassword());
        record.setEmail(user.getEmail());
        record.setFirstname(user.getFirstName());
        record.setLastname(user.getLastName());
        record.setSubscriptionexpirydate(user.getSubscriptionExpiryDate());
        record.setShowannouncement(user.isShowAnnouncement() ? 1 : 0);
        record.setIsadmin(user.isAdmin() ? 1 : 0);
        record.setOidcsub(user.getOidcSub());

        return record;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[]{USER.EMAIL.asc()};
    }

    @Override
    public TableImpl<UserRecord> getTable() {
        return USER;
    }

    @Override
    public User fromRecord(UserRecord r) {
        User u = new User();
        u.setId(UUID.fromString(r.getId()));
        u.setPassword(r.getPassword());
        u.setEmail(r.getEmail());
        u.setFirstName(r.getFirstname());
        u.setLastName(r.getLastname());
        u.setSubscriptionExpiryDate(r.getSubscriptionexpirydate());
        u.setShowAnnouncement(r.getShowannouncement() != null && r.getShowannouncement().equals(1));
        u.setAdmin(r.getIsadmin() != null && r.getIsadmin().equals(1));
        u.setOidcSub(r.getOidcsub());


        return u;
    }

    @Override
    public User insert(User object) {
        return Dao.super.insert(object);
    }
}
