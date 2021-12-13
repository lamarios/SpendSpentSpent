package com.ftpix.sss.models;

import com.ftpix.sss.dao.HasCategory;
import com.ftpix.sss.utils.JsonIgnore;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "CATEGORY")
public class Category implements HasCategory {


    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private Long id;

    @DatabaseField(columnName = "ICON")
    private String icon;

    @DatabaseField(columnName = "CATEGORY_ORDER")
    private int categoryOrder;


    @DatabaseField(columnName = "USER_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 3, foreignColumnName = "ID")
    @JsonIgnore
    private User user;

    private double percentageOfMonthly = 0;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
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

    public double getPercentageOfMonthly() {
        return percentageOfMonthly;
    }

    public void setPercentageOfMonthly(double percentageOfMonthly) {
        this.percentageOfMonthly = percentageOfMonthly;
    }

    @Override
    public Category getCategory() {
        return this;
    }

    @Override
    public void setCategory(Category category) {

    }
}
