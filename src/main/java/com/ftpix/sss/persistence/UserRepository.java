package com.ftpix.sss.persistence;

import com.ftpix.sss.models.User;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, UUID>, JpaSpecificationExecutor<User> {

  @Query("from User u where u.email = :email")
  User findFirstByEmail(@Param("email") String email);

  @Query("from User u where u.oidcSub = :sub")
  User findFirstByOidcSub(@Param("sub") String oidcSub);

  User findFirstById(UUID id);

  long countByEmail(String email);

  /** Local (non-OIDC) users with no usable password, e.g. legacy MD5 users after V12. */
  List<User> findAllByPasswordBcryptIsNullAndOidcSubIsNull();
}
