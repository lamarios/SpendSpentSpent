package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.tables.HouseholdMembers;
import com.ftpix.sss.dsl.tables.records.HouseholdMembersRecord;
import com.ftpix.sss.dsl.tables.records.UserRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.HouseholdColor;
import com.ftpix.sss.models.HouseholdInviteStatus;
import com.ftpix.sss.models.HouseholdMember;
import org.jooq.DSLContext;
import org.jooq.OrderField;
import org.jooq.impl.DefaultDSLContext;
import org.jooq.impl.TableImpl;

import java.util.List;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.HOUSEHOLD_MEMBERS;

public class HouseholdMemberDao implements Dao<HouseholdMembersRecord, HouseholdMember> {

    private final DefaultDSLContext dslContext;

    public HouseholdMemberDao(DefaultDSLContext dslContext) {
        this.dslContext = dslContext;
    }


    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addListener(DaoListener<HouseholdMember> listener) {

    }

    @Override
    public List<DaoListener<HouseholdMember>> getListeners() {
        return List.of();
    }

    @Override
    public TableImpl<HouseholdMembersRecord> getTable() {
        return HOUSEHOLD_MEMBERS;
    }

    @Override
    public HouseholdMember fromRecord(HouseholdMembersRecord r) {
        HouseholdMember hm = new HouseholdMember();
        hm.setId(UUID.fromString(r.getId()));
        hm.setAdmin(r.getAdmin());
        hm.setStatus(HouseholdInviteStatus.valueOf(r.getStatus()));
        hm.setColors(HouseholdColor.valueOf(r.getColor()));

        UserDao userDao = new UserDao(getDsl());
        hm.setInvitedBy(r.fetchParent(Keys.HOUSEHOLD_MEMBERS__FK_HOUSEHOLD_INVITED_BY)
                .map(record -> userDao.fromRecord((UserRecord) record)));
        hm.setUser(r.fetchParent(Keys.HOUSEHOLD_MEMBERS__FK_HOUSEHOLD_USER)
                .map(record -> userDao.fromRecord((UserRecord) record)));

        return hm;
    }

    @Override
    public HouseholdMembersRecord setRecordData(HouseholdMembersRecord r, HouseholdMember hm) {
        r.setId(hm.getId().toString());
        r.setHouseholdId(hm.getHousehold().getId().toString());
        r.setAdmin(hm.isAdmin());
        r.setColor(hm.getColors().toString());
        r.setStatus(hm.getStatus().toString());
        r.setUserId(hm.getUser().getId().toString());
        r.setInvitedById(hm.getInvitedBy().getId().toString());

        return r;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[0];
    }
}
