package com.ftpix.sss.models;


import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.UUID;

@DatabaseTable(tableName = "RESET_PASSWORD")
public class ResetPassword {

    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private UUID id = UUID.randomUUID();

    @DatabaseField(columnName = "USER_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 3, foreignColumnName = "ID")
    private User user;

    @DatabaseField
    private long expiryDate;

    public long getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(long expiryDate) {
        this.expiryDate = expiryDate;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
