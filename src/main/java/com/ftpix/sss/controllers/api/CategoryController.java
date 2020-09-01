package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryIcons;
import com.ftpix.sss.transformer.GsonBodyTransformer;
import com.ftpix.sss.transformer.GsonCategoryListBodyTransformer;
import com.ftpix.sss.transformer.GsonTransformer;
import com.j256.ormlite.dao.GenericRawResults;
import com.j256.ormlite.stmt.QueryBuilder;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

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
    public List<Category> getAll() throws SQLException {
        return DB.CATEGORY_DAO.queryBuilder().orderBy("category_order", true).query();
    }


    /**
     * Gets a single category
     *
     * @param id the id of the category to get
     * @return the category
     * @throws SQLException
     */
    @SparkGet(value = "/ById/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Category get(@SparkParam("id") long id) throws SQLException {
        return DB.CATEGORY_DAO.queryForId(id);
    }


    /**
     * get the available categories
     *
     * @return a list of categories
     * @throws SQLException
     */
    @SparkGet(value = "/Available", accept = Constants.JSON, transformer = GsonTransformer.class)
    public List<String> getAvailable() throws SQLException {

        List<Category> categories = DB.CATEGORY_DAO.queryForAll();
        return CategoryIcons.ALL.stream()
                .filter(s -> categories.stream().noneMatch(c -> c.getIcon().equalsIgnoreCase(s)))
                .collect(Collectors.toList());

    }


    /**
     * Creates a single category
     *
     * @param icon the icon of the new category
     * @return
     * @throws SQLException
     */
    @SparkPost(transformer = GsonTransformer.class)
    public Category create(@SparkQueryParam("icon") String icon) throws SQLException {
        Category category = new Category();


        boolean found = CategoryIcons.ALL.contains(icon);

        if (!found) {
            Spark.halt(503, "Icon doesn't exist");
        }


        long order = DB.CATEGORY_DAO.queryRawValue("SELECT MAX(category_order) FROM CATEGORY");

        category.setIcon(icon);
        category.setCategoryOrder((int) (order + 1));
        DB.CATEGORY_DAO.create(category);

        return category;
    }

    @SparkPut(transformer = GsonTransformer.class)
    public List<Category> updateAll(@SparkBody(GsonCategoryListBodyTransformer.class) List<Category> categories) throws SQLException {
        categories.forEach(c -> {
            try {
                DB.CATEGORY_DAO.update(c);
            } catch (SQLException throwables) {
                throw new RuntimeException(throwables);
            }
        });

        return getAll();
    }

    /**
     * Updates a category
     *
     * @param id    the id of the category
     * @param icon  the new icon for the updated category
     * @param order the new order of the category
     * @return true of false if the update went smoothly
     * @throws SQLException
     */
    @SparkPut(value = "/:id", transformer = GsonTransformer.class)
    public boolean update(@SparkParam("id") long id, @SparkQueryParam("icon") String icon, @SparkQueryParam("order") int order) throws SQLException {
        Optional<Category> categoryOptional = Optional.ofNullable(get(id));


        if (categoryOptional.isPresent()) {
            boolean found = CategoryIcons.ALL.contains(icon);

            if (!found) {
                Spark.halt(503, "Icon doesn't exist");
            }

            Category category = categoryOptional.get();
            category.setId(id);
            category.setIcon(icon);
            category.setCategoryOrder(order);
            DB.CATEGORY_DAO.update(category);
            return true;
        } else {
            return false;
        }
    }


    /**
     * Deletes a single castegory
     *
     * @param id the id of the category to delete
     * @return true or false depending on what happened
     * @throws SQLException
     */
    @SparkDelete(value = "/:id", transformer = GsonTransformer.class, accept = Constants.JSON)
    public boolean delete(@SparkParam("id") long id) throws SQLException {
        Map<String, Object> fields = new HashMap<>();
        fields.put("CATEGORY_ID", id);

        DB.EXPENSE_DAO.delete(DB.EXPENSE_DAO.queryForFieldValues(fields));
        DB.RECURRING_EXPENSE_DAO.delete(DB.RECURRING_EXPENSE_DAO.queryForFieldValues(fields));

        DB.CATEGORY_DAO.deleteById(id);
        return true;
    }

    /**
     * Search within the available categories.
     *
     * @param name the string to search for
     * @return a list of icon names
     * @throws SQLException
     */
    @SparkPost(value = "/search-icon", transformer = GsonTransformer.class, accept = Constants.JSON)
    public Map<String, Object> searchAvailableIcon(@SparkQueryParam("name") String name) throws SQLException {

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
}


