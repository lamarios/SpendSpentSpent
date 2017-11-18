package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.Category;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.sql.SQLException;
import java.util.List;
import java.util.TreeMap;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class CategoryControllerTest {
    private CategoryController controller = new CategoryController();

    @BeforeClass
    public static void prepare() throws SQLException {
        PrepareDB.prepareDB();
    }


    /**
     * Creating, Updating and deleting a category
     *
     * @throws SQLException
     */
    @Test
    public void testCreateUpdateDeleteCategory() throws SQLException {

        //count is for the created categories
        int count = controller.getAll().size();
        // count of available categories from all the available icons
        long available = countAvailableCategories();


        Category cat = controller.create("icon-forest", 0);

        int newCount = controller.getAll().size();
        long newAvailable = countAvailableCategories();

        assertEquals("icon-forest", cat.getIcon());
        assertEquals(count + 1, newCount);
        assertEquals(available - 1, newAvailable);

        controller.update(cat.getId(), "icon-destination", 0);
        cat = controller.get(cat.getId());

        assertEquals("icon-destination", cat.getIcon());


        controller.delete(cat.getId());
        newCount = controller.getAll().size();
        newAvailable = countAvailableCategories();

        assertEquals(count, newCount);
        assertEquals(available, newAvailable);
    }

    private long countAvailableCategories() throws SQLException {
        TreeMap<String, List<String>> available = controller.getAvailable();
        return available.values().stream().flatMap(l -> l.stream())
                .count();
    }


    @Test(expected = HaltException.class)
    public void createNonExistentCategory() throws SQLException {
        controller.create("icon-that-does-not-exist", 0);
    }

    @Test(expected = HaltException.class)
    public void updateNonExistentCategory() throws SQLException {
        boolean result = controller.update(423423, "icon-violin", 0);
        assertFalse(result);

        controller.update(1, "iconffsdfs", 0);

    }


    @Test
    public void testCategorySearch() throws SQLException {
        List<String> search = controller.searchAvailableIcon("sou");

        assertEquals("There should be 7 categories", 7, search.size());


        //if i add one of the categories to my collections, then it should only be left 6 from the results
        controller.create(search.get(0), 0);

        search = controller.searchAvailableIcon("sou");
        assertEquals("There should be 6 categories", 6, search.size());


        //The same thing should work with different case
        search = controller.searchAvailableIcon("hOme");

        assertEquals("There should be 7 categories", 2, search.size());


        //if i add one of the categories to my collections, then it should only be left 6 from the results
        controller.create(search.get(0), 0);

        search = controller.searchAvailableIcon("hOme");
        assertEquals("There should be 6 categories", 1, search.size());
    }

}