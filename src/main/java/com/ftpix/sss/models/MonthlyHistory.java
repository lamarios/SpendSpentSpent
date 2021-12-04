package com.ftpix.sss.models;


import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.UUID;

@DatabaseTable(tableName = "MONTHLY_HISTORY")
public class MonthlyHistory {

    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private UUID id = UUID.randomUUID();

    @DatabaseField(columnName = "CATEGORY_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 3, foreignColumnName = "ID",uniqueIndexName = "monthly_history_unique_idx")
    private Category category;

    @DatabaseField(columnName = "TOTAL")
    private double total;

    // date will be of format YYYYMM for easy comparison / sorting
    @DatabaseField(columnName = "DATE", indexName = "monthly_history_date_idx", uniqueIndexName = "monthly_history_unique_idx")
    private int date;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }
}
