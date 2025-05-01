package com.ftpix.sss.controllers.api;

import com.ftpix.sss.App;
import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.CategoryService;
import org.junit.Ignore;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

@Import(TestConfig.class)
public class CategoryControllerTest extends TestContainerTest {


    @Autowired
    private CategoryService categoryService;

    @Autowired
    private User currentUser;


    //TODO: when new icons are ready
    @Ignore
    @Test
    public void testCreateUpdateDeleteCategory() throws Exception {

        //count is for the created categories
        int count = categoryService.getAll(currentUser).size();
        // count of available categories from all the available icons
        long available = countAvailableCategories();


        Category cat = categoryService.create("spotify", currentUser);

        int newCount = categoryService.getAll(currentUser).size();
        long newAvailable = countAvailableCategories();

        assertEquals("spotify", cat.getIcon());
        assertEquals(count + 1, newCount);
        assertEquals(available - 1, newAvailable);

        categoryService.update(cat.getId(), "gas", 0, currentUser);
        cat = categoryService.get(cat.getId(), currentUser);

        assertEquals("gas", cat.getIcon());


        categoryService.delete(cat.getId(), currentUser);
        newCount = categoryService.getAll(currentUser).size();
        newAvailable = countAvailableCategories();

        assertEquals(count, newCount);
        assertEquals(available, newAvailable);
    }

    private long countAvailableCategories() throws Exception {
        return categoryService.getAvailable(currentUser).values().stream().mapToInt(List::size).sum();
    }


    //    @Test(expected = Exception.class)
    @Test
    @Ignore
    public void createNonExistentCategory() throws Exception {
        Assertions.assertThrows(Exception.class, () -> categoryService.create("icon-that-does-not-exist", currentUser));
    }

    //    @Test(expected = Exception.class)
    @Test
    @Ignore
    public void updateNonExistentCategory() throws Exception {
        Assertions.assertThrows(Exception.class, () -> {
            Category result = categoryService.update(423423, "furniture", 0, currentUser);
        });
    }


    //TODO: to do when all the new icons are ready
    @Test
    @Disabled
    public void testCategorySearch() throws Exception {
        Map<String, Object> search = categoryService.searchAvailableIcon("sou", currentUser);

        List<String> results = (List<String>) search.get("results");
        assertEquals("There should be 7 categories", 7, results.size());

        //if i add one of the categories to my collections, then it should only be left 6 from the results
        categoryService.create(results.get(0), currentUser);
        search = categoryService.searchAvailableIcon("sou", currentUser);
        results = (List<String>) search.get("results");
        assertEquals("There should be 6 categories", 6, results.size());


        //The same thing should work with different case
        search = categoryService.searchAvailableIcon("fiLe", currentUser);
        results = (List<String>) search.get("results");
        assertEquals("There should be 7 categories", 5, results.size());

        results = (List<String>) search.get("results");
        //if i add one of the categories to my collections, then it should only be left 6 from the results
        categoryService.create(results.get(0), currentUser);

        search = categoryService.searchAvailableIcon("fIle", currentUser);

        results = (List<String>) search.get("results");
        assertEquals("There should be 6 categories", 4, results.size());
    }

}
