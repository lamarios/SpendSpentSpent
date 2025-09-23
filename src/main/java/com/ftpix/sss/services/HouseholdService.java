package com.ftpix.sss.services;


import com.ftpix.sss.dao.HouseholdDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.*;
import com.ftpix.sss.websockets.WebSocketSessionManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.Arrays;
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
        hm.setColor(HouseholdColor.values()[0]);
        hm.setStatus(HouseholdInviteStatus.accepted);
        hm.setUser(user);
        hs.setMembers(List.of(hm));

        // we need to delete all other invitations
        getInvitations(user).forEach(householdMember -> householdDao.getHouseholdMemberDao().delete(householdMember));


        return householdDao.insert(hs);
    }

    public Optional<Household> getCurrentHousehold(User user) {
        return householdDao.getUserHousehold(user);
    }

    private boolean isHouseholdAdmin(User user, Household household) {
        return household.getMembers()
                .stream()
                .filter(member -> member.getUser().getId().equals(user.getId()))
                .findFirst()
                .map(HouseholdMember::isAdmin)
                .orElse(false);
    }

    public void inviteUser(User user, String email) throws SQLException {
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

            // you can only invite someone once
            Household household = hs.get();
            var similarInvites = household.getMembers()
                    .stream()
                    .filter(householdMember -> householdMember.getUser()
                            .getId()
                            .equals(invitee.get()
                                    .getId()) && householdMember.getStatus() == HouseholdInviteStatus.pending)
                    .count();

            if (similarInvites > 0) {
                return;
            }

            HouseholdMember hm = new HouseholdMember();
            hm.setUser(invitee.get());
            hm.setInvitedBy(user);
            hm.setStatus(HouseholdInviteStatus.pending);
            hm.setAdmin(false);

            var usedColors = household.getMembers().stream().map(HouseholdMember::getColor).toList();
            var color = Arrays.stream(HouseholdColor.values())
                    .filter(c -> !usedColors.contains(c))
                    .findFirst();

            hm.setColor(color.get());
            hm.setHousehold(household);
            householdDao.getHouseholdMemberDao().insert(hm);


            sendMessageToOtherUsers(getCurrentHousehold(user).get(), user);
        }
    }

    public Household updateUser(User user, HouseholdMember member) {
        return null;
    }

    public void removeMember(User user, User memberId) throws SQLException {
        Optional<Household> currentHousehold = getCurrentHousehold(user);
        currentHousehold.filter(hs -> isHouseholdAdmin(user, hs))
                .flatMap(hs -> hs.getMembers()
                        .stream()
                        .filter(m -> m.getUser().getId().equals(memberId.getId()))
                        .findFirst())
                .ifPresent(membership -> {
                    householdDao.getHouseholdMemberDao().delete(membership);

                });

        if (currentHousehold.isPresent()) {
            sendMessageToOtherUsers(currentHousehold.get(), user);
        }
    }

    public void deleteHousehold(User user) throws SQLException {
        Optional<Household> currentHousehold = getCurrentHousehold(user);
        currentHousehold.filter(household -> isHouseholdAdmin(user, household))
                .ifPresent(householdDao::delete);
        if (currentHousehold.isPresent()) {
            sendMessageToOtherUsers(currentHousehold.get(), user);
        }
    }

    public boolean leaveHousehold(User user) throws SQLException {
        var hs = getCurrentHousehold(user);
        if (hs.isPresent()) {
            var house = hs.get();

            if (house.getMembers().size() > 1) {

                house.getMembers()
                        .stream()
                        .filter(member -> member.getUser().getId().equals(user.getId()))
                        .findFirst()
                        .ifPresent(member -> householdDao.getHouseholdMemberDao().delete(member));


                sendMessageToOtherUsers(house, user);

                return true;
            } else {
                householdDao.delete(house);
            }
        }
        return false;
    }

    public List<HouseholdMember> getInvitations(User user) {
        return householdDao.getHouseholdMemberDao()
                .getWhere(HOUSEHOLD_MEMBERS.USER_ID.eq(user.getId()
                        .toString()), HOUSEHOLD_MEMBERS.STATUS.eq(HouseholdInviteStatus.pending.name()));
    }

    public Optional<Household> acceptInvitation(User invitee, UUID invitationId) throws SQLException {
        List<HouseholdMember> invitations = getInvitations(invitee);
        Optional<HouseholdMember> invitation = invitations.stream()
                .filter(hs -> hs.getId().equals(invitationId))
                .findFirst();

        if (invitation.isPresent()) {
            var invite = invitation.get();
            invite.setStatus(HouseholdInviteStatus.accepted);
            householdDao.getHouseholdMemberDao().update(invite);
            invitations.remove(invite);

            // we delete remaining invitations
            invitations.forEach(member -> householdDao.getHouseholdMemberDao().delete(member));
        }

        Optional<Household> hs = getCurrentHousehold(invitee);
        sendMessageToOtherUsers(hs.get(), invitee);
        return hs;
    }

    public void rejectInvitation(User invitee, UUID invitationId) {
        List<HouseholdMember> invitations = getInvitations(invitee);

        invitations.stream()
                .filter(hs -> hs.getId().equals(invitationId))
                .findFirst()
                .ifPresent(householdMember -> householdDao.getHouseholdMemberDao().delete(householdMember));
    }

    public void setAdmin(User user, User target, boolean admin) throws SQLException {
        if (user.getId().equals(target.getId())) {
            // users can't change their own statuses
            return;
        }

        var hs = getCurrentHousehold(user);
        if (hs.isPresent() && isHouseholdAdmin(user, hs.get())) {

            hs.get()
                    .getMembers()
                    .stream()
                    .filter(member -> member.getUser().getId().equals(target.getId()))
                    .findFirst()
                    .ifPresent(member -> {
                        member.setAdmin(admin);
                        householdDao.getHouseholdMemberDao().update(member);
                    });

            sendMessageToOtherUsers(hs.get(), user);
        }

    }

    public void setColor(User currentUser, HouseholdColor householdColor) throws SQLException {
        Optional<Household> currentHousehold = getCurrentHousehold(currentUser);
        currentHousehold.flatMap(household -> household.getMembers()
                .stream()
                .filter(householdMember -> householdMember.getUser().getId().equals(currentUser.getId()))
                .findFirst()).ifPresent(householdMember -> {
            householdMember.setColor(householdColor);
            householdDao.getHouseholdMemberDao().update(householdMember);
        });
        if (currentHousehold.isPresent()) {
            sendMessageToOtherUsers(currentHousehold.get(), currentUser);
        }
    }


    private List<User> getHouseholdOtherMembers(Optional<Household> hs, User user) {
        return hs.map(household -> household.getMembers().stream().map(HouseholdMember::getUser)
                .filter(user1 -> !user1.getId().equals(user.getId()))
                .toList()).orElseGet(List::of);
    }

    public void sendMessageToOtherUsers(Household hs, User currentUser) {
        getHouseholdOtherMembers(Optional.ofNullable(hs), currentUser).forEach(user -> WebSocketSessionManager.sendToUser(user.getId()
                .toString(), new HouseholdWebsocketUpdate()));
    }

}
