package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.tables.records.HouseholdRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.Household;
import com.ftpix.sss.models.HouseholdInviteStatus;
import com.ftpix.sss.models.HouseholdMember;
import com.ftpix.sss.models.User;
import org.jooq.DSLContext;
import org.jooq.OrderField;
import org.jooq.impl.DefaultDSLContext;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.HOUSEHOLD;
import static com.ftpix.sss.dsl.Tables.HOUSEHOLD_MEMBERS;

@Component
public class HouseholdDao implements Dao<HouseholdRecord, Household> {
    private final DefaultDSLContext dslContext;
    private final HouseholdMemberDao householdMemberDao;

    private final List<DaoListener<Household>> listeners = new ArrayList<>();

    @Autowired
    public HouseholdDao(DefaultDSLContext dslContext) {
        this.dslContext = dslContext;
        this.householdMemberDao = new HouseholdMemberDao(dslContext);
    }

    @Override
    public Household insert(Household hs) {
        var newHs = Dao.super.insert(hs);
        newHs.setMembers(new ArrayList<>());
        for (HouseholdMember householdMember : hs.getMembers()) {
            householdMember.setHousehold(newHs);
            householdMemberDao.insert(householdMember);
        }
        return getOneWhere(HOUSEHOLD.ID.eq(newHs.getId().toString())).get();
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addListener(DaoListener<Household> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<Household>> getListeners() {
        return listeners;
    }

    @Override
    public TableImpl<HouseholdRecord> getTable() {
        return HOUSEHOLD;
    }

    @Override
    public Household fromRecord(HouseholdRecord record) {
        Household hh = new Household();
        hh.setId(UUID.fromString(record.getId()));
        var members = record.fetchChildren(Keys.HOUSEHOLD_MEMBERS__FK_HOUSEHOLD);

        hh.setMembers(members.map(householdMemberDao::fromRecord));

        return hh;
    }

    public List<User> getHouseholdUsers(User user) {
        Optional<Household> household = getUserHousehold(user);

        List<User> users = new ArrayList<>();
        if (household.isPresent()) {
            household.get().getMembers().forEach(m -> users.add(m.getUser()));
        } else {
            users.add(user);
        }

        return users;
    }

    @Override
    public HouseholdRecord setRecordData(HouseholdRecord householdRecord, Household object) {
        householdRecord.setId(object.getId().toString());
        return householdRecord;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[0];
    }

    public Optional<Household> getUserHousehold(User user) {
        List<HouseholdMember> where = householdMemberDao.getWhere(HOUSEHOLD_MEMBERS.USER_ID.eq(user.getId()
                .toString()), HOUSEHOLD_MEMBERS.STATUS.eq(HouseholdInviteStatus.accepted.name()));
        return where
                .stream()
                .findFirst()
                .flatMap(member -> getOneWhere(HOUSEHOLD.ID.eq(member.getHousehold().getId().toString())));

    }


    public HouseholdMemberDao getHouseholdMemberDao() {
        return householdMemberDao;
    }
}