package com.ftpix.sss.models;

import com.ftpix.sss.services.Encryption;
import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "SETTINGS")
public class Settings {
    public static final String CURRENCY_API_KEY = "currencyApiKey";


    @DatabaseField(columnName = "NAME", id = true)
    private String name;

    @DatabaseField(columnName = "VALUE", dataType = DataType.LONG_STRING)
    private String value;

    @DatabaseField(columnName = "SECRET", defaultValue = "false")
    private boolean secret;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRealValue() {
        if (secret) {
            return Encryption.decrypt(value);
        } else {
            return value;
        }
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public boolean isSecret() {
        return secret;
    }

    public void setSecret(boolean secret) {
        this.secret = secret;
    }
}
