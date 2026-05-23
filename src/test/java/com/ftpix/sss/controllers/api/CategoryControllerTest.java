package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.CategoryService;
import com.ftpix.sss.services.UserService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@Import(TestConfig.class)
public class CategoryControllerTest extends TestContainerTest {


    @Autowired
    private CategoryService categoryService;
    @Autowired
    private UserService userService;

    @Autowired
    private TransactionTemplate transactionTemplate;

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

    @Test
    public void testCategoryOrdering() throws Exception {
        User user = new User();
        user.setFirstName("category order user");
        user.setLastName("category order lastname");
        user.setEmail("category-order@gmail.com");
        user.setPassword("aaaaa");

        user = userService.createUser(user);
        User finalUser = user;
        transactionTemplate.executeWithoutResult(status -> {
            try {


                categoryService.create("apple", finalUser);
                categoryService.create("books", finalUser);
                categoryService.create("camera", finalUser);


                List<Category> all = categoryService.getAll(finalUser);

                assertEquals(3, all.size());

                var apple = all.stream().filter(c -> c.getIcon().equals("apple")).findFirst().get();
                var books = all.stream().filter(c -> c.getIcon().equals("books")).findFirst().get();
                var camera = all.stream().filter(c -> c.getIcon().equals("camera")).findFirst().get();

                camera.setCategoryOrder(0);
                books.setCategoryOrder(1);
                apple.setCategoryOrder(2);

                categoryService.updateMany(List.of(camera, books, apple), finalUser);

            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });

        // we do in a new transaction to make sure it's not using session cache or anything
        transactionTemplate.executeWithoutResult(status -> {
            try {
                var all = categoryService.getAll(finalUser);

                assertEquals("camera", all.get(0).getIcon());
                assertEquals("books", all.get(1).getIcon());
                assertEquals("apple", all.get(2).getIcon());
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });

    }


}
