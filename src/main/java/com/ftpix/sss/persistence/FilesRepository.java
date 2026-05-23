package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Expense;
import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

public interface FilesRepository extends JpaRepository<SSSFile, UUID> {
    List<SSSFile> findByTimeCreatedBefore(long timeCreatedBefore);

    SSSFile findFirstById(UUID id);

    SSSFile findFirstByFileName(String fileName);

    SSSFile findFirstByIdAndUser(UUID id, User user);

    SSSFile findFirstByIdAndUserIn(UUID id, List<User> users);

    List<SSSFile> findAllByExpenseIn(Collection<Expense> expenses);
}
