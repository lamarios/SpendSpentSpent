package com.ftpix.sss.services;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryExpenseCount;
import com.ftpix.sss.models.NewCategoryIcon;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class CategoryService {

//    private final CategoryDao categoryDaoJooq;
//    private final ExpenseDao expenseDaoJooq;
//    private final RecurringExpenseDao recurringExpenseDaoJooq;

    private final CategoryRepository categoryRepository;
    private final ExpenseRepository expenseRepository;
    private final RecurringExpenseRepository recurringExpenseRepository;
    private final HouseholdService householdService;

    @Autowired
    public CategoryService(CategoryRepository categoryRepository, ExpenseRepository expenseRepository, RecurringExpenseRepository recurringExpenseRepository, HouseholdService householdService) {
        this.categoryRepository = categoryRepository;
        this.expenseRepository = expenseRepository;
        this.recurringExpenseRepository = recurringExpenseRepository;
        this.householdService = householdService;
    }


    /**
     * Categories are shared within a household, this returns the user's categories and the ones of the other household members.
     */
    @Transactional(readOnly = true)
    public List<Category> getAll(User user) throws SQLException {
        return categoryRepository.getHouseholdCategoriesOrdered(user);
    }

    /**
     * @return only the categories created by the user, regardless of household
     */
    @Transactional(readOnly = true)
    public List<Category> getOwn(User user) {
        return categoryRepository.findAllByUser(user, Sort.by("categoryOrder").ascending());
    }

    /**
     * @return the category if it belongs to the user or to a member of the user's household, null otherwise
     */
    @Transactional(readOnly = true)
    public Category get(long id, User user) throws SQLException {
        return categoryRepository.findHouseholdCategoryById(id, user);
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

        // categories are shared within the household, the same icon can't be used twice
        if (getAll(user).stream().anyMatch(c -> category.getIcon().equalsIgnoreCase(c.getIcon()))) {
            throw new Exception("Icon already used by another category");
        }

        long order = categoryRepository.getMaxHouseholdCategoryOrder(user);
        category.setCategoryOrder((int) (order + 1));
        category.setUser(user);
        return categoryRepository.save(category);
    }

    @Transactional
    public Category update(Category category, User user) throws Exception {
        if (get(category.getId(), user) != null) {
//            categoryDaoJooq.update(user, category);
            categoryRepository.save(category);
        }
        return category;
    }

    /**
     * Deleting a category deletes all of its expenses, including the ones of other household members.
     * Only the creator of the category or a household admin can do it.
     */
    @Transactional
    public boolean delete(long id, User user) throws SQLException {

        final Category category = get(id, user);
        if (category == null) {
            return false;
        }

        boolean isCreator = category.getUser() != null && category.getUser().getId().equals(user.getId());
        if (isCreator || householdService.isCurrentHouseholdAdmin(user)) {
            expenseRepository.deleteExpenseByCategory(category);
            recurringExpenseRepository.deleteRecurringExpenseByCategory(category);

            categoryRepository.delete(category);
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
                .filter(c -> Arrays.stream(c.getSearchTerms())
                        .anyMatch(t -> StringUtils.containsIgnoreCase(t, name) || StringUtils.containsIgnoreCase(name, t)))
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

            // any household member can edit a category, get() already restricts to the household
            Category category = categoryOptional.get();
            category.setIcon(catdiff.getIcon());
            category.setCategoryOrder(catdiff.getCategoryOrder());
            update(category, currentUser);
            return true;
        } else {
            return false;
        }
    }

    @Transactional(readOnly = true)
    public long countExpenses(long id, User currentUser) throws SQLException {
        return Optional.ofNullable(get(id, currentUser))
                .map(c -> expenseRepository.countExpenses(currentUser, id))
                .orElse(0L);
    }

    @Transactional(readOnly = true)
    public Map<Long, Long> countEveryExpenses(User user) {
        return expenseRepository.countExpensesForEveryCategories(user)
                .stream()
                .collect(Collectors.toMap(CategoryExpenseCount::categoryId, CategoryExpenseCount::count));
    }
}
