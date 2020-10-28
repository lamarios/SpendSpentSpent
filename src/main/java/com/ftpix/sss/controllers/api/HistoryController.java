package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.CategoryOverall;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.HistoryService;
import com.ftpix.sss.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/API/History")
public class HistoryController {
    private final UserService userService;

    private final HistoryService historyService;


    @Autowired
    public HistoryController(UserService userService, HistoryService historyService) {
        this.userService = userService;
        this.historyService = historyService;
    }

    @GetMapping("/CurrentYear")
    public List<CategoryOverall> yearly() throws Exception {
        final User user = userService.getCurrentUser();
        return historyService.yearly(user);
    }


    @GetMapping("/CurrentMonth")
    public List<CategoryOverall> monthly() throws Exception {
        final User user = userService.getCurrentUser();
        return historyService.monthly(user);
    }


    /**
     * Get the sum of expenses by year for the past :count years for :Category
     *
     * @param categoryId the category to get expenses from
     * @param count      the number of year from now to :count month in the past
     * @return
     * @throws SQLException
     */
    @GetMapping(value = "/Yearly/{category}/{count}")
    public List<Map<String, Object>> getYearlyHistory(@PathVariable("category") long categoryId, @PathVariable("count") int count) throws Exception {
        final User user = userService.getCurrentUser();
        return historyService.getYearlyHistory(categoryId, count, user);
    }

    /**
     * Gets the sum of expenses by month for the past :count month for :category
     *
     * @param categoryId the id of the category to get expenses from
     * @param count      the number of month from now to the :count months in the past
     * @return
     * @throws SQLException
     */
    @GetMapping("/Monthly/{category}/{count}")
    public List<Map<String, Object>> getMonthlyHistory(@PathVariable("category") long categoryId, @PathVariable("count") int count) throws Exception {
        final User user = userService.getCurrentUser();
        return historyService.getMonthlyHistory(categoryId, count, user);
    }
}
