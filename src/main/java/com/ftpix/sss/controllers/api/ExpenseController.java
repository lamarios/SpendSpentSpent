package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.DailyExpense;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.HistoryService;
import com.ftpix.sss.services.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/API/Expense")
@Api(tags = {"Expenses"})
public class ExpenseController {
    public static final String DATE = "date";
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final UserService userService;
    private final ExpenseService expenseService;
    private final HistoryService historyService;

    @Autowired
    public ExpenseController(UserService userService, ExpenseService expenseService, HistoryService historyService) {
        this.userService = userService;
        this.expenseService = expenseService;
        this.historyService = historyService;
    }

    /**
     * Gets all expenses
     *
     * @return the list of expenses
     * @throws SQLException
     */
    @GetMapping
    public List<Expense> getAll() throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.getAll(currentUser);
    }


    /**
     * GEts a single Expense
     *
     * @param id the id of the expense to get
     * @return the Expense
     * @throws SQLException
     */
    @GetMapping(value = "/ById/{id}")
    public Expense get(@PathVariable("id") long id) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.get(id, currentUser);
    }

    /**
     * Gets the expenses in dending on dates given as parameter
     *
     * @param month yyyy-mm if only requesting for a specific month
     * @return
     * @throws SQLException
     * @throws ParseException
     */
    @GetMapping(value = "/ByDay")
    @ApiOperation("Gets the expenses of a given month day by day")
    public Map<String, DailyExpense> getByDay(@ApiParam("Given month, format yyyy-mm ex: 2020-03") @RequestParam String month) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.getByDay(month, currentUser);
    }


    /**
     * Get the list of months where expenses are available
     *
     * @return
     */
    @GetMapping("/GetMonths")
    public List<String> getMonths() throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.getMonths(currentUser);
    }


    /**
     * create an Expense
     *
     * @return the expense
     * @throws SQLException
     */
    @PostMapping
    public Expense create(@RequestBody Expense expense) throws Exception {
        final User currentUser = userService.getCurrentUser();
        Expense expense1 = expenseService.create(expense, currentUser);

        historyService.cacheForExpense(expense1);
        return expense1;
    }

    /**
     * Deletes an expense by its ID
     *
     * @param id the id of the expense to delete
     * @return true if it went well
     * @throws SQLException
     */
    @DeleteMapping("/{id}")
    public boolean delete(@PathVariable("id") long id) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.delete(id, currentUser);

    }
}
