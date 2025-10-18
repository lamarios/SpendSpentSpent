package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.Household;
import com.ftpix.sss.models.HouseholdColor;
import com.ftpix.sss.models.HouseholdMember;
import com.ftpix.sss.services.HouseholdService;
import com.ftpix.sss.services.UserService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/API/Household")
@Tag(name = "Household")
@SecurityRequirement(name = "bearerAuth")
public class HouseholdController {
    private final HouseholdService householdService;
    private final UserService userService;


    @Autowired
    public HouseholdController(HouseholdService householdService, UserService userService) {
        this.householdService = householdService;
        this.userService = userService;
    }

    @GetMapping
    public Household getHousehold() throws SQLException {
        return householdService.getCurrentHousehold(userService.getCurrentUser())
                .map(Household::withoutPendingInvitations)
                .orElse(null);
    }

    @PutMapping
    public Household createHousehold() throws SQLException {
        var user = userService.getCurrentUser();
        return householdService.createHousehold(user).withoutPendingInvitations();
    }

    @GetMapping("/invites/{email}")
    public void invite(@PathVariable("email") String email) throws SQLException {
        var user = userService.getCurrentUser();
        householdService.inviteUser(user, email);
    }

    @GetMapping("/invites/{id}/accept")
    public Household acceptInvitation(@PathVariable("id") String invitationId) throws SQLException {
        return householdService.acceptInvitation(userService.getCurrentUser(), UUID.fromString(invitationId))
                .map(Household::withoutPendingInvitations)
                .orElse(null);
    }

    @DeleteMapping("/invites/{id}/reject")
    public void rejectInvitation(@PathVariable("id") String invitationId) throws SQLException {
        householdService.rejectInvitation(userService.getCurrentUser(), UUID.fromString(invitationId));
    }

    @GetMapping("/invites")
    public List<HouseholdMember> getInvitations() throws SQLException {
        return householdService.getInvitations(userService.getCurrentUser());
    }

    @DeleteMapping("/leave")
    public boolean leaveHousehold() throws SQLException {
        return householdService.leaveHousehold(userService.getCurrentUser());
    }

    @DeleteMapping("/{userId}")
    public void removeUserFromHousehold(@PathVariable("userId") String userid) throws SQLException {
        householdService.removeMember(userService.getCurrentUser(), userService.getById(UUID.fromString(userid)));
    }

    @DeleteMapping
    public void deleteHousehold() throws SQLException {
        householdService.deleteHousehold(userService.getCurrentUser());
    }

    @PostMapping("/set-admin/{userId}")
    public void setAdmin(@PathVariable("userId") String userId, @RequestBody boolean isAdmin) throws SQLException {
        householdService.setAdmin(userService.getCurrentUser(), userService.getById(UUID.fromString(userId)), isAdmin);
    }

    @PostMapping("/set-color")
    public void setColor(@RequestBody HouseholdColor color) throws SQLException {
        householdService.setColor(userService.getCurrentUser(), color);
    }


}
