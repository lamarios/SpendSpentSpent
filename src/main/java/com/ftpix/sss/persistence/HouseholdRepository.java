package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Household;
import com.ftpix.sss.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

import static com.ftpix.sss.persistence.ExpenseRepository.USER_PARAM;

public interface HouseholdRepository extends JpaRepository<Household, UUID> {
    @Query("""
            SELECT hm.household FROM HouseholdMember hm
            WHERE hm.user = :user
            AND hm.status = com.ftpix.sss.models.HouseholdInviteStatus.accepted
            """)
    Household findHouseholdByUser(@Param(USER_PARAM) User user);

}
