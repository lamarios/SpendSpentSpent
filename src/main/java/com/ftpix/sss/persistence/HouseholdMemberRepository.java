package com.ftpix.sss.persistence;

import com.ftpix.sss.models.HouseholdInviteStatus;
import com.ftpix.sss.models.HouseholdMember;
import com.ftpix.sss.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface HouseholdMemberRepository extends JpaRepository<HouseholdMember, UUID> {
    List<HouseholdMember> findAllByUser(User user);

    List<HouseholdMember> findAllByUserAndStatus(User user, HouseholdInviteStatus status);
}
