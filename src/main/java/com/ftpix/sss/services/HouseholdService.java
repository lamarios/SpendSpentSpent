package com.ftpix.sss.services;


import com.ftpix.sss.dao.HouseholdDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.dsl.Tables.HOUSEHOLD_MEMBERS;
import static com.ftpix.sss.dsl.Tables.USER;

@Service
public class HouseholdService {

    private final HouseholdDao householdDao;
    private final UserDao userDao;

    @Autowired
    public HouseholdService(HouseholdDao householdDao, UserDao userDao) {
        this.householdDao = householdDao;
        this.userDao = userDao;
    }

    public Household createHousehold(User user) {
        var household = getCurrentHousehold(user);

        if (household.isPresent()) {
            return household.get();
        }

        Household hs = new Household();
        hs.setId(UUID.randomUUID());
        HouseholdMember hm = new HouseholdMember();
        hm.setAdmin(true);
        hm.setId(UUID.randomUUID());
        hm.setColors(HouseholdColor.values()[0]);
        hm.setStatus(HouseholdInviteStatus.accepted);
        hm.setUser(user);
        hs.setMembers(List.of(hm));

        return householdDao.insert(hs);
    }

    public Optional<Household> getCurrentHousehold(User user) {
        return householdDao.getUserHousehold(user);
    }

    private boolean isHouseholdAdmin(User user, Household household) {
        return household.getMembers().stream().filter(member -> member.getUser().getId().equals(user.getId()))
                .findFirst()
                .map(HouseholdMember::isAdmin)
                .orElse(false);
    }

    public void inviteUser(User user, String email) {
        var invitee = userDao.getOneWhere(USER.EMAIL.eq(email));
        var hs = getCurrentHousehold(user);


        // we check if the invitee has a household

        if (invitee.isPresent() && hs.isPresent()) {
            if (!isHouseholdAdmin(user, hs.get())) {
                return;
            }

            // users can only be in a single household
            var inviteeHousehold = getCurrentHousehold(invitee.get());
            if (inviteeHousehold.isPresent()) {
                // we don't return errors. we want to avoid email guessing
                return;
            }

            HouseholdMember hm = new HouseholdMember();
            hm.setUser(invitee.get());
            hm.setInvitedBy(user);
            hm.setStatus(HouseholdInviteStatus.pending);
            hm.setAdmin(false);

            Household household = hs.get();
            hm.setColors(HouseholdColor.values()[household.getMembers().size() - 1]);
            hm.setHousehold(household);
            householdDao.getHouseholdMemberDao().insert(hm);
        }
    }

    public Household updateUser(User user, HouseholdMember member) {
        return null;
    }

    public void removeMember(User user, User memberId) {
        getCurrentHousehold(user)
                .filter(hs -> isHouseholdAdmin(user, hs))
                .flatMap(hs -> hs.getMembers()
                        .stream()
                        .filter(m -> m.getUser().getId().equals(memberId.getId()))
                        .findFirst())
                .ifPresent(membership -> householdDao.getHouseholdMemberDao().delete(membership));
    }

    public boolean deleteHousehold(User user, String householdId) {
        return false;
    }

    public boolean leaveHousehold(User user) {
        var hs = getCurrentHousehold(user);
        if (hs.isPresent()) {
            var house = hs.get();
            house.getMembers()
                    .stream()
                    .filter(member -> member.getUser().getId().equals(user.getId()))
                    .findFirst()
                    .ifPresent(member -> householdDao.getHouseholdMemberDao().delete(member));
            return true;
        }
        return false;
    }

    public List<HouseholdMember> getInvitations(User user) {
        return householdDao.getHouseholdMemberDao()
                .getWhere(HOUSEHOLD_MEMBERS.USER_ID.eq(user.getId()
                        .toString()), HOUSEHOLD_MEMBERS.STATUS.eq(HouseholdInviteStatus.pending.name()));
    }

    public Optional<Household> acceptInvitation(User invitee, UUID householdId) {
        List<HouseholdMember> invitations = getInvitations(invitee);
        Optional<HouseholdMember> invitation = invitations.stream()
                .filter(hs -> hs.getHousehold().getId().equals(householdId))
                .findFirst();

        if (invitation.isPresent()) {
            var invite = invitation.get();
            invite.setStatus(HouseholdInviteStatus.accepted);
            householdDao.getHouseholdMemberDao().update(invite);
            invitations.remove(invite);

            // we delete remaining invitations
            invitations.forEach(member -> householdDao.getHouseholdMemberDao().delete(member));
        }

        return getCurrentHousehold(invitee);
    }

    public void setAdmin(User user, User target, boolean admin) {
        if (user.getId().equals(target.getId())) {
            // users can't change their own statuses
            return;
        }

        var hs = getCurrentHousehold(user);
        if (hs.isPresent() && isHouseholdAdmin(user, hs.get())) {

            hs.get().getMembers().stream().filter(member -> member.getUser().getId().equals(target.getId()))
                    .findFirst().ifPresent(member -> {
                        member.setAdmin(admin);
                        householdDao.getHouseholdMemberDao().update(member);
                    });
        }

    }

    public void setColor(User currentUser, HouseholdColor householdColor) {
        getCurrentHousehold(currentUser)
                .flatMap(household -> household.getMembers()
                        .stream()
                        .filter(householdMember -> householdMember.getUser().getId().equals(currentUser.getId()))
                        .findFirst())
                .ifPresent(householdMember -> {
                    householdMember.setColors(householdColor);
                    householdDao.getHouseholdMemberDao().update(householdMember);
                });
    }
}
