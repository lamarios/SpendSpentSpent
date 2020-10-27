package com.ftpix.sss.controllers.api;


import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryIcons;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.CategoryService;
import com.ftpix.sss.services.UserService;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import spark.Spark;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/API/Category")
public class CategoryController {

    protected final Log logger = LogFactory.getLog(this.getClass());


    private final UserService userService;

    private final CategoryService categoryService;

    @Autowired
    public CategoryController(UserService userService, CategoryService categoryService) {
        this.userService = userService;
        this.categoryService = categoryService;
    }

    /**
     * Get all categories
     *
     * @return list of categories
     * @throws SQLException
     */
    @GetMapping
    public List<Category> getAll() throws Exception {
        final User currentUser = userService.getCurrentUser();
        return categoryService.getAll(currentUser);
    }

    /**
     * Gets a single category
     *
     * @param id the id of the category to get
     * @return the category
     * @throws SQLException
     */
    @GetMapping(value = "/ById/{id}")
    public Category get(@PathVariable("id") long id) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return categoryService.get(id, currentUser);

    }

    /**
     * get the available categories
     *
     * @return a list of categories
     * @throws SQLException
     */
    @GetMapping(value = "/Available")
    public List<String> getAvailable() throws Exception {

        List<Category> categories = getAll();
        return CategoryIcons.ALL.stream()
                .filter(s -> categories.stream().noneMatch(c -> c.getIcon().equalsIgnoreCase(s)))
                .collect(Collectors.toList());

    }

    /**
     * Creates a single category
     *
     * @param category The category to create
     * @return
     * @throws SQLException
     */
    @PostMapping
    public Category create(@RequestBody Category category) throws Exception {
        final User user = userService.getCurrentUser();

        return categoryService.create(category, user);

    }

    @PutMapping
    public List<Category> updateAll(@RequestBody List<Category> categories) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return categoryService.updateMany(categories, currentUser);
    }

    /**
     * Updates a category
     *
     * @param id      the id of the category
     * @param catdiff the category with the changes to make
     * @return true of false if the update went smoothly
     * @throws SQLException
     */
    @PutMapping("/{id}")
    public boolean update(@PathVariable("id") long id, @RequestBody Category catdiff) throws Exception {
        final User currentUser = userService.getCurrentUser();
        try {
            Optional<Category> categoryOptional = Optional.ofNullable(get(id));


            if (categoryOptional.isPresent()) {
                boolean found = CategoryIcons.ALL.contains(catdiff.getIcon());

                if (!found) {
                    Spark.halt(503, "Icon doesn't exist");
                }

                Category category = categoryOptional.get();
                if (category.getUser().getId().equals(currentUser.getId())) {
                    category.setId(id);
                    category.setIcon(catdiff.getIcon());
                    category.setCategoryOrder(catdiff.getCategoryOrder());
                    categoryService.update(category, currentUser);
                    return true;
                } else {
                    throw new RuntimeException("Not allowed to edit this category");
                }
            } else {
                return false;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    /**
     * Deletes a single castegory
     *
     * @param id the id of the category to delete
     * @return true or false depending on what happened
     * @throws SQLException
     */
    @DeleteMapping(value = "/{id}")
    public boolean delete(@PathVariable("id") long id) throws Exception {
        final User currentUser = userService.getCurrentUser();
        return categoryService.delete(id, currentUser);
    }

    /**
     * Search within the available categories.
     *
     * @param name the string to search for
     * @return a list of icon names
     * @throws SQLException
     */
    @PostMapping("/search-icon")
    public Map<String, Object> searchAvailableIcon(@RequestBody String name) throws SQLException {
        final User currentUser = userService.getCurrentUser();
        List<Category> categories = categoryService.getAll(currentUser);


        List<String> iconResults = CategoryIcons.ALL.stream()
                .filter(s -> StringUtils.containsIgnoreCase(s, name))
                .filter(s -> categories.stream().noneMatch(c -> c.getIcon().equalsIgnoreCase(s)))
                .collect(Collectors.toList());


        Map<String, Object> result = new HashMap<>();
        result.put("query", name);
        result.put("results", iconResults);

        return result;
    }

    public List<Long> getUserCategoriesId() throws Exception {
        return getAll().stream()
                .map(Category::getId)
                .collect(Collectors.toList());
    }

}


