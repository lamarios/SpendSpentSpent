package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.Category;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import static com.ftpix.sss.PrepareDB.TOKEN;
import static com.ftpix.sss.PrepareDB.USER;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class CategoryControllerTest {
    private CategoryController controller = new CategoryController();

    @BeforeClass
    public static void prepare() throws SQLException, IOException {
        PrepareDB.prepareDB();
    }


    /**
     * Creating, Updating and deleting a category
     *
     * @throws SQLException
     */
    @Test
    public void testCreateUpdateDeleteCategory() throws Exception {

        //count is for the created categories
        int count = controller.getAll(TOKEN).size();
        // count of available categories from all the available icons
        long available = countAvailableCategories();


        Category cat = controller.create("icon-forest", USER, TOKEN);

        int newCount = controller.getAll(TOKEN).size();
        long newAvailable = countAvailableCategories();

        assertEquals("icon-forest", cat.getIcon());
        assertEquals(count + 1, newCount);
        assertEquals(available - 1, newAvailable);

        controller.update(cat.getId(), "icon-perforator", 0, TOKEN);
        cat = controller.get(cat.getId(), TOKEN);

        assertEquals("icon-perforator", cat.getIcon());


        controller.delete(cat.getId(), TOKEN);
        newCount = controller.getAll(TOKEN).size();
        newAvailable = countAvailableCategories();

        assertEquals(count, newCount);
        assertEquals(available, newAvailable);
    }

    private long countAvailableCategories() throws Exception {
        List<String> available = controller.getAvailable(TOKEN);
        return available.size();
    }


    @Test(expected = Exception.class)
    public void createNonExistentCategory() throws Exception {
        controller.create("icon-that-does-not-exist", USER, TOKEN);
    }

    @Test(expected = Exception.class)
    public void updateNonExistentCategory() throws Exception {
        boolean result = controller.update(423423, "icon-violin", 0, TOKEN);
        assertFalse(result);

        controller.update(1, "iconffsdfs", 0, TOKEN);

    }


    @Test
    public void testCategorySearch() throws Exception {
        Map<String, Object> search = controller.searchAvailableIcon("sou");

        List<String> results = (List<String>) search.get("results");
        assertEquals("There should be 7 categories", 7, results.size());

        //if i add one of the categories to my collections, then it should only be left 6 from the results
        controller.create(results.get(0), USER, TOKEN);
        search = controller.searchAvailableIcon("sou");
        results = (List<String>) search.get("results");
        assertEquals("There should be 6 categories", 6, results.size());


        //The same thing should work with different case
        search = controller.searchAvailableIcon("fiLe");
        results = (List<String>) search.get("results");
        assertEquals("There should be 7 categories", 5, results.size());

        results = (List<String>) search.get("results");
        //if i add one of the categories to my collections, then it should only be left 6 from the results
        controller.create(results.get(0), USER, TOKEN);

        search = controller.searchAvailableIcon("fIle");

        results = (List<String>) search.get("results");
        assertEquals("There should be 6 categories", 4, results.size());
    }

}
