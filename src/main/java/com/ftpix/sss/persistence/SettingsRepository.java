package com.ftpix.sss.persistence;

import com.ftpix.sss.models.Settings;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SettingsRepository extends JpaRepository<Settings, String> {
    Settings findFirstByName(String name);
}
