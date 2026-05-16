package com.ftpix.sss.models;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "household")
public class Household {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @JdbcTypeCode(SqlTypes.VARCHAR)
    private UUID id;

    @OneToMany(mappedBy = "household", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<HouseholdMember> members = new ArrayList<>();

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

    public void addMember(HouseholdMember member){
        members.add(member);
        member.setHousehold(this);
    }

    public Household withoutPendingInvitations() {
        this.members.removeIf(householdMember -> householdMember.getStatus() == HouseholdInviteStatus.pending);
        return this;
    }
}
