package com.ftpix.sss.models;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

@DatabaseTable(tableName = "EXPENSE")
public class Expense {

    public static final int TYPE_NORMAL = 1, TYPE_RECURRENT = 2;

    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private long id;

    @DatabaseField(columnName = "AMOUNT")
    private double amount;

    @DatabaseField(columnName = "CATEGORY_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 3, foreignColumnName = "ID")
    private Category category;


    @DatabaseField(columnName = "DATE", dataType = DataType.DATE_STRING, format = "yyyy-MM-dd")
    private Date date;

    @DatabaseField(columnName = "TYPE")
    private int type = 1;

    @DatabaseField(columnName = "INCOME")
    private boolean income = false;

    @DatabaseField(columnName = "LATITUDE")
    private double latitude;

    @DatabaseField(columnName = "LONGITUDE")
    private double longitude;

    @DatabaseField(columnName = "NOTE", dataType = DataType.LONG_STRING)
    private String note;

    @DatabaseField(columnName = "TIME", dataType = DataType.STRING, width = 5)
    private String time;

    @DatabaseField(columnName = "TIMESTAMP")
    private long timestamp = System.currentTimeMillis();

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public boolean isIncome() {
        return income;
    }

    public void setIncome(boolean income) {
        this.income = income;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
}
