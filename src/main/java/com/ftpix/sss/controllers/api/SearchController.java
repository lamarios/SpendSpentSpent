package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.DailyExpense;
import com.ftpix.sss.models.SearchParameters;
import com.ftpix.sss.services.SearchService;
import com.ftpix.sss.services.UserService;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.Map;

@RestController
@RequestMapping("/API/Search")
@Api(tags = "Search")
public class SearchController {

    private final SearchService searchService;
    private final UserService userService;

    @Autowired
    public SearchController(SearchService searchService, UserService userService) {
        this.searchService = searchService;
        this.userService = userService;
    }


    @GetMapping
    public SearchParameters getSearchParameters() throws SQLException {
        return this.searchService.getSearchParameters(userService.getCurrentUser());
    }

    @PostMapping
    public Map<String, DailyExpense> search(@RequestBody SearchParameters parameters) throws SQLException {
        return this.searchService.search(userService.getCurrentUser(), parameters);
    }

}
