package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.CategoryService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Import(TestConfig.class)
public class CategoryControllerTest extends TestContainerTest {


    @Autowired
    private CategoryService categoryService;

    @Autowired
    private User currentUser;


    @Disabled
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
    @Disabled
    public void createNonExistentCategory() {
        Assertions.assertThrows(Exception.class, () -> categoryService.create("icon-that-does-not-exist", currentUser));
    }

    //    @Test(expected = Exception.class)
    @Test
    @Disabled
    public void updateNonExistentCategory() {
        Assertions.assertThrows(Exception.class, () -> {
            categoryService.update(423423, "furniture", 0, currentUser);
        });
    }


}
