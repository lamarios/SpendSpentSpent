package com.ftpix.sss.models;

import java.util.UUID;

public class User {
    public final static long NEVER = Long.MAX_VALUE - 1;

    private UUID id = UUID.randomUUID();


    private String email;

    private String firstName;

    private String password;

    private String lastName;

    private long subscriptionExpiryDate;

    private boolean showAnnouncement = false;
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
