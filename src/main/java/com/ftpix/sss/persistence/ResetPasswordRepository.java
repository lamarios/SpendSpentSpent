package com.ftpix.sss.persistence;

import com.ftpix.sss.models.ResetPassword;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ResetPasswordRepository extends JpaRepository<ResetPassword, UUID> {
    List<ResetPassword> findAllByExpiryDateBefore(long expiryDateBefore);
}
