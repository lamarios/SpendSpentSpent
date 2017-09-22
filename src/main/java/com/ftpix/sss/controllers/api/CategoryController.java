package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryIcons;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.sql.SQLException;
import java.util.*;

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
        return DB.CATEGORY_DAO.queryForAll();
    }


    /**
     * Gets a single category
     *
     * @param id the id of the category to get
     * @return the category
     * @throws SQLException
     */
    @SparkGet(value = "/ById/:id", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Category get(@SparkParam("id") int id) throws SQLException {
        return DB.CATEGORY_DAO.queryForId(id);
    }


    /**
     * get the available categories
     *
     * @return a list of categories
     * @throws SQLException
     */
    @SparkGet(value = "/Available", accept = Constants.JSON, transformer = GsonTransformer.class)
    public TreeMap<String, List<String>> getAvailable() throws SQLException {
        TreeMap<String, List<String>> icons = new TreeMap<>(CategoryIcons.ALL);


        for (Category category : DB.CATEGORY_DAO.queryForAll()) {
            for (String iconCategory : icons.keySet()) {
                icons.get(iconCategory).remove(category.getIcon());
            }
        }


        return icons;
    }


    /**
     * Creates a single cateogory
     *
     * @param icon  the icon of the new category
     * @param order the order of display of the new category
     * @return
     * @throws SQLException
     */
    @SparkPost(transformer = GsonTransformer.class)
    public Category create(@SparkQueryParam("icon") String icon, @SparkQueryParam("order") int order) throws SQLException {
        Category category = new Category();


        boolean found = false;
        for (String iconCategory : CategoryIcons.ALL.keySet()) {
            if (CategoryIcons.ALL.get(iconCategory).contains(icon)) {
                found = true;
                break;
            }
        }

        if (!found) {
            Spark.halt(503, "Icon doesn't exist");
        }


        category.setIcon(icon);
        category.setCategoryOrder(order);
        DB.CATEGORY_DAO.create(category);

        return category;
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
    public boolean update(@SparkParam("id") int id, @SparkQueryParam("icon") String icon, @SparkQueryParam("order") int order) throws SQLException {
        Optional<Category> categoryOptional = Optional.ofNullable(get(id));


        if (categoryOptional.isPresent()) {
            boolean found = false;
            for (String iconCategory : CategoryIcons.ALL.keySet()) {
                if (CategoryIcons.ALL.get(iconCategory).contains(icon)) {
                    found = true;
                    break;
                }
            }

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
    public boolean delete(@SparkParam("id") int id) throws SQLException {
        Map<String, Object> fields = new HashMap<>();
        fields.put("CATEGORY_ID", id);

        DB.EXPENSE_DAO.delete(DB.EXPENSE_DAO.queryForFieldValues(fields));
        DB.RECURRING_EXPENSE_DAO.delete(DB.RECURRING_EXPENSE_DAO.queryForFieldValues(fields));

        DB.CATEGORY_DAO.deleteById(id);
        return true;
    }
}


