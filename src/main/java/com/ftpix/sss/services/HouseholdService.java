package com.ftpix.sss.services;


import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.HouseholdMemberRepository;
import com.ftpix.sss.persistence.HouseholdRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.websockets.AfterCommitMessages;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class HouseholdService {

    //    private final HouseholdDao householdDao;
//    private final UserDao userDao;
    private final HouseholdRepository householdRepository;
    private final UserRepository userRepository;
    private final HouseholdMemberRepository householdMemberRepository;
    private final EntityManager entityManager;
    private final HouseholdSeparationService householdSeparationService;
    private final HouseholdLocks householdLocks;
    private final HouseholdCategoryMergeService householdCategoryMergeService;

    @Autowired
    public HouseholdService(HouseholdRepository householdRepository, UserRepository userRepository, HouseholdMemberRepository householdMemberRepository, EntityManager entityManager, HouseholdSeparationService householdSeparationService, HouseholdLocks householdLocks, HouseholdCategoryMergeService householdCategoryMergeService) {
        this.householdRepository = householdRepository;
        this.userRepository = userRepository;
        this.householdMemberRepository = householdMemberRepository;
        this.entityManager = entityManager;
        this.householdSeparationService = householdSeparationService;
        this.householdLocks = householdLocks;
        this.householdCategoryMergeService = householdCategoryMergeService;
    }

    @Transactional
    public Household createHousehold(User user) {
        householdLocks.exclusive();
        var household = getCurrentHousehold(user);

        if (household.isPresent()) {
            return household.get();
        }

        Household hs = new Household();
        HouseholdMember hm = new HouseholdMember();
        hm.setAdmin(true);
        hm.setColor(HouseholdColor.values()[0]);
        hm.setStatus(HouseholdInviteStatus.accepted);
        hm.setUser(user);
        hs.addMember(hm);


        // we need to delete all other invitations
        List<HouseholdMember> invitations = getInvitations(user);
        householdMemberRepository.deleteAll(invitations);
//        getInvitations(user).forEach(householdMemberRepository::delete);


        return householdRepository.save(hs);
    }

    @Transactional(readOnly = true)
    public Optional<Household> getCurrentHousehold(User user) {
        return Optional.ofNullable(householdRepository.findHouseholdByUser(user));
    }

    /**
     * @return true if the user is an admin of the household they currently belong to
     */
    @Transactional(readOnly = true)
    public boolean isCurrentHouseholdAdmin(User user) {
        return getCurrentHousehold(user).map(household -> isHouseholdAdmin(user, household)).orElse(false);
    }

    private boolean isHouseholdAdmin(User user, Household household) {
        return household.getMembers()
                .stream()
                .filter(member -> member.getUser().getId().equals(user.getId()))
                .findFirst()
                .map(HouseholdMember::isAdmin)
                .orElse(false);
    }

    @Transactional
    public void inviteUser(User user, String email) {
//        var invitee = userDao.getOneWhere(USER.EMAIL.eq(email));
        Optional<User> invitee = Optional.ofNullable(userRepository.findFirstByEmail(email));
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

            if (color.isPresent()) {
                hm.setColor(color.get());
                hm.setHousehold(household);
//                householdDao.getHouseholdMemberDao().insert(hm);
                householdMemberRepository.save(hm);

                getCurrentHousehold(user).ifPresent(household1 -> sendMessageToOtherUsers(household1, user));
            }
        }
    }

    @Transactional
    public Household updateUser(User user, HouseholdMember member) {
        return null;
    }

    @Transactional
    public void removeMember(User user, User memberId) {
        // waits for running bookings so the separation sees them
        householdLocks.exclusive();
        Optional<Household> currentHousehold = getCurrentHousehold(user);
        //                    householdDao.getHouseholdMemberDao().delete(membership);
        currentHousehold.filter(hs -> isHouseholdAdmin(user, hs))
                .ifPresent(household -> {
                    if (household.getMembers().removeIf(m -> m.getUser().getId().equals(memberId.getId()))) {
                        householdRepository.saveAndFlush(household);
                        householdSeparationService.separateEntriesOutsideHousehold();
                        sendMessageToOtherUsers(household, user);
                        // the removed member isn't in the household anymore but still shows its categories
                        AfterCommitMessages.sendToUsers(List.of(memberId.getId().toString()), new HouseholdWebsocketUpdate());
                    }
                });
/*
                .flatMap(hs -> hs.getMembers()
                        .stream()
                        .filter(m -> m.getUser().getId().equals(memberId.getId()))
                        .findFirst())
                .ifPresent(householdMemberRepository::delete);
        currentHousehold.ifPresent(household -> sendMessageToOtherUsers(household, user));
*/

    }

    @Transactional
    public void deleteHousehold(User user) {
        // waits for running bookings so the separation sees them
        householdLocks.exclusive();
        Optional<Household> currentHousehold = getCurrentHousehold(user);
        currentHousehold.filter(household -> isHouseholdAdmin(user, household))
                .ifPresent(household -> {
                    householdRepository.delete(household);
                    householdRepository.flush();
                    householdSeparationService.separateEntriesOutsideHousehold();
                });
        currentHousehold.ifPresent(household -> sendMessageToOtherUsers(household, user));
    }

    @Transactional
    public boolean leaveHousehold(User user) {
        // waits for running bookings so the separation sees them
        householdLocks.exclusive();
        var hs = getCurrentHousehold(user);
        if (hs.isPresent()) {
            var house = hs.get();

            if (house.getMembers().size() > 1) {
                if (house.getMembers().removeIf(member -> member.getUser().getId().equals(user.getId()))) {

/*
                house.getMembers()
                        .stream()
                        .filter(member -> member.getUser().getId().equals(user.getId()))
                        .findFirst()
                        .ifPresent(householdMemberRepository::delete);
*/

                    householdRepository.saveAndFlush(house);
                    householdSeparationService.separateEntriesOutsideHousehold();

                    sendMessageToOtherUsers(house, user);
                }

                return true;
            } else {
//                householdDao.delete(house);
                householdRepository.delete(house);
            }
        }
        return false;
    }

    @Transactional(readOnly = true)
    public List<HouseholdMember> getInvitations(User user) {
        return householdMemberRepository.findAllByUserAndStatus(user, HouseholdInviteStatus.pending);
    }

    @Transactional
    public Optional<Household> acceptInvitation(User invitee, Household household) {
        return getInvitations(invitee).stream()
                .filter(householdMember -> householdMember.getUser()
                        .getId()
                        .equals(invitee.getId()) && householdMember.getHousehold().getId().equals(household.getId()))
                .findFirst()
                .flatMap(householdMember -> acceptInvitation(invitee, householdMember.getId()));
    }

    @Transactional
    public Optional<Household> acceptInvitation(User invitee, UUID invitationId) {
        // the household's members change, nothing may rely on the current members meanwhile
        householdLocks.exclusive();

        List<HouseholdMember> invitations = getInvitations(invitee);
        Optional<HouseholdMember> invitation = invitations.stream()
                .filter(invite -> invite.getId().equals(invitationId))
                .findFirst();

        if (invitation.isPresent()) {
            HouseholdMember householdMember = invitation.get();
            householdMember.setStatus(HouseholdInviteStatus.accepted);
//            householdDao.getHouseholdMemberDao().update(invite);
            householdMemberRepository.saveAndFlush(householdMember);
            invitations.remove(householdMember);

            // we delete remaining invitations
            Household household = householdMember.getHousehold();
            entityManager.refresh(household);
            householdMemberRepository.deleteAll(invitations);
            // the new member's categories with the same icons as the household's ones are merged into them
            householdCategoryMergeService.mergeDuplicateCategories(household);
            sendMessageToOtherUsers(household, invitee);
            return Optional.of(household);
        }


        Optional<Household> hs = getCurrentHousehold(invitee);
        hs.ifPresent(household -> sendMessageToOtherUsers(household, invitee));
        return hs;
    }

    @Transactional
    public void rejectInvitation(User invitee, UUID invitationId) {
        List<HouseholdMember> invitations = getInvitations(invitee);

        invitations.stream()
                .filter(hs -> hs.getId().equals(invitationId))
                .findFirst()
                .ifPresent(householdMemberRepository::delete);
    }

    @Transactional
    public void setAdmin(User user, User target, boolean admin) {
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
                        householdMemberRepository.save(member);
                    });

            sendMessageToOtherUsers(hs.get(), user);
        }

    }

    @Transactional
    public void setColor(User currentUser, HouseholdColor householdColor) {
        Optional<Household> currentHousehold = getCurrentHousehold(currentUser);
        currentHousehold.flatMap(household -> household.getMembers()
                .stream()
                .filter(householdMember -> householdMember.getUser().getId().equals(currentUser.getId()))
                .findFirst()).ifPresent(householdMember -> {
            householdMember.setColor(householdColor);
            householdMemberRepository.save(householdMember);
        });
        currentHousehold.ifPresent(household -> sendMessageToOtherUsers(household, currentUser));
    }


    private List<User> getHouseholdOtherMembers(Optional<Household> hs, User user) {
        return hs.map(household -> household.getMembers().stream().map(HouseholdMember::getUser)
                .filter(user1 -> !user1.getId().equals(user.getId()))
                .toList()).orElseGet(List::of);
    }

    /**
     * Tells the other members' clients that shared household data (e.g. categories) changed, once the current
     * transaction is committed so they reload the new state. Only sent once per transaction.
     * It uses the householdUpdate message type as clients fail to parse types they don't know.
     */
    public void notifyOtherMembersAfterCommit(User user) {
        sendMessageToOtherUsers(getCurrentHousehold(user).orElse(null), user);
    }

    public void sendMessageToOtherUsers(Household hs, User currentUser) {
        List<String> recipients = getHouseholdOtherMembers(Optional.ofNullable(hs), currentUser).stream()
                .map(member -> member.getId().toString())
                .toList();
        AfterCommitMessages.sendToUsers(recipients, new HouseholdWebsocketUpdate());
    }

}
