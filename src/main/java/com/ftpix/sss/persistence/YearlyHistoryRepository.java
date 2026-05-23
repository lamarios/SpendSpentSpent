package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.HistoryId;
import com.ftpix.sss.models.User;
import com.ftpix.sss.models.YearlyHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

import static com.ftpix.sss.persistence.CategoryRepository.GET_HOUSEHOLD_CATEGORIES;
import static com.ftpix.sss.persistence.ExpenseRepository.USER_PARAM;

public interface YearlyHistoryRepository extends JpaRepository<YearlyHistory, HistoryId>, JpaSpecificationExecutor<YearlyHistory> {


    @Query("from YearlyHistory y where y.id.date = :year and y.id.category in " + GET_HOUSEHOLD_CATEGORIES)
    List<YearlyHistory> findAllByUserAndYear(@Param(USER_PARAM) User user, @Param("year") int year);

}
