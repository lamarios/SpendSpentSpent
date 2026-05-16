package com.ftpix.sss.services;

import com.ftpix.sss.models.Settings;
import com.ftpix.sss.persistence.SettingsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.List;

@Service
public class SettingsService {
    public final static String OBFUSCATED_PASSWORD = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    private final SettingsRepository settingsRepository;

    @Autowired
    public SettingsService(SettingsRepository settingsRepository) {
        this.settingsRepository = settingsRepository;
    }


    @Transactional(readOnly = true)
    public List<Settings> getAll() throws SQLException {
        return settingsRepository.findAll();
    }

    @Transactional
    public boolean saveAll(List<Settings> settings) throws SQLException {
        for (Settings setting : settings) {
            save(setting);
        }

        return true;
    }

    @Transactional(readOnly = true)
    public Settings getByName(String name) throws SQLException {
        return settingsRepository.findFirstByName(name);
    }

    @Transactional
    public Settings save(Settings settings) throws SQLException {
        // value should not change
        if (settings.isSecret() && settings.getValue().equalsIgnoreCase(Encryption.encrypt(OBFUSCATED_PASSWORD))) {
            return settings;
        }

        settingsRepository.save(settings);
        return settings;
    }
}
