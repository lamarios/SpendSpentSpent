package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.RecurringExpense;
import com.ftpix.sss.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

import static com.ftpix.sss.persistence.CategoryRepository.GET_USER_CATEGORIES;
import static com.ftpix.sss.persistence.ExpenseRepository.USER_PARAM;

public interface RecurringExpenseRepository extends JpaRepository<RecurringExpense, Long>, JpaSpecificationExecutor<RecurringExpense> {
    void deleteRecurringExpenseByCategory(Category category);


    @Query("from RecurringExpense where id = :id and category in " + GET_USER_CATEGORIES)
    RecurringExpense findRecurringExpenseByIdAndUser(@Param("id") long id, @Param(USER_PARAM) User user);

    @Query("from RecurringExpense where category in " + GET_USER_CATEGORIES)
    List<RecurringExpense> findExpenseByUser(@Param(USER_PARAM) User user);
}
