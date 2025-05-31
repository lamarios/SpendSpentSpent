package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.SearchParameters;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.CategoryService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@Import(TestConfig.class)
public class SearchControllerTest extends TestContainerTest {
    @Autowired
    private ExpenseController expenseController;

    @Autowired
    private CategoryController categoryController;

    @Autowired
    private SearchController searchController;

    @Test
    public void testSearch() throws Exception {
        var categories = categoryController.getAll();

        var cat1 = categories.get(0);
        var cat2 = categories.get(1);

        Expense e1 = new Expense();
        e1.setCategory(cat1);
        e1.setAmount(10);
        e1.setNote("my note");
        e1 = expenseController.create(e1);


        Expense e2 = new Expense();
        e2.setCategory(cat2);
        e2.setAmount(100);
        e2.setNote("my second note");
        e2 = expenseController.create(e2);

        SearchParameters params = new SearchParameters(new ArrayList<>(), 9, 11, null, null, null);

        var results = search(params);


        assertEquals(1, results.size());
        assertEquals(e1.getId(), results.get(0).getId());

        // searching by note we purposely search for shorter word to check if is using "LIKE"
        results = search(new SearchParameters(new ArrayList<>(), 0, 9999999, null, null, "y no"));

        assertEquals(1, results.size());
        assertEquals(e1.getId(), results.get(0).getId());

        // searching by category
        results = search(new SearchParameters(List.of(cat1), 0, 9999999, null, null, null));
        assertEquals(1, results.size());
        assertEquals(e1.getId(), results.get(0).getId());

        // search by amount
        results = search(new SearchParameters(null, 0, 11, null, null, null));
        assertEquals(1, results.size());
        assertEquals(e1.getId(), results.get(0).getId());

        // searching by amount and category
        results = search(new SearchParameters(List.of(cat2), 23, 121, null, null, null));

        assertEquals(1, results.size());
        assertEquals(e2.getId(), results.get(0).getId());


        // searching by note we purposely search for shorter word to check if is using "LIKE"
        results = search(new SearchParameters(null, 0, 9999999, null, null, "no"));

        assertEquals(2, results.size());
        Expense finalE1 = e1;
        Expense finalE2 = e2;
        assertTrue(results.stream().anyMatch(e -> e.getId().equals(
                finalE1.getId())));
        assertTrue(results.stream().anyMatch(e -> e.getId().equals(
                finalE2.getId())));

    }

    private List<Expense> search(SearchParameters params) throws SQLException {
        var results = searchController.search(params);

        // firstExpense
        return results.get(results.keySet().stream().findFirst().get()).getExpenses();
    }
}
