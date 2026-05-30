package com.ftpix.sss.persistence;

import com.ftpix.sss.models.HistoryId;
import com.ftpix.sss.models.MonthlyHistory;
import com.ftpix.sss.models.MonthlyTotal;
import com.ftpix.sss.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

import static com.ftpix.sss.persistence.CategoryRepository.GET_HOUSEHOLD_CATEGORIES;
import static com.ftpix.sss.persistence.ExpenseRepository.USER_PARAM;

public interface MonthlyHistoryRepository extends JpaRepository<MonthlyHistory, HistoryId>, JpaSpecificationExecutor<MonthlyHistory> {
    @Query("from MonthlyHistory y where y.id.date = :month and y.id.category in " + GET_HOUSEHOLD_CATEGORIES)
    List<MonthlyHistory> findAllByUserAndMonth(@Param(USER_PARAM) User user, @Param("month") int month);

    @Query("select new com.ftpix.sss.models.MonthlyTotal(y.id.date as date, sum(y.total) as total) from MonthlyHistory y where y.id.date / 100 = :year and y.id.category in "+GET_HOUSEHOLD_CATEGORIES+" group by y.id.date")
    List<MonthlyTotal> findTotalsByMonth(@Param(USER_PARAM) User user, @Param("year") int year);
}
