package com.ftpix.sss.services;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.dao.RecurringExpenseDao;
import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.models.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class CategoryService {

    private final CategoryDao categoryDaoJooq;
    private final ExpenseDao expenseDaoJooq;
    private final RecurringExpenseDao recurringExpenseDaoJooq;


    @Autowired
    public CategoryService(CategoryDao categoryDaoJooq, ExpenseDao expenseDaoJooq, RecurringExpenseDao recurringExpenseDaoJooq) {
        this.categoryDaoJooq = categoryDaoJooq;
        this.expenseDaoJooq = expenseDaoJooq;
        this.recurringExpenseDaoJooq = recurringExpenseDaoJooq;
    }


    @Transactional(readOnly = true)
    public List<Category> getAll(User user) throws SQLException {
        return categoryDaoJooq.getWhere(user);
    }

    @Transactional(readOnly = true)
    public Category get(long id, User user) throws SQLException {
        return categoryDaoJooq.get(user, id).orElse(null);
    }

    @Transactional(readOnly = true)
    public Map<String, List<NewCategoryIcon>> getAvailable(User user) throws SQLException {
        List<Category> categories = getAll(user);
        return Stream.of(NewCategoryIcon.values())
                .filter(s -> categories.stream().noneMatch(c -> c.getIcon().equalsIgnoreCase(s.name())))
                .collect(Collectors.groupingBy(NewCategoryIcon::getCategory));
    }

    @Transactional(readOnly = true)
    public Map<String, List<NewCategoryIcon>> getUsed(User user) throws SQLException {
        List<Category> categories = getAll(user);
        return Stream.of(NewCategoryIcon.values())
                .filter(s -> categories.stream().anyMatch(c -> c.getIcon().equalsIgnoreCase(s.name())))
                .collect(Collectors.groupingBy(NewCategoryIcon::getCategory));
    }

    @Transactional
    public Category create(Category category, User user) throws Exception {
        boolean found = Stream.of(NewCategoryIcon.values())
                .anyMatch(c -> category.getIcon().equalsIgnoreCase(c.name()));

        if (!found) {
            throw new Exception("Icon doesn't exist");
        }

        long order = categoryDaoJooq.getMaxCategoryOrder(user);
        category.setCategoryOrder((int) (order + 1));
        category.setUser(user);
        return categoryDaoJooq.insert(user, category);
    }

    @Transactional
    public Category update(Category category, User user) throws Exception {
        categoryDaoJooq.update(user, category);
        return category;
    }

    @Transactional
    public boolean delete(long id, User user) throws SQLException {
        Map<String, Object> fields = new HashMap<>();
        fields.put("CATEGORY_ID", id);

        final Category category = get(id, user);
        if (category.getUser().getId().equals(user.getId())) {

            expenseDaoJooq.deleteWhere(user, Tables.EXPENSE.CATEGORY_ID.eq(category.getId()));
            recurringExpenseDaoJooq.deleteWhere(user, Tables.RECURRING_EXPENSE.CATEGORY_ID.eq(category.getId()));

            categoryDaoJooq.delete(user, category);
            return true;
        } else {
            return false;
        }
    }

    @Transactional
    public List<Category> updateMany(List<Category> categories, User user) throws SQLException {
        categories.stream()
                .map(c -> {
                    try {
                        final Category category = get(c.getId(), user);

                        Optional.ofNullable(c.getIcon()).ifPresent(category::setIcon);

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

    @Transactional
    public Category create(String icon, User user) throws Exception {
        Category c = new Category();
        c.setIcon(icon);
        c.setUser(user);

        return create(c, user);
    }

    @Transactional
    public Category update(long id, String icon, int order, User user) throws Exception {
        Category cat = get(id, user);
        cat.setIcon(icon);
        cat.setCategoryOrder(order);
        return update(cat, user);
    }

    @Transactional(readOnly = true)
    public List<Long> getUserCategoriesId(User user) throws Exception {
        return getAll(user).stream()
                .map(Category::getId)
                .collect(Collectors.toList());
    }


    @Transactional(readOnly = true)
    public Map<String, Object> searchAvailableIcon(String name, User user) throws SQLException {
        List<Category> categories = getAll(user);


        Map<String, List<NewCategoryIcon>> results = Stream.of(NewCategoryIcon.values())
                .filter(c -> Arrays.stream(c.getSearchTerms()).anyMatch(t -> StringUtils.containsIgnoreCase(t, name) || StringUtils.containsIgnoreCase(name, t)))
                .filter(s -> categories.stream().noneMatch(c -> c.getIcon().equalsIgnoreCase(s.name())))
                .collect(Collectors.groupingBy(NewCategoryIcon::getCategory));

        Map<String, Object> result = new HashMap<>();
        result.put("query", name);
        result.put("results", results);

        return result;
    }

    public boolean isUsingLegacyIcons(User user) throws SQLException {
        return getAll(user).stream()
                .map(Category::getIcon)
                .anyMatch(name -> name.startsWith("icon-"));
    }

    @Transactional
    public boolean mergeCategory(long id, Category catdiff, User currentUser) throws Exception {
        Optional<Category> categoryOptional = Optional.ofNullable(get(id, currentUser));


        if (categoryOptional.isPresent()) {
            boolean found = Stream.of(NewCategoryIcon.values())
                    .anyMatch(c -> catdiff.getIcon().equalsIgnoreCase(c.name()));

            if (!found) {
                throw new Exception("Icon doesn't exist");
            }

            Category category = categoryOptional.get();
            if (category.getUser().getId().equals(currentUser.getId())) {
                category.setId(id);
                category.setIcon(catdiff.getIcon());
                category.setCategoryOrder(catdiff.getCategoryOrder());
                update(category, currentUser);
                return true;
            } else {
                throw new RuntimeException("Not allowed to edit this category");
            }
        } else {
            return false;
        }
    }

    @Transactional(readOnly = true)
    public long countExpenses(long id, User currentUser) throws SQLException {
        return Optional.ofNullable(get(id, currentUser))
                .map(c -> expenseDaoJooq.countExpenses(currentUser, id))
                .orElse(0L);
    }

}
