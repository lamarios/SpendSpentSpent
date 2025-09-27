package com.ftpix.sss.services;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.sql.SQLException;
import java.time.ZoneId;
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
    @Autowired
    private User user;

    @Autowired
    private CategoryService categoryService;
    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private HistoryService historyService;

    @Test
    public void testHouseholdFlow() throws SQLException {
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
        Optional<Household> newHousehold = householdService.acceptInvitation(invitee, invitations.get(0).getId());
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
        householdService.acceptInvitation(invitee, hs);
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
        householdService.removeMember(currentUser, invitee);

        hs = householdService.getCurrentHousehold(user).get();

        assertEquals(1, hs.getMembers().size());
        assertEquals(currentUser.getId(), hs.getMembers().get(0).getUser().getId());

        // user updates his color
        householdService.setColor(currentUser, HouseholdColor.cyan);

        hs = householdService.getCurrentHousehold(currentUser).get();
        assertEquals(HouseholdColor.cyan, hs.getMembers().get(0).getColor());
    }

    @Test
    public void testExpenseWithinHousehold() throws Exception {

        // create a new user
        User user = new User();
        user.setEmail("testuseraadfsf@test.com");
        user.setLastName("test");
        user.setFirstName("aaaa");
        userDao.insert(user);


        // create a new user
        User invitee = new User();
        invitee.setEmail("invitee2@test.com");
        invitee.setLastName("test");
        invitee.setFirstName("aaaa");

        userDao.insert(invitee);


        var userCat = categoryService.create("food", user);
        var inviteeCat = categoryService.create("gas", invitee);

        var categories = categoryService.getAll(user);

        // user categories should still return 1, only when getting expenses we include the ones from the household
        assertEquals(1, categories.size());

        var exp1 = new Expense();
        exp1.setCategory(userCat);
        exp1.setAmount(10);
        expenseService.create(exp1, user);

        var exp2 = new Expense();
        exp2.setCategory(inviteeCat);
        exp2.setAmount(30);
        expenseService.create(exp2, invitee);


        // we check before we add the users to the household to see if we broke anything
        var months = expenseService.getMonths(user, ZoneId.systemDefault());
        var expenses = expenseService.getByDay(months.get(0), user, ZoneId.systemDefault());

        assertEquals(1, expenses.size());
        DailyExpense dayExpenses = expenses.get(expenses.keySet().stream().findFirst().get());
        assertEquals(1, dayExpenses.getExpenses().size());
        assertEquals(10, dayExpenses.getTotal());


        var yearly = historyService.yearly(user);
        assertEquals(2, yearly.size());
        assertEquals(10, yearly.get(0).getAmount());
        assertEquals(10, yearly.get(1).getAmount());

        var monthly = historyService.yearly(user);
        assertEquals(2, monthly.size());
        assertEquals(10, monthly.get(0).getAmount());
        assertEquals(10, monthly.get(1).getAmount());


        var catMonthly = historyService.getMonthlyHistory(userCat.getId(), 1, user);
        assertEquals(10d, catMonthly.get(0).get("amount"));

        // now if i try the category of the other user i should just see 0 as I don't have access
        catMonthly = historyService.getMonthlyHistory(inviteeCat.getId(), 1, user);
        assertEquals(0, catMonthly.get(0).get("amount"));

        var catYearly = historyService.getYearlyHistory(userCat.getId(), 1, user);
        assertEquals(10d, catYearly.get(0).get("amount"));

        // now if i try the category of the other user i should just see 0 as I don't have access
        catYearly = historyService.getYearlyHistory(inviteeCat.getId(), 1, user);
        assertEquals(0, catYearly.get(0).get("amount"));

        // setting up the household
        var hs = householdService.createHousehold(user);
        // invite the new usr to my household
        householdService.inviteUser(user, invitee.getEmail());
        householdService.acceptInvitation(invitee, hs);
        // now if i get todays expenses, i should have a total of 10 + 30 = 40
        months = expenseService.getMonths(user, ZoneId.systemDefault());
        expenses = expenseService.getByDay(months.get(0), user, ZoneId.systemDefault());

        assertEquals(1, expenses.size());
        dayExpenses = expenses.get(expenses.keySet().stream().findFirst().get());
        assertEquals(2, dayExpenses.getExpenses().size());
        assertEquals(40, dayExpenses.getTotal());


        // we should have a mix of categories from all the users
        yearly = historyService.yearly(user);
        assertEquals(3, yearly.size());
        assertEquals(40, yearly.get(0).getAmount());
        assertEquals(-1, yearly.get(0).getCategory().getId());
        assertEquals(30, yearly.get(1).getAmount());
        assertEquals(inviteeCat.getId(), yearly.get(1).getCategory().getId());
        assertEquals(invitee.getId(), yearly.get(1).getCategory().getUser().getId());
        assertEquals(10, yearly.get(2).getAmount());
        assertEquals(userCat.getId(), yearly.get(2).getCategory().getId());
        assertEquals(user.getId(), yearly.get(2).getCategory().getUser().getId());

        monthly = historyService.yearly(user);
        assertEquals(3, monthly.size());
        assertEquals(40, monthly.get(0).getAmount());
        assertEquals(-1, monthly.get(0).getCategory().getId());
        assertEquals(30, monthly.get(1).getAmount());
        assertEquals(inviteeCat.getId(), monthly.get(1).getCategory().getId());
        assertEquals(invitee.getId(), monthly.get(1).getCategory().getUser().getId());
        assertEquals(10, monthly.get(2).getAmount());
        assertEquals(userCat.getId(), monthly.get(2).getCategory().getId());
        assertEquals(user.getId(), monthly.get(2).getCategory().getUser().getId());


        catMonthly = historyService.getMonthlyHistory(userCat.getId(), 1, user);
        assertEquals(10d, catMonthly.get(0).get("amount"));

        // now if i try the category of the other user i should be able to see it properly
        catMonthly = historyService.getMonthlyHistory(inviteeCat.getId(), 1, user);
        assertEquals(30d, catMonthly.get(0).get("amount"));

        catYearly = historyService.getYearlyHistory(userCat.getId(), 1, user);
        assertEquals(10d, catYearly.get(0).get("amount"));

        // now if i try the category of the other user i should be able to see it properly
        catYearly = historyService.getYearlyHistory(inviteeCat.getId(), 1, user);
        assertEquals(30d, catYearly.get(0).get("amount"));
    }

}
