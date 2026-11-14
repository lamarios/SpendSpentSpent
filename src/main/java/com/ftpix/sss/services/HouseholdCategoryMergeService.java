package com.ftpix.sss.services;

import com.ftpix.sss.models.*;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.ExpenseRepository;
import com.ftpix.sss.persistence.HouseholdRepository;
import com.ftpix.sss.persistence.RecurringExpenseRepository;
import jakarta.persistence.EntityManager;
import java.util.*;
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Categories are shared within a household, so their icons must be unique in it. Members can still
 * own categories with the same icon: a user joining a household brings their own categories, and
 * households created before categories were shared can have them too. These categories are merged
 * into one.
 *
 * <p>The category of a household admin is kept, then the oldest one. Expenses and recurring
 * expenses of the other ones are moved to it and keep their creator, so they are moved back to a
 * category of their creator if they stop sharing the household (see {@link
 * HouseholdSeparationService}).
 */
@Service
public class HouseholdCategoryMergeService {
  private static final Logger logger = LogManager.getLogger();

  private final HouseholdRepository householdRepository;
  private final CategoryRepository categoryRepository;
  private final ExpenseRepository expenseRepository;
  private final RecurringExpenseRepository recurringExpenseRepository;
  private final EntityManager entityManager;

  @Autowired
  public HouseholdCategoryMergeService(
      HouseholdRepository householdRepository,
      CategoryRepository categoryRepository,
      ExpenseRepository expenseRepository,
      RecurringExpenseRepository recurringExpenseRepository,
      EntityManager entityManager) {
    this.householdRepository = householdRepository;
    this.categoryRepository = categoryRepository;
    this.expenseRepository = expenseRepository;
    this.recurringExpenseRepository = recurringExpenseRepository;
    this.entityManager = entityManager;
  }

  /**
   * Merges the categories with the same icon in every household. Safe to call at any time, it does
   * nothing when the icons are unique. The caller must hold the exclusive household lock.
   */
  @Transactional(propagation = Propagation.MANDATORY)
  public void mergeDuplicateCategories() {
    householdRepository.findAll().forEach(this::mergeDuplicateCategories);
  }

  /**
   * Merges the categories with the same icon in the household. The caller must hold the exclusive
   * household lock.
   *
   * @return the number of categories merged into another one
   */
  @Transactional(propagation = Propagation.MANDATORY)
  public int mergeDuplicateCategories(Household household) {
    List<HouseholdMember> members =
        household.getMembers().stream()
            .filter(member -> member.getStatus() == HouseholdInviteStatus.accepted)
            .toList();
    Set<UUID> admins =
        members.stream()
            .filter(HouseholdMember::isAdmin)
            .map(member -> member.getUser().getId())
            .collect(Collectors.toSet());

    Comparator<Category> keptFirst =
        Comparator.comparing((Category c) -> !admins.contains(c.getUser().getId()))
            .thenComparing(Category::getId);

    Collection<List<Category>> byIcon =
        members.stream()
            .flatMap(member -> categoryRepository.findAllByUser(member.getUser()).stream())
            .collect(Collectors.groupingBy(c -> c.getIcon().toLowerCase(Locale.ROOT)))
            .values();

    int merged = 0;
    for (List<Category> sameIcon : byIcon) {
      List<Category> sorted = sameIcon.stream().sorted(keptFirst).toList();
      Category kept = sorted.get(0);
      for (Category duplicate : sorted.subList(1, sorted.size())) {
        merge(duplicate, kept);
        merged++;
      }
    }
    return merged;
  }

  private void merge(Category duplicate, Category kept) {
    List<Expense> expenses = expenseRepository.findExpenseByCategory(duplicate);
    expenses.forEach(expense -> expense.setCategory(kept));
    expenseRepository.saveAll(expenses);

    List<RecurringExpense> recurringExpenses =
        recurringExpenseRepository.findRecurringExpenseByCategory(duplicate);
    recurringExpenses.forEach(recurring -> recurring.setCategory(kept));
    recurringExpenseRepository.saveAll(recurringExpenses);

    // Deleting the entity would cascade to its entries, still listed in its collections if they
    // were loaded before
    // the move. The move is written, then only the category row is deleted.
    entityManager.flush();
    entityManager
        .createQuery("delete from Category c where c.id = :id")
        .setParameter("id", duplicate.getId())
        .executeUpdate();

    logger.info(
        "Merged category {} into category {} ({}), moved {} expenses and {} recurring expenses",
        duplicate.getId(),
        kept.getId(),
        kept.getIcon(),
        expenses.size(),
        recurringExpenses.size());
  }
}
