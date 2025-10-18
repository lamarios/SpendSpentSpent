package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Keys;
import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.dsl.tables.records.ApiKeysRecord;
import com.ftpix.sss.dsl.tables.records.UserRecord;
import com.ftpix.sss.listeners.DaoListener;
import com.ftpix.sss.models.ApiKey;
import org.jooq.DSLContext;
import org.jooq.OrderField;
import org.jooq.impl.TableImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Component
public class ApiKeyDao implements Dao<ApiKeysRecord, ApiKey> {

    private final DSLContext dslContext;
    private final List<DaoListener<ApiKey>> listeners = new ArrayList<>();

    @Autowired
    public ApiKeyDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    @Override
    public DSLContext getDsl() {
        return dslContext;
    }

    @Override
    public void addListener(DaoListener<ApiKey> listener) {
        listeners.add(listener);
    }

    @Override
    public List<DaoListener<ApiKey>> getListeners() {
        return List.of();
    }

    @Override
    public TableImpl<ApiKeysRecord> getTable() {
        return Tables.API_KEYS;
    }

    @Override
    public ApiKey fromRecord(ApiKeysRecord record) {
        ApiKey key = new ApiKey();
        key.setId(UUID.fromString(record.getId()));
        key.setApiKey(record.getApikey());
        key.setTimeCreated(record.getTimecreated());
        key.setExpiryDate(record.getExpirydate());
        key.setKeyName(record.getKeyname());
        key.setLastUsed(record.getLastused());
        key.setApiKeyHash(record.getApikeyhash());

        if (record.getUserId() != null) {
            UserDao userDao = new UserDao(getDsl());
            key.setUser(record.fetchParent(Keys.API_KEYS__FK_API_KEY_USER)
                    .map(userRecord -> userDao.fromRecord((UserRecord) userRecord)));
        }

        return key;
    }

    @Override
    public ApiKeysRecord setRecordData(ApiKeysRecord record, ApiKey apiKey) {
        if (apiKey.getId() == null) {
            apiKey.setId(UUID.randomUUID());
        }

        record.setId(apiKey.getId().toString());
        record.setApikey(apiKey.getApiKey());
        record.setTimecreated(apiKey.getTimeCreated());
        record.setExpirydate(apiKey.getExpiryDate());
        record.setUserId(apiKey.getUser().getId().toString());
        record.setLastused(apiKey.getLastUsed());
        record.setKeyname(apiKey.getKeyName());
        record.setApikeyhash(apiKey.getApiKeyHash());

        return record;
    }

    @Override
    public OrderField[] getDefaultOrderBy() {
        return new OrderField[0];
    }
}
