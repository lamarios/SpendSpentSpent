package com.ftpix.sss.models;

import com.ftpix.sss.dao.HasCategory;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.UUID;

@DatabaseTable(tableName = "YEARLY_HISTORY")
public class YearlyHistory implements HasCategory {

    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private UUID id = UUID.randomUUID();

    @DatabaseField(columnName = "CATEGORY_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 3, foreignColumnName = "ID", uniqueIndexName = "yearly_history_unique")
    private Category category;

    @DatabaseField(columnName = "TOTAL")
    private double total;

    // date will be of format YYYY for easy comparison / sorting
    @DatabaseField(columnName = "DATE", indexName = "yearly_history_date_idx", uniqueIndexName = "yearly_history_unique")
    private int date;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    @Override
    public Category getCategory() {
        return category;
    }

    @Override
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
