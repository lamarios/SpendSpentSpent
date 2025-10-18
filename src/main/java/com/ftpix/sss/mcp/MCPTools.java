package com.ftpix.sss.mcp;

import com.ftpix.sss.mcp.mcpmodels.McpCategory;
import com.ftpix.sss.mcp.mcpmodels.McpExpense;
import com.ftpix.sss.mcp.mcpmodels.McpRecurringExpense;
import com.ftpix.sss.models.*;
import com.ftpix.sss.services.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
public class MCPTools {

    private final CategoryService categoryService;
    private final UserService userService;
    private final ExpenseService expenseService;
    private final SearchService searchService;
    private final ZoneId zoneId;
    private final RecurringExpenseService recurringExpenseService;
    private final DateTimeFormatter sdf = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Autowired
    public MCPTools(CategoryService categoryService, UserService userService, ExpenseService expenseService, SearchService searchService, ZoneId zoneId, RecurringExpenseService recurringExpenseService) {
        this.categoryService = categoryService;
        this.userService = userService;
        this.expenseService = expenseService;
        this.searchService = searchService;
        this.zoneId = zoneId;
        this.recurringExpenseService = recurringExpenseService;
    }


    @Tool(name = "get_categories", description = "Get all user's expense categories")
    public List<McpCategory> getCategories() throws SQLException {
        return categoryService.getAll(userService.getCurrentUser())
                .stream()
                .map(category -> {
                    NewCategoryIcon newCategoryIcon = NewCategoryIcon.valueOf(category.getIcon());
                    return new McpCategory(category.getIcon(), newCategoryIcon.getCategory(), newCategoryIcon
                            .getSearchTerms());
                })
                .toList();
    }

    @Tool(name = "search_expenses", description = "Search user's expenses")
    public List<McpExpense> searchExpenses(@ToolParam(description = "lower inclusive date boundary for expense search, date format yyyy-MM-dd") String fromDate,
                                           @ToolParam(description = "upper inclusive date boundary for expense search in, date format yyyy-MM-dd") String toDate,
                                           @ToolParam(required = false, description = "Category to which the expense belongs to") String category) throws SQLException {
        var fromTime = LocalDate.parse(fromDate).atTime(0, 0, 0).atZone(zoneId).toEpochSecond() * 1000;
        var toTime = LocalDate.parse(toDate).atTime(23, 59, 59).atZone(zoneId).toEpochSecond() * 1000;


        User currentMcpUser = userService.getCurrentUser();
        var categories = categoryService.getAll(currentMcpUser)
                .stream()
                .filter(cat -> category == null || cat.getIcon().equalsIgnoreCase(category))
                .toList();
        SearchParameters params = new SearchParameters(categories, 0, Integer.MAX_VALUE, fromTime, toTime, null);

        return searchService.search(currentMcpUser, params, zoneId)
                .values()
                .stream()
                .flatMap(dailyExpense -> dailyExpense.getExpenses().stream())
                .map(e -> new McpExpense(e.getAmount(), e.getTimestamp(), e.getCategory().getIcon(), e.getNote()))
                .toList()
                ;
    }

    @Tool(name = "add_expense", description = "Add an expense for the user")
    public boolean addExpense(@ToolParam(description = "Category to which the expense belongs to") String category,
                              @ToolParam(description = "the expense amount") double amount,
                              @ToolParam(required = false, description = "Note or description related to the expense") String note
    ) throws Exception {
        User currentMcpUser = userService.getCurrentUser();
        var categories = categoryService.getAll(currentMcpUser)
                .stream()
                .filter(cat -> category == null || cat.getIcon().equalsIgnoreCase(category))
                .toList();

        if (categories.isEmpty()) {
            throw new Exception("Category does not exist");
        }
        Expense expense = new Expense();
        expense.setCategory(categories.get(0));
        expense.setAmount(amount);
        expense.setTimeCreated(System.currentTimeMillis());
        expense.setNote(note);
        expense.setTimestamp(System.currentTimeMillis());
        expense.setIncome(false);
        expense.setType(Expense.TYPE_NORMAL);
        var newExpense = expenseService.create(expense, currentMcpUser);
        return newExpense != null;
    }

    @Tool(name = "get_recurring_expenses", description = "Gets the user's recurring expenses")
    public List<McpRecurringExpense> getRecurringExpenses() throws Exception {
        return recurringExpenseService.get(userService.getCurrentUser())
                .stream()
                .map(re -> new McpRecurringExpense(re.getCategory()
                        .getIcon(), re.getAmount(), re.getName(), re.getLastOccurrence()
                        .format(sdf), re.getNextOccurrence().format(sdf)))
                .toList();
    }
}
