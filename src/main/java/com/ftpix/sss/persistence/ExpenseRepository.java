package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategoryExpenseCount;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

import static com.ftpix.sss.persistence.CategoryRepository.CREATOR_OUTSIDE_CATEGORY_HOUSEHOLD;
import static com.ftpix.sss.persistence.CategoryRepository.GET_HOUSEHOLD_CATEGORIES;

public interface ExpenseRepository extends JpaRepository<Expense, Long>, JpaSpecificationExecutor<Expense> {
    String USER_PARAM = "user";

    // Expenses are owned by the user who created them, even when booked on a category shared by another household member
    @Query("from Expense e where e.id = :id and e.user = :user")
    Expense findExpenseByIdAndUser(@Param("id") long id, @Param(USER_PARAM) User user);

    @Query("from Expense e where e.user = :user")
    List<Expense> findExpenseByUser(@Param(USER_PARAM) User user);

    @Query("select e.note from Expense e where e.category = :category and e.category in " + GET_HOUSEHOLD_CATEGORIES)
    List<String> findNotes(@Param(USER_PARAM) User user, @Param("category") Category category);

    @Query("select e.note from Expense e where lower(e.note) like lower(:seed) and e.category in " + GET_HOUSEHOLD_CATEGORIES)
    List<String> autoCompleteNote(@Param(USER_PARAM) User user, @Param("seed") String seed);


    @Query("from Expense where timestamp >= :from and timestamp <= :to and category in " + GET_HOUSEHOLD_CATEGORIES + " order by timestamp desc")
    List<Expense> findFromHouseHoldForDates(@Param(USER_PARAM) User user, @Param("from") long from, @Param("to") long to);

    @Query("from Expense where category in " + GET_HOUSEHOLD_CATEGORIES)
    Slice<Expense> getSlice(@Param(USER_PARAM) User user, Pageable pageable);

    @Query("select e.timestamp from Expense e where e.category in " + GET_HOUSEHOLD_CATEGORIES)
    List<Long> getHouseholdExpenseTimes(@Param(USER_PARAM) User user);

    void deleteExpenseByCategory(Category category);

    List<Expense> findExpenseByCategory(Category category);


    // counts include every household member's expenses as deleting a category deletes all of them
    @Query("select count(e) from Expense e where e.category.id = :category and e.category in " + GET_HOUSEHOLD_CATEGORIES)
    long countExpenses(@Param(USER_PARAM) User user, @Param("category") long categoryId);

    @Query("select e.category.id as categoryId, count(e) as count from Expense e where e.category in " + GET_HOUSEHOLD_CATEGORIES + " group by e.category")
    List<CategoryExpenseCount> countExpensesForEveryCategories(@Param(USER_PARAM) User user);

    @Query("from Expense e where " + CREATOR_OUTSIDE_CATEGORY_HOUSEHOLD)
    List<Expense> findExpensesOnCategoriesOutsideHousehold();

    /**
     * Expenses created by versions that didn't track the creator get attributed to the category owner.
     */
    @Modifying
    @Query(value = "UPDATE expense e SET user_id = c.user_id FROM category c WHERE e.category_id = c.id AND e.user_id IS NULL", nativeQuery = true)
    int assignMissingOwners();
}
