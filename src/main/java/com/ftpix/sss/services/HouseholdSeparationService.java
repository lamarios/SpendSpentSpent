package com.ftpix.sss.services;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Categories are shared within a household, so members can create expenses and recurring expenses on each other's
 * categories. When two users aren't in the same household anymore (a member leaves or is removed, the household is
 * deleted or a user is deleted), these entries are moved to a category with the same icon that their creator can
 * access. Such a category is created if needed. This way nobody loses data and nobody keeps seeing the data of
 * a former household member.
 */
@Service
public class HouseholdSeparationService {
    private final static Logger logger = LogManager.getLogger();

    private final CategoryRepository categoryRepository;
    private final ExpenseRepository expenseRepository;
    private final RecurringExpenseRepository recurringExpenseRepository;

    @Autowired
    public HouseholdSeparationService(CategoryRepository categoryRepository, ExpenseRepository expenseRepository, RecurringExpenseRepository recurringExpenseRepository) {
        this.categoryRepository = categoryRepository;
        this.expenseRepository = expenseRepository;
        this.recurringExpenseRepository = recurringExpenseRepository;
    }

    /**
     * Moves every expense and recurring expense whose creator isn't in the household of the category owner anymore.
     * Safe to call at any time, it does nothing when everything is consistent.
     */
    @Transactional
    public void separateEntriesOutsideHousehold() {
        // key: user id + icon, so all moved entries of a user end up in the same category
        Map<String, Category> targets = new HashMap<>();

        List<Expense> expenses = expenseRepository.findExpensesOnCategoriesOutsideHousehold();
        expenses.forEach(expense -> expense.setCategory(targetCategory(expense.getUser(), expense.getCategory(), targets)));
        expenseRepository.saveAll(expenses);

        List<RecurringExpense> recurringExpenses = recurringExpenseRepository.findRecurringExpensesOnCategoriesOutsideHousehold();
        recurringExpenses.forEach(recurring -> recurring.setCategory(targetCategory(recurring.getUser(), recurring.getCategory(), targets)));
        recurringExpenseRepository.saveAll(recurringExpenses);

        if (!expenses.isEmpty() || !recurringExpenses.isEmpty()) {
            logger.info("Moved {} expenses and {} recurring expenses to categories of their creator's household", expenses.size(), recurringExpenses.size());
        }
    }

    private Category targetCategory(User user, Category current, Map<String, Category> targets) {
        String icon = current.getIcon();
        return targets.computeIfAbsent(user.getId() + "/" + icon.toLowerCase(), key -> categoryRepository.getHouseholdCategoriesOrdered(user)
                .stream()
                .filter(c -> c.getIcon().equalsIgnoreCase(icon))
                .findFirst()
                .orElseGet(() -> {
                    Category category = new Category();
                    category.setIcon(icon);
                    category.setUser(user);
                    category.setCategoryOrder((int) categoryRepository.getMaxHouseholdCategoryOrder(user) + 1);
                    return categoryRepository.save(category);
                }));
    }
}
