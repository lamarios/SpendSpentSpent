package com.ftpix.sss.persistence;

import static com.ftpix.sss.persistence.CategoryRepository.CREATOR_OUTSIDE_CATEGORY_HOUSEHOLD;
import static com.ftpix.sss.persistence.CategoryRepository.GET_HOUSEHOLD_CATEGORIES;
import static com.ftpix.sss.persistence.ExpenseRepository.USER_PARAM;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RecurringExpenseRepository
    extends JpaRepository<RecurringExpense, Long>, JpaSpecificationExecutor<RecurringExpense> {
  void deleteRecurringExpenseByCategory(Category category);

  List<RecurringExpense> findRecurringExpenseByCategory(Category category);

  // recurring expenses are shared within the household, every member can see and manage them
  @Query("from RecurringExpense where id = :id and category in " + GET_HOUSEHOLD_CATEGORIES)
  RecurringExpense findHouseholdRecurringExpenseById(
      @Param("id") long id, @Param(USER_PARAM) User user);

  @Query("from RecurringExpense where category in " + GET_HOUSEHOLD_CATEGORIES)
  List<RecurringExpense> findHouseholdRecurringExpenses(@Param(USER_PARAM) User user);

  @Query("from RecurringExpense e where " + CREATOR_OUTSIDE_CATEGORY_HOUSEHOLD)
  List<RecurringExpense> findRecurringExpensesOnCategoriesOutsideHousehold();

  /**
   * Recurring expenses created by versions that didn't track the creator get attributed to the
   * category owner.
   */
  @Modifying
  @Query(
      value =
          "UPDATE recurring_expense r SET user_id = c.user_id FROM category c WHERE r.category_id = c.id AND r.user_id IS NULL",
      nativeQuery = true)
  int assignMissingOwners();
}
