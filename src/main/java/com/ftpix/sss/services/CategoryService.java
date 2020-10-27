package com.ftpix.sss.services;

import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryIcons;
import com.ftpix.sss.models.User;
import org.springframework.stereotype.Service;
import spark.Spark;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CategoryService {

    public List<Category> getAll(User user) throws SQLException {
        return DB.CATEGORY_DAO.queryBuilder()
                .orderBy("category_order", true)
                .where().eq("user_id", user.getId())
                .query();
    }

    public Category get(long id, User user) throws SQLException {
        final Category category = DB.CATEGORY_DAO.queryForId(id);
        if (category.getUser().getId().equals(user.getId())) {
            return category;
        } else {
            return null;
        }
    }

    public long getNewCategoryOrder(User user) throws SQLException {
        return Optional.ofNullable(DB.CATEGORY_DAO.queryBuilder()
                .selectColumns("category_order")
                .limit(1L)
                .orderBy("category_order", false)
                .where()
                .eq("user_id", user.getId())
                .queryForFirst())
                .map(Category::getCategoryOrder)
                .orElse(0);
    }

    public Category create(Category category, User user) throws SQLException {
        boolean found = CategoryIcons.ALL.contains(category.getIcon());

        if (!found) {
            Spark.halt(503, "Icon doesn't exist");
        }

        long order = getNewCategoryOrder(user);
        category.setCategoryOrder((int) (order + 1));
        category.setUser(user);
        DB.CATEGORY_DAO.create(category);

        return category;
    }

    public Category update(Category category, User user) throws Exception {
        if (category.getUser().getId().equals(user.getId())) {
            DB.CATEGORY_DAO.update(category);
            return category;
        } else {
            throw new Exception("Not allowed to edit category");
        }
    }

    public boolean delete(long id, User user) throws SQLException {
        Map<String, Object> fields = new HashMap<>();
        fields.put("CATEGORY_ID", id);

        final Category category = get(id, user);
        if (category.getUser().getId().equals(user.getId())) {

            DB.EXPENSE_DAO.delete(DB.EXPENSE_DAO.queryForFieldValues(fields));
            DB.RECURRING_EXPENSE_DAO.delete(DB.RECURRING_EXPENSE_DAO.queryForFieldValues(fields));

            DB.CATEGORY_DAO.deleteById(id);
            return true;
        } else {
            return false;
        }
    }

    public List<Category> updateMany(List<Category> categories, User user) throws SQLException {
        categories.stream()
                .map(c -> {
                    try {
                        final Category category = get(c.getId(), user);
                        category.setCategoryOrder(c.getCategoryOrder());
                        return category;
                    } catch (SQLException throwables) {
                        throw new RuntimeException(throwables);
                    }
                })
                .forEach(c -> {
                    try {
                        update(c, user);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                });

        return getAll(user);
    }

    public Category create(String icon, User user) throws Exception {
        Category c = new Category();
        c.setIcon(icon);
        c.setUser(user);

        return create(c, user);
    }

    public Category update(long id, String icon, int order, User user) throws Exception {
        Category cat = new Category();
        cat.setIcon(icon);
        cat.setCategoryOrder(order);
        return update(cat, user);
    }

    public List<Long> getUserCategoriesId(User user) throws Exception {
        return getAll(user).stream()
                .map(Category::getId)
                .collect(Collectors.toList());
    }
}
