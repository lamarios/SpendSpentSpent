package com.ftpix.sss.persistence;

import com.ftpix.sss.models.ApiKey;
import com.ftpix.sss.models.User;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ApiKeyRepository extends JpaRepository<ApiKey, UUID> {
  List<ApiKey> findByUser(User user);

  List<ApiKey> findByApiKeyHash(String s);

  ApiKey findFirstByIdAndUser(UUID id, User user);

  void deleteApiKeyByIdAndUser(UUID id, User user);
}
