package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryIcons;
import com.ftpix.sss.models.User;
import com.ftpix.sss.transformer.GsonBodyTransformer;
import com.ftpix.sss.transformer.GsonCategoryListBodyTransformer;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ftpix.sss.controllers.api.ApiController.TOKEN;
import static com.ftpix.sss.controllers.api.UserSessionController.UNAUTHORIZED_SUPPLIER;
import static com.ftpix.sss.controllers.api.UserSessionController.getCurrentUser;

@SparkController("/API/Category")
public class CategoryController {

    private final Logger logger = LogManager.getLogger();


    /**
     * Get all categories
     *
     * @return list of categories
     * @throws SQLException
     */
    @SparkGet(accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<Category> getAll(@SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        return DB.CATEGORY_DAO.queryBuilder()
                                .orderBy("category_order", true)
                                .where().eq("user_id", u.getId())
                                .query();
                    } catch (SQLException throwables) {
                        return null;
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);
    }


    /**
     * Gets a single category
     *
     * @param id the id of the category to get
     * @return the category
     * @throws SQLException
     */
    @SparkGet(value = "/ById/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Category get(@SparkParam("id") long id, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        final Category category = DB.CATEGORY_DAO.queryForId(id);
                        if (category.getUser().getId().equals(u.getId())) {
                            return category;
                        } else {
                            return null;
                        }
                    } catch (SQLException throwables) {
                        logger.error("Couldn't get category", throwables);
                        return null;
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);

    }


    /**
     * get the available categories
     *
     * @return a list of categories
     * @throws SQLException
     */
    @SparkGet(value = "/Available", accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<String> getAvailable(@SparkHeader(TOKEN) String token) throws Exception {

        List<Category> categories = getAll(token);
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
    @SparkPost(transformer = GsonTransformer.class)
    public Category create(@SparkBody(GsonBodyTransformer.class) Category category, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        boolean found = CategoryIcons.ALL.contains(category.getIcon());

                        if (!found) {
                            Spark.halt(503, "Icon doesn't exist");
                        }


//                        long order = DB.CATEGORY_DAO.queryRawValue("SELECT MAX(category_order) FROM CATEGORY WHERE user_id = '" + u.getId().toString() + "'");

                        final long order = Optional.ofNullable(DB.CATEGORY_DAO.queryBuilder()
                                .selectColumns("category_order")
                                .limit(1L)
                                .orderBy("category_order", false)
                                .where()
                                .eq("user_id", u.getId())
                                .queryForFirst())
                                .map(Category::getCategoryOrder)
                                .orElse(0);
//                        long testOrder = Arrays.stream(cat

                        category.setCategoryOrder((int) (order + 1));
                        category.setUser(u);

                        DB.CATEGORY_DAO.create(category);

                        return category;
                    } catch (Exception e) {
                        logger.error("Couldn't create category", e);
                        throw new RuntimeException(e);
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);

    }

    @SparkPut(transformer = GsonTransformer.class)
    public List<Category> updateAll(@SparkBody(GsonCategoryListBodyTransformer.class) List<Category> categories, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    categories.stream()
                            .map(c -> {
                                try {
                                    final Category category = DB.CATEGORY_DAO.queryForId(c.getId());
                                    category.setCategoryOrder(c.getCategoryOrder());
                                    return category;
                                } catch (SQLException throwables) {
                                    throw new RuntimeException(throwables);
                                }
                            })
                            .forEach(c -> {
                                try {
                                    if (c.getUser().getId().equals(u.getId())) {
                                        DB.CATEGORY_DAO.update(c);
                                    } else {
                                        throw new RuntimeException("Not allowed to update this category");
                                    }
                                } catch (SQLException throwables) {
                                    throw new RuntimeException(throwables);
                                }
                            });

                    try {
                        return getAll(token);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);
    }

    /**
     * Updates a category
     *
     * @param id      the id of the category
     * @param catdiff the category with the changes to make
     * @return true of false if the update went smoothly
     * @throws SQLException
     */
    @SparkPut(value = "/:id", transformer = GsonTransformer.class)
    public boolean update(@SparkParam("id") long id, @SparkBody(GsonBodyTransformer.class) Category catdiff, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        Optional<Category> categoryOptional = Optional.ofNullable(get(id, token));


                        if (categoryOptional.isPresent()) {
                            boolean found = CategoryIcons.ALL.contains(catdiff.getIcon());

                            if (!found) {
                                Spark.halt(503, "Icon doesn't exist");
                            }

                            Category category = categoryOptional.get();
                            if (category.getUser().getId().equals(u.getId())) {
                                category.setId(id);
                                category.setIcon(catdiff.getIcon());
                                category.setCategoryOrder(catdiff.getCategoryOrder());
                                DB.CATEGORY_DAO.update(category);
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
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);
    }


    /**
     * Deletes a single castegory
     *
     * @param id the id of the category to delete
     * @return true or false depending on what happened
     * @throws SQLException
     */
    @SparkDelete(value = "/:id", transformer = GsonTransformer.class, accept = Constants.JSON)
    public boolean delete(@SparkParam("id") long id, @SparkHeader(TOKEN) String token) throws Exception {
        return getCurrentUser(token)
                .map(u -> {
                    try {
                        Map<String, Object> fields = new HashMap<>();
                        fields.put("CATEGORY_ID", id);

                        final Category category = get(id, token);
                        if (category.getUser().getId().equals(u.getId())) {

                            DB.EXPENSE_DAO.delete(DB.EXPENSE_DAO.queryForFieldValues(fields));
                            DB.RECURRING_EXPENSE_DAO.delete(DB.RECURRING_EXPENSE_DAO.queryForFieldValues(fields));

                            DB.CATEGORY_DAO.deleteById(id);
                            return true;
                        } else {
                            return false;
                        }
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .orElseThrow(UNAUTHORIZED_SUPPLIER);
    }

    /**
     * Search within the available categories.
     *
     * @param name the string to search for
     * @return a list of icon names
     * @throws SQLException
     */
    @SparkPost(value = "/search-icon", transformer = GsonTransformer.class, accept = Constants.JSON)
    public Map<String, Object> searchAvailableIcon(@SparkBody(GsonBodyTransformer.class) String name) throws SQLException {

        List<Category> categories = DB.CATEGORY_DAO.queryForAll();


        List<String> iconResults = CategoryIcons.ALL.stream()
                .filter(s -> StringUtils.containsIgnoreCase(s, name))
                .filter(s -> categories.stream().noneMatch(c -> c.getIcon().equalsIgnoreCase(s)))
                .collect(Collectors.toList());


        Map<String, Object> result = new HashMap<>();
        result.put("query", name);
        result.put("results", iconResults);

        System.out.println(result);

        return result;
    }

    public Category create(String icon, User user, String token) throws Exception {
        Category c = new Category();
        c.setIcon(icon);
        c.setUser(user);

        return create(c, token);
    }

    public boolean update(long id, String icon, int order, String token) throws Exception {
        Category cat = new Category();
        cat.setIcon(icon);
        cat.setCategoryOrder(order);
        return update(id, cat, token);
    }

    /**
     * category filter for expense queries
     *
     * @param token
     * @return
     */
    public List<Long> getUserCategoriesId(String token) throws Exception {
        return getAll(token).stream()
                .map(Category::getId)
                .collect(Collectors.toList());
    }
}


