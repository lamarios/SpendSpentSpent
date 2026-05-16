package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

import static com.ftpix.sss.persistence.CategoryRepository.GET_HOUSEHOLD_CATEGORIES;
import static com.ftpix.sss.persistence.CategoryRepository.GET_USER_CATEGORIES;

public interface ExpenseRepository extends JpaRepository<Expense, Long>, JpaSpecificationExecutor<Expense> {
    String USER_PARAM = "user";

    @Query("from Expense where id = :id and category in " + GET_USER_CATEGORIES)
    Expense findExpenseByIdAndUser(@Param("id") long id, @Param(USER_PARAM) User user);

    @Query("from Expense where category in " + GET_USER_CATEGORIES)
    List<Expense> findExpenseByUser(@Param(USER_PARAM) User user);

    @Query("select e.note from Expense e where e.category = :category and e.amount >= :minExpense and e.amount <= :maxExpense and e.category in " + GET_USER_CATEGORIES)
    List<String> findNotes(@Param(USER_PARAM) User user, @Param("category") Category category, @Param("minExpense") double minExpense, @Param("maxExpense") double maxExpense);

    @Query("select e.note from Expense e where lower(e.note) like :seed and e.category in " + GET_USER_CATEGORIES)
    List<String> autoCompleteNote(@Param(USER_PARAM) User user, @Param("seed") String seed);


    @Query("from Expense where timestamp >= :from and timestamp <= :to and category in " + GET_HOUSEHOLD_CATEGORIES + " order by timestamp desc")
    List<Expense> findFromHouseHoldForDates(@Param(USER_PARAM) User user, @Param("from") long from, @Param("to") long to);

    @Query("from Expense where category in " + GET_USER_CATEGORIES)
    Slice<Expense> getSlice(@Param(":user") User user, Pageable pageable);

    @Query("select e.timestamp from Expense e where e.category in " + GET_HOUSEHOLD_CATEGORIES)
    List<Long> getHouseholdExpenseTimes(@Param("user") User user);

    void deleteExpenseByCategory(Category category);


    @Query("select count(e) from Expense e where e.category.id = :category and e.category in " + GET_USER_CATEGORIES)
    long countExpenses(@Param(USER_PARAM) User user, @Param("category") long categoryId);
}
