package com.ftpix.sss.services;

import com.ftpix.sss.dao.SettingsDao;
import com.ftpix.sss.models.Settings;
import com.j256.ormlite.dao.Dao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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


    public List<Settings> getAll() throws SQLException {
        return settingsDaoJooq.getWhere();
    }

    public boolean saveAll(List<Settings> settings) throws SQLException {
        for (Settings setting : settings) {
            save(setting);
        }

        return true;
    }

    public Settings getByName(String name) throws SQLException {
        return settingsDaoJooq.queryForId(name);
    }

    public Settings save(Settings settings) throws SQLException {
        // value should not change
        if (settings.isSecret() && settings.getValue().equalsIgnoreCase(Encryption.encrypt(OBFUSCATED_PASSWORD))) {
            return settings;
        }

        settingsDaoJooq.createOrUpdate(settings);
        return settings;
    }
}
