package com.ftpix.sss.models;

import java.util.UUID;

public class HouseholdMember {
    private UUID id = UUID.randomUUID();
    private User user;
    private User invitedBy;
    private HouseholdInviteStatus status;
    private boolean admin;
    private HouseholdColor color;
    private Household household;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public User getInvitedBy() {
        return invitedBy;
    }

    public void setInvitedBy(User invitedBy) {
        this.invitedBy = invitedBy;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public HouseholdInviteStatus getStatus() {
        return status;
    }

    public void setStatus(HouseholdInviteStatus status) {
        this.status = status;
    }

    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public HouseholdColor getColor() {
        return color;
    }

    public void setColor(HouseholdColor color) {
        this.color = color;
    }

    public Household getHousehold() {
        return household;
    }

    public void setHousehold(Household household) {
        this.household = household;
    }
}
