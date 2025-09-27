package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.*;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.UserService;
import com.ftpix.sss.utils.CategoryPredictor;
import com.ftpix.sss.utils.DateUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.text.ParseException;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import static com.ftpix.sss.Constants.TIMEZONE_HEADER;

@RestController
@RequestMapping("/API/Expense")
@Api(tags = {"Expenses"})
public class ExpenseController {
    public static final String DATE = "date";
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final UserService userService;
    private final ExpenseService expenseService;
    private final ZoneId zoneId;

    @Autowired
    public ExpenseController(UserService userService, ExpenseService expenseService, ZoneId zoneId) {
        this.userService = userService;
        this.expenseService = expenseService;
        this.zoneId = zoneId;
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
    public Map<String, DailyExpense> getByDay(@ApiParam("Given month, format yyyy-mm ex: 2020-03") @RequestParam String month,  @RequestHeader(value = TIMEZONE_HEADER, defaultValue = "") String zoneId) throws Exception {
        final User currentUser = userService.getCurrentUser();

        Map<String, DailyExpense> byDay = expenseService.getByDay(month, currentUser, DateUtils.parseZoneId(zoneId, this.zoneId));
        return byDay;
    }


    /**
     * Get the list of months where expenses are available
     *
     * @return
     */
    @GetMapping("/GetMonths")
    public List<String> getMonths(@RequestHeader(value = TIMEZONE_HEADER, defaultValue = "") String zone) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.getMonths(currentUser, DateUtils.parseZoneId(zone, zoneId));
    }


    /**
     * create an Expense
     *
     * @return the expense
     * @throws SQLException
     */
    @PostMapping
    public Expense createOrUpdate(@RequestBody Expense expense) throws Exception {
        final User currentUser = userService.getCurrentUser();
        if (expense.getId() != null) {
            return expenseService.update(expense, currentUser);
        } else {
            return expenseService.create(expense, currentUser);
        }
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
        Expense expense = get(id);
        boolean delete = expenseService.delete(id, currentUser);
        return delete;

    }

    @PostMapping("/suggest-notes")
    public Map<String, Long> suggestNotes(@RequestBody Expense expense) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.suggestNotes(currentUser, expense);
    }

    @PostMapping("/notes-autocomplete")
    public Map<String, Long> noteAutoComplete(@RequestBody String text) throws SQLException {
        if (text.isBlank()) {
            return new HashMap<>();
        }

        final User currentUser = userService.getCurrentUser();
        return expenseService.autoCompleteNote(currentUser, text);
    }


    @GetMapping("/limits")
    public ExpenseLimits getExpenseLimits() throws Exception {
        final User currentUser = userService.getCurrentUser();
        return expenseService.getLimits(currentUser);
    }

    @GetMapping("/diff/{current-day}")
    public double getDiffWithPreviousPeriod(@PathVariable("current-day") String currentDay, @RequestParam(value = "include-recurring", defaultValue = "true") boolean includeRecurring, @DefaultValue("") @RequestHeader(TIMEZONE_HEADER) String timeZone) throws SQLException {

        var currentUser = userService.getCurrentUser();
        return expenseService.diffWithPreviousPeriod(currentUser, currentDay, includeRecurring, DateUtils.parseZoneId(timeZone, this.zoneId));
    }

    @GetMapping("/suggest")
    public List<CategoryPredictor.CategoryPrediction> suggestCategory( @RequestHeader(value = TIMEZONE_HEADER, defaultValue = "") String timeZone, @RequestParam(value = "latitude", required = false) Double latitude, @RequestParam(value = "longitude", required = false) Double longitude) throws SQLException, ExecutionException, InterruptedException {
        var currentUser = userService.getCurrentUser();
        return expenseService.getExpenseCategorySuggestion(currentUser, DateUtils.parseZoneId(timeZone, zoneId), latitude, longitude);
    }

}
