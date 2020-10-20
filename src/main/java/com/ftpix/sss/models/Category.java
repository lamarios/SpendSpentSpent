package com.ftpix.sss.models;

import com.ftpix.sss.utils.JsonIgnore;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.misc.BaseDaoEnabled;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "CATEGORY")
public class Category extends BaseDaoEnabled {


    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private long id;

    @DatabaseField(columnName = "ICON")
    private String icon;

    @DatabaseField(columnName = "CATEGORY_ORDER")
    private int categoryOrder;


    @DatabaseField(columnName = "USER_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 3, foreignColumnName = "ID")
    @JsonIgnore
    private User user;

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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
