package com.ftpix.sss.models;

import com.google.gson.annotations.Expose;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "SETTING")
public class Setting {
    public static final String PASSWORD = "password", USERNAME = "username", PUSHBULLET = "pushbullet", PUSHBULLET_API = "pushbulletapi", AUTHENTICATION = "authentication", PUSHALOT = "pushalot", PUSHALOTAPI = "pushalotApi", WINDOWS_TILE = "windowsTile", PUSHOVER = "pushover", PUSHOVER_APP_TOKEN = "pushoverAppToken", PUSHOVER_USER_TOKEN = "pushoverUserToken", GOOGLE_MAP = "googlemap";


    @DatabaseField(columnName = "NAME", id = true)
    private String name;

    @DatabaseField(columnName = "VALUE")
    private String value;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
