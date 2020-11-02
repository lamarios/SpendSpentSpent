package com.ftpix.sss.models;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.misc.BaseDaoEnabled;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

@DatabaseTable(tableName = "RECURRING_EXPENSE")
public class RecurringExpense extends BaseDaoEnabled {

    public static final int TYPE_DAILY = 0, TYPE_WEEKLY = 1, TYPE_MONTHLY = 2, TYPE_YEARLY = 3;


    @DatabaseField(columnName = "ID", generatedId = true, allowGeneratedIdInsert = true)
    private long id;

    @DatabaseField(columnName = "NAME")
    private String name;

    @DatabaseField(columnName = "CATEGORY_ID", foreign = true, foreignAutoRefresh = true, maxForeignAutoRefreshLevel = 1, foreignColumnName = "ID")
    private Category category;

    @DatabaseField(columnName = "TYPE")
    private int type;

    @DatabaseField(columnName = "TYPE_PARAM")
    private int typeParam;

    @DatabaseField(columnName = "LAST_OCCURRENCE", dataType = DataType.DATE_STRING, format = "yyyy-MM-dd")
    private Date lastOccurrence;

    @DatabaseField(columnName = "NEXT_OCCURRENCE", dataType = DataType.DATE_STRING, format = "yyyy-MM-dd")
    private Date nextOccurrence;

    @DatabaseField(columnName = "AMOUNT")
    private double amount;

    @DatabaseField(columnName = "INCOME")
    private boolean income = false;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getTypeParam() {
        return typeParam;
    }

    public void setTypeParam(int typeParam) {
        this.typeParam = typeParam;
    }

    public Date getLastOccurrence() {
        return lastOccurrence;
    }

    public void setLastOccurrence(Date lastOccurrence) {
        this.lastOccurrence = lastOccurrence;
    }

    public Date getNextOccurrence() {
        return nextOccurrence;
    }

    public void setNextOccurrence(Date nextOccurrence) {
        this.nextOccurrence = nextOccurrence;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public boolean isIncome() {
        return income;
    }

    public void setIncome(boolean income) {
        this.income = income;
    }

}
