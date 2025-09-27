package com.ftpix.sss.controllers.api;

import com.ftpix.sss.Constants;
import com.ftpix.sss.models.DailyExpense;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.SearchParameters;
import com.ftpix.sss.services.SearchService;
import com.ftpix.sss.services.UserService;
import com.ftpix.sss.utils.DateUtils;
import io.swagger.annotations.Api;
import jakarta.servlet.http.HttpServletResponse;
import net.bytebuddy.implementation.bind.annotation.Default;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Comparator;
import java.util.Map;
import java.util.UUID;

import static com.ftpix.sss.Constants.TIMEZONE_HEADER;

@RestController
@RequestMapping("/API/Search")
@Api(tags = "Search")
public class SearchController {

    private final SearchService searchService;
    private final UserService userService;
    private final ZoneId zoneId;

    @Autowired
    public SearchController(SearchService searchService, UserService userService, ZoneId zoneId) {
        this.searchService = searchService;
        this.userService = userService;
        this.zoneId = zoneId;
    }


    @GetMapping
    public SearchParameters getSearchParameters(@RequestParam(value = "category_id", required = false) Long categoryId) throws SQLException {
        return this.searchService.getSearchParameters(userService.getCurrentUser(), categoryId);
    }

    @PostMapping
    public Map<String, DailyExpense> search(@RequestBody SearchParameters parameters, @RequestHeader(value = TIMEZONE_HEADER, defaultValue = "") String timezone) throws SQLException {
        return this.searchService.search(userService.getCurrentUser(), parameters, DateUtils.parseZoneId(timezone, zoneId));
    }

    @PostMapping("/csv")
    public void searchAsCsv(@RequestBody SearchParameters parameters, HttpServletResponse response, @RequestHeader(value = TIMEZONE_HEADER, defaultValue = "") String timezone) throws SQLException, IOException {
        var zoneId = DateUtils.parseZoneId(timezone, this.zoneId);

        var results = this.searchService.search(userService.getCurrentUser(), parameters, zoneId)
                .values()
                .stream()
                .flatMap(dailyExpense -> dailyExpense.getExpenses().stream())
                .sorted(Comparator.comparingLong(Expense::getTimestamp))
                .toList();


        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + UUID.randomUUID() + ".csv\"");

        try (PrintWriter writer = response.getWriter()) {
            writer.println("date,category,amount,type,latitude,longitude,note,user");

            results.forEach(expense -> {
                Instant t = Instant.ofEpochMilli(expense.getTimestamp());
                var date = ZonedDateTime.ofInstant(t, zoneId);

                var type = expense.getType() == 1 ? "normal" : "recurring";
                var latitude = expense.getLatitude() == 0 ? "" : Double.toString(expense.getLatitude());
                var longitude = expense.getLongitude() == 0 ? "" : Double.toString(expense.getLongitude());

                String str = "%s,%s,%s,%s,%s,%s,%s,%s".formatted(Constants.dateFormatter.format(date), expense.getCategory()
                        .getIcon(), Double.toString(expense.getAmount()), type, latitude, longitude, escapeCsv(expense.getNote()), expense.getCategory().getUser().getEmail());
                writer.println(str);
            });

        }
    }

    private String escapeCsv(String input) {
        if (input == null) {
            return "";
        }
        if (input.contains(",") || input.contains("\"") || input.contains("\n") || input.contains("\r")) {
            return "\"" + input.replace("\"", "\"\"") + "\"";
        }
        return input;
    }
}
