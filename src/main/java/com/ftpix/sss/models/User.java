package com.ftpix.sss.models;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.UUID;

@DatabaseTable(tableName = "USER")
public class User {
    public final static long NEVER = Long.MAX_VALUE - 1;

    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private UUID id = UUID.randomUUID();


    @DatabaseField(columnName = "EMAIL", unique = true, canBeNull = false)
    private String email;

    @DatabaseField(columnName = "FIRSTNAME", canBeNull = false)
    private String firstName;

    @DatabaseField(columnName = "PASSWORD", canBeNull = false)
    private String password;

    @DatabaseField(columnName = "LASTNAME", canBeNull = false)
    private String lastName;

    @DatabaseField(columnName = "SUBSCRIPTIONEXPIRYDATE")
    private long subscriptionExpiryDate;

    @DatabaseField(columnName = "SHOWANNOUNCEMENT", dataType = DataType.BOOLEAN_INTEGER)
    private boolean showAnnouncement = false;
    @DatabaseField(columnName = "ISADMIN", dataType = DataType.BOOLEAN_INTEGER)
    private boolean isAdmin = false;

    //    @DatabaseField(columnName = "TIMECREATED")
    private long timeCreated = System.currentTimeMillis();


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public long getSubscriptionExpiryDate() {
        return subscriptionExpiryDate;
    }

    public void setSubscriptionExpiryDate(long subscriptionExpiryDate) {
        this.subscriptionExpiryDate = subscriptionExpiryDate;
    }

    public boolean isShowAnnouncement() {
        return showAnnouncement;
    }

    public void setShowAnnouncement(boolean showAnnouncement) {
        this.showAnnouncement = showAnnouncement;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public long getTimeCreated() {
        return timeCreated;
    }

    public void setTimeCreated(long timeCreated) {
        this.timeCreated = timeCreated;
    }
}
