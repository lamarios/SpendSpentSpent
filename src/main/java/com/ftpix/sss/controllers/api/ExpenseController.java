package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.UserService;
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
public class ExpenseController {
    public static final String DATE = "date";
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final UserService userService;
    private final ExpenseService expenseService;

    @Autowired
    public ExpenseController(UserService userService, ExpenseService expenseService) {
        this.userService = userService;
        this.expenseService = expenseService;
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
     * @param from  yyy-mm-dd
     * @param to    yyyy-mm-dd
     * @param month yyyy-mm if only requesting for a specific month
     * @return
     * @throws SQLException
     * @throws ParseException
     */
    @GetMapping(value = "/ByDay")
    public Map<String, Map<String, Object>> getByDay(@RequestParam(required = false) String from, @RequestParam(required = false) String to, @RequestParam(required = false) String month) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.getByDay(from, to, month, currentUser);
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
        return expenseService.create(expense, currentUser);
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
