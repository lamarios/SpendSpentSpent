package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.Household;
import com.ftpix.sss.models.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@Import(TestConfig.class)
public class HouseholdServiceTest extends TestContainerTest {

    @Autowired
    private User currentUser;

    @Autowired
    private UserDao userDao;

    @Autowired
    private HouseholdService householdService;

    @Test
    public void testHouseholdFlow() {
        // create a household
        var hs = householdService.createHousehold(currentUser);
        // verify that iam in my own household as an admin
        assertNotNull(hs.getId());
        assertEquals(1, hs.getMembers().size());
        assertEquals(currentUser.getId(), hs.getMembers().get(0).getUser().getId());

        hs = householdService.getCurrentHousehold(currentUser).get();
        assertNotNull(hs.getId());
        assertEquals(1, hs.getMembers().size());
        assertEquals(currentUser.getId(), hs.getMembers().get(0).getUser().getId());

        // create a new user
        User invitee = new User();
        invitee.setEmail("invitee@test.com");
        invitee.setLastName("test");
        invitee.setFirstName("aaaa");

        userDao.insert(invitee);


        // invite the new usr to my household
        householdService.inviteUser(currentUser, invitee.getEmail());

        var invitations = householdService.getInvitations(invitee);
        assertEquals(1, invitations.size());
        assertEquals(hs.getId(), invitations.get(0).getHousehold().getId());

        // new users accepts invitation
        Optional<Household> newHousehold = householdService.acceptInvitation(invitee, hs.getId());
        assertTrue(newHousehold.isPresent());
        assertEquals(hs.getId(), newHousehold.get().getId());
        hs = newHousehold.get();
        assertEquals(2, hs.getMembers().size());

        // invitee shouldn't have anymore invitations
        invitations = householdService.getInvitations(invitee);
        assertEquals(0, invitations.size());

        // user leaves the household
        householdService.leaveHousehold(invitee);

        var inviteeHs = householdService.getCurrentHousehold(invitee);
        assertTrue(inviteeHs.isEmpty());

        hs = householdService.getCurrentHousehold(currentUser).get();
        assertEquals(1, hs.getMembers().size());

        // reinvite

        householdService.inviteUser(currentUser, invitee.getEmail());
        //re-accept
        householdService.acceptInvitation(invitee, hs.getId());
        // set user as admin
        householdService.setAdmin(currentUser, invitee, true);

        var membership = householdService.getCurrentHousehold(invitee)
                .flatMap(household -> household.getMembers()
                        .stream()
                        .filter(member -> member.getUser().getId().equals(invitee.getId()))
                        .findFirst())
                .get();
        assertTrue(membership.isAdmin());

        // set user as admin
        householdService.setAdmin(currentUser, invitee, false);
        membership = householdService.getCurrentHousehold(invitee)
                .flatMap(household -> household.getMembers()
                        .stream()
                        .filter(member -> member.getUser().getId().equals(invitee.getId()))
                        .findFirst())
                .get();

        assertFalse(membership.isAdmin());


        //remove user from household

        // user updates his color


    }

}
