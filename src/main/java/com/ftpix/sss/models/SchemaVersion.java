package com.ftpix.sss.models;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "SCHEMA_VERSION")
public class SchemaVersion {

    @DatabaseField(columnName = "CURRENT", generatedId = true, allowGeneratedIdInsert = true)
    private int current;

    public SchemaVersion() {
    }

    public SchemaVersion(int current) {
        this.current = current;
    }

    public int getCurrent() {

        return current;
    }

    public void setCurrent(int current) {
        this.current = current;
    }
}
