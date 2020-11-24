package com.ftpix.sss.controllers.api;


import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.NewCategoryIcon;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.CategoryService;
import com.ftpix.sss.services.HistoryService;
import com.ftpix.sss.services.UserService;
import io.swagger.annotations.Api;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/API/Category")
@Api(tags = {"Categories"})
public class CategoryController {

    protected final Log logger = LogFactory.getLog(this.getClass());


    private final UserService userService;

    private final CategoryService categoryService;

    private final HistoryService historyService;

    @Autowired
    public CategoryController(UserService userService, CategoryService categoryService, HistoryService historyService) {
        this.userService = userService;
        this.categoryService = categoryService;
        this.historyService = historyService;
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


        return historyService.monthly(currentUser)
                .stream()
                .skip(1) // first is always the overall category
                .map(c -> {
                    double percentage = c.getAmount() / c.getTotal();
                    c.getCategory().setPercentageOfMonthly(percentage);
                    return c.getCategory();
                })
                .sorted(Comparator.comparingInt(Category::getCategoryOrder))
                .collect(Collectors.toList());
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
    public Map<String, List<NewCategoryIcon>> getAvailable() throws Exception {
        return categoryService.getAvailable(userService.getCurrentUser());
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
        return categoryService.mergeCategory(id, catdiff, currentUser);
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
        return categoryService.searchAvailableIcon(name, currentUser);
    }

    @GetMapping("/is-using-legacy")
    public boolean isUsingLegacy() throws SQLException {
        return categoryService.isUsingLegacyIcons(userService.getCurrentUser());
    }

    public List<Long> getUserCategoriesId() throws Exception {
        return getAll().stream()
                .map(Category::getId)
                .collect(Collectors.toList());
    }

}


