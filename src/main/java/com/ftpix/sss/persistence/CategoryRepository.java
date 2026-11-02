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
    String GET_HOUSEHOLD_CATEGORIES = " ( " + GET_HOUSEHOLD_CATEGORIES_INNER + " ) ";

    /**
     * Condition matching entries (alias e, expense or recurring expense) created by someone who isn't in the same household
     * as the owner of the entry's category anymore.
     */
    String CREATOR_OUTSIDE_CATEGORY_HOUSEHOLD = """
            e.user is not null and e.user <> e.category.user and not exists (
                SELECT m1 FROM HouseholdMember m1, HouseholdMember m2
                WHERE m1.user = e.user
                AND m2.user = e.category.user
                AND m1.household = m2.household
                AND m1.status = com.ftpix.sss.models.HouseholdInviteStatus.accepted
                AND m2.status = com.ftpix.sss.models.HouseholdInviteStatus.accepted
            )
            """;


    @Query(GET_HOUSEHOLD_CATEGORIES_INNER)
    List<Category> getHouseholdCategories(@Param(USER_PARAM) User user);

    @Query(GET_HOUSEHOLD_CATEGORIES_INNER + " order by c.categoryOrder asc, c.id asc")
    List<Category> getHouseholdCategoriesOrdered(@Param(USER_PARAM) User user);

    @Query("from Category cat where cat.id = :id and cat in " + GET_HOUSEHOLD_CATEGORIES)
    Category findHouseholdCategoryById(@Param("id") long id, @Param(USER_PARAM) User user);

    List<Category> findAllByUser(User user);

    @Query("select coalesce(max(cat.categoryOrder), 0) from Category cat where cat in " + GET_HOUSEHOLD_CATEGORIES)
    long getMaxHouseholdCategoryOrder(@Param(USER_PARAM) User user);


    /**
     * Saves a new category of the user, placed after all the categories of the user's household.
     */
    default Category saveAtEndOfHousehold(Category category, User user) {
        category.setUser(user);
        category.setCategoryOrder((int) getMaxHouseholdCategoryOrder(user) + 1);
        return save(category);
    }
}
