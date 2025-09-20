package com.ftpix.sss.models;

import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;

public class Household {
    private UUID id;
    private List<HouseholdMember> members;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public List<HouseholdMember> getMembers() {
        return members;
    }

    public void setMembers(List<HouseholdMember> members) {
        this.members = members;
    }
}
