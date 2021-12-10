package com.ftpix.sss.dao;

import com.ftpix.sss.dsl.Tables;
import com.ftpix.sss.models.Settings;
import org.jooq.Condition;
import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

import static com.ftpix.sss.dsl.Tables.*;

@Component("settingsDaoJooq")
public class SettingsDao {
    private final DSLContext dslContext;

    @Autowired
    public SettingsDao(DSLContext dslContext) {
        this.dslContext = dslContext;
    }

    public List<Settings> getWhere() {
        return dslContext.select().from(SETTINGS)
                .fetch(r -> r.into(Settings.class));
    }

    public Settings createOrUpdate(Settings settings) {
        dslContext.insertInto(SETTINGS,
                        SETTINGS.NAME,
                        SETTINGS.VALUE,
                        SETTINGS.SECRET)
                .values(settings.getName(),
                        settings.getValue(),
                        (byte) (settings.isSecret() ? 1 : 0))
                .onDuplicateKeyUpdate()
                .set(SETTINGS.VALUE, settings.getValue())
                .execute();


        return settings;
    }

    public Settings queryForId(String name) {
        return dslContext.select().from(SETTINGS)
                .where(SETTINGS.NAME.eq(name))
                .fetchOne(r -> r.into(Settings.class));
    }
}
