package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

import static com.ftpix.sss.persistence.ExpenseRepository.USER_PARAM;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    String GET_HOUSEHOLD_CATEGORIES_INNER = """
            from Category c where c.user = :user or c.user in (
                SELECT hm.user FROM HouseholdMember hm
                                   WHERE hm.household IN (
                                       SELECT hm2.household FROM HouseholdMember hm2
                                       WHERE hm2.user = :user
                                       AND hm2.status = com.ftpix.sss.models.HouseholdInviteStatus.accepted
                                   )
                                   AND hm.status = com.ftpix.sss.models.HouseholdInviteStatus.accepted
                                   AND hm.user <> :user
                )
            """;
    String GET_USER_CATEGORIES = "(from Category c where c.user = :user)";
    String GET_HOUSEHOLD_CATEGORIES = " ( " + GET_HOUSEHOLD_CATEGORIES_INNER + " ) ";


    @Query(GET_HOUSEHOLD_CATEGORIES_INNER)
    List<Category> getHouseholdCategories(@Param(USER_PARAM) User user);

    List<Category> findAllByUser(User user);

    Category findFirstByIdAndUser(Long id, User user);

    @Query("select coalesce(max(categoryOrder), 0) from Category where user = :user")
    long getMaxCategoryOrder(@Param(USER_PARAM) User user);


}
