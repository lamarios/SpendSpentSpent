package com.ftpix.sss.mcp;

import com.ftpix.sss.mcp.mcpmodels.McpCategory;
import com.ftpix.sss.mcp.mcpmodels.McpExpense;
import com.ftpix.sss.mcp.mcpmodels.McpRecurringExpense;
import com.ftpix.sss.models.*;
import com.ftpix.sss.services.*;
import java.sql.SQLException;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MCPTools {

  static final LocalTime START_OF_DAY = LocalTime.of(0, 0, 0);
  static final LocalTime END_OF_DAY = LocalTime.of(23, 59, 59);
  private static final String ACCEPTED_DATE_FORMATS =
      "yyyy-MM-dd, yyyy-MM-dd'T'HH:mm:ss[.SSS] or yyyy-MM-dd HH:mm:ss[.SSS]";

  private final CategoryService categoryService;
  private final UserService userService;
  private final ExpenseService expenseService;
  private final SearchService searchService;
  private final ZoneId zoneId;
  private final RecurringExpenseService recurringExpenseService;
  private final DateTimeFormatter sdf = DateTimeFormatter.ofPattern("yyyy-MM-dd");

  @Autowired
  public MCPTools(
      CategoryService categoryService,
      UserService userService,
      ExpenseService expenseService,
      SearchService searchService,
      ZoneId zoneId,
      RecurringExpenseService recurringExpenseService) {
    this.categoryService = categoryService;
    this.userService = userService;
    this.expenseService = expenseService;
    this.searchService = searchService;
    this.zoneId = zoneId;
    this.recurringExpenseService = recurringExpenseService;
  }

  @Tool(name = "get_categories", description = "Get all user's expense categories")
  public List<McpCategory> getCategories() throws SQLException {
    return categoryService.getAll(userService.getCurrentUser()).stream()
        .map(
            category -> {
              NewCategoryIcon newCategoryIcon = NewCategoryIcon.valueOf(category.getIcon());
              return new McpCategory(
                  category.getIcon(),
                  newCategoryIcon.getCategory(),
                  newCategoryIcon.getSearchTerms());
            })
        .toList();
  }

  @Tool(name = "search_expenses", description = "Search user's expenses")
  public List<McpExpense> searchExpenses(
      @ToolParam(
              description =
                  "lower inclusive date boundary for expense search. Accepted formats: yyyy-MM-dd,"
                      + " yyyy-MM-dd'T'HH:mm:ss[.SSS] or yyyy-MM-dd HH:mm:ss[.SSS]. If no time is"
                      + " given, 00:00:00 is used")
          String fromDate,
      @ToolParam(
              description =
                  "upper inclusive date boundary for expense search. Accepted formats: yyyy-MM-dd,"
                      + " yyyy-MM-dd'T'HH:mm:ss[.SSS] or yyyy-MM-dd HH:mm:ss[.SSS]. If no time is"
                      + " given, 23:59:59 is used")
          String toDate,
      @ToolParam(
              required = false,
              description = "List of categories to filter filter the expenses on")
          List<String> categories,
      @ToolParam(
              required = false,
              description =
                  "Zone the date boundaries are interpreted in, e.g. Europe/Paris or Asia/Kuala_Lumpur."
                      + " Defaults to the configured server timezone when not given")
          String timezone)
      throws SQLException {
    ZoneId zone = resolveZone(timezone, zoneId);
    var fromTime = parseToEpochMillis(fromDate, zone, START_OF_DAY);
    var toTime = parseToEpochMillis(toDate, zone, END_OF_DAY);

    User currentMcpUser = userService.getCurrentUser();
    var categoryFilter =
        categoryService.getAll(currentMcpUser).stream()
            .filter(
                cat ->
                    categories == null
                        || categories.isEmpty()
                        || categories.contains(cat.getIcon()))
            .toList();
    SearchParameters params =
        new SearchParameters(categoryFilter, 0, Integer.MAX_VALUE, fromTime, toTime, null);

    return searchService.search(currentMcpUser, params, zone).values().stream()
        .flatMap(dailyExpense -> dailyExpense.getExpenses().stream())
        .map(
            e ->
                new McpExpense(
                    e.getAmount(), e.getTimestamp(), e.getCategory().getIcon(), e.getNote()))
        .toList();
  }

  /**
   * Parses a date with an optional time of day into epoch milliseconds in the given zone.
   *
   * <p>Accepted formats: {@code yyyy-MM-dd}, {@code yyyy-MM-dd'T'HH:mm:ss[.SSS]} and {@code
   * yyyy-MM-dd HH:mm:ss[.SSS]}. When only a date is given, {@code defaultTime} is used.
   *
   * @throws IllegalArgumentException if the value doesn't match any accepted format
   */
  static long parseToEpochMillis(String value, ZoneId zone, LocalTime defaultTime) {
    if (value == null || value.isBlank()) {
      throw new IllegalArgumentException("Missing date, expected one of: " + ACCEPTED_DATE_FORMATS);
    }

    String trimmed = value.trim();
    LocalDateTime dateTime;
    try {
      if (trimmed.length() == 10) {
        dateTime = LocalDate.parse(trimmed).atTime(defaultTime);
      } else {
        if (trimmed.length() > 10 && trimmed.charAt(10) == ' ') {
          trimmed = trimmed.substring(0, 10) + 'T' + trimmed.substring(11);
        }
        dateTime = LocalDateTime.parse(trimmed);
      }
    } catch (DateTimeParseException e) {
      throw new IllegalArgumentException(
          "Invalid date '" + value + "', expected one of: " + ACCEPTED_DATE_FORMATS, e);
    }

    return dateTime.atZone(zone).toInstant().toEpochMilli();
  }

  /**
   * Resolves the zone an MCP call should interpret its dates in, falling back to the configured
   * server zone when no zone is supplied.
   *
   * @throws IllegalArgumentException if the supplied value isn't a valid zone id
   */
  static ZoneId resolveZone(String timezone, ZoneId defaultZone) {
    if (timezone == null || timezone.isBlank()) {
      return defaultZone;
    }
    try {
      return ZoneId.of(timezone.trim());
    } catch (DateTimeException e) {
      throw new IllegalArgumentException(
          "Invalid timezone '"
              + timezone
              + "', expected a zone id such as Europe/Paris or Asia/Kuala_Lumpur",
          e);
    }
  }

  @Tool(name = "add_expense", description = "Add an expense for the user")
  public boolean addExpense(
      @ToolParam(description = "Category to which the expense belongs to") String category,
      @ToolParam(description = "the expense amount") double amount,
      @ToolParam(required = false, description = "Note or description related to the expense")
          String note)
      throws Exception {
    User currentMcpUser = userService.getCurrentUser();
    var categories =
        categoryService.getAll(currentMcpUser).stream()
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
    return recurringExpenseService.get(userService.getCurrentUser()).stream()
        .map(
            re ->
                new McpRecurringExpense(
                    re.getCategory().getIcon(),
                    re.getAmount(),
                    re.getName(),
                    re.getLastOccurrence().format(sdf),
                    re.getNextOccurrence().format(sdf)))
        .toList();
  }
}
