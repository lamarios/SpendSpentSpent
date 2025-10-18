package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.RecurringExpenseService;
import com.ftpix.sss.services.UserService;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/API/RecurringExpense")
@Tag(name = "Recurring expenses")
@SecurityRequirement(name = "bearerAuth")
public class RecurringExpenseController {
    private final static String FIELD_AMOUNT = "amount", FIELD_CATEGORY = "category", FIELD_ID = "id", FIELD_INCOME = "income", FIELD_LAST_OCCURRENCE = "lastOccurrence", FIELD_NAME = "name",
            FIELD_NEXT_OCCURRENCE = "nextOccurrence", FIELD_TYPE = "type", FIELD_WHEN = "typeParam";


    private final RecurringExpenseService recurringExpenseService;
    private final UserService userService;

    @Autowired
    public RecurringExpenseController(RecurringExpenseService recurringExpenseService, UserService userService) {
        this.recurringExpenseService = recurringExpenseService;
        this.userService = userService;
    }


    /**
     * Creates a recurring expense
     *
     * @return
     * @throws SQLException
     */
    @PostMapping
    public RecurringExpense create(@RequestBody RecurringExpense expense) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return recurringExpenseService.create(expense, currentUser);
    }

    /**
     * GEts all the expenses
     *
     * @return
     * @throws SQLException
     */
    @GetMapping
    public List<RecurringExpense> get() throws Exception {
        final User user = userService.getCurrentUser();
        return recurringExpenseService.get(user);
    }

    @PostMapping("/{id}")
    public boolean updateExpense(@RequestBody RecurringExpense expense) throws Exception {
        final User user = userService.getCurrentUser();
        return recurringExpenseService.update(expense, user);
    }


    /**
     * Gets a single recurring expense
     *
     * @param id the id of the expense to get
     * @return the expense
     * @throws SQLException
     */
    @GetMapping(value = "/{id}")
    public RecurringExpense getId(@PathVariable("id") long id) throws Exception {
        final User user = userService.getCurrentUser();
        return recurringExpenseService.getId(id, user);
    }

    /**
     * Delete a single recurring expense
     *
     * @param id
     * @return
     * @throws SQLException
     */
    @DeleteMapping(value = "/{id}")
    public boolean delete(@PathVariable("id") long id) throws Exception {
        final User user = userService.getCurrentUser();
        return recurringExpenseService.delete(id, user);
    }

}
