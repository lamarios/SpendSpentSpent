package com.ftpix.sss.models;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "CATEGORY")
public class Category {


    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private long id;

    @DatabaseField(columnName = "ICON")
    private String icon;

    @DatabaseField(columnName = "CATEGORY_ORDER")
    private int categoryOrder;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public int getCategoryOrder() {
        return categoryOrder;
    }

    public void setCategoryOrder(int order) {
        this.categoryOrder = order;
    }

}
