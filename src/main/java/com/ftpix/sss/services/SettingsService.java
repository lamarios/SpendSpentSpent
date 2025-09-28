package com.ftpix.sss.services;

import com.ftpix.sss.dao.SettingsDao;
import com.ftpix.sss.models.Settings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.util.List;

@Service
public class SettingsService {
    public final static String OBFUSCATED_PASSWORD = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    private final SettingsDao settingsDaoJooq;

    @Autowired
    public SettingsService(SettingsDao settingsDaoJooq) {
        this.settingsDaoJooq = settingsDaoJooq;
    }


    @Transactional(readOnly = true)
    public List<Settings> getAll() throws SQLException {
        return settingsDaoJooq.getWhere();
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
        return settingsDaoJooq.queryForId(name);
    }

    @Transactional
    public Settings save(Settings settings) throws SQLException {
        // value should not change
        if (settings.isSecret() && settings.getValue().equalsIgnoreCase(Encryption.encrypt(OBFUSCATED_PASSWORD))) {
            return settings;
        }

        settingsDaoJooq.createOrUpdate(settings);
        return settings;
    }
}
