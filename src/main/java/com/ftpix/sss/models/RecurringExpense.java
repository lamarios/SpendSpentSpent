package com.ftpix.sss.models;

import com.ftpix.sss.dao.HasCategory;

import java.util.Date;

public class RecurringExpense implements HasCategory {

    public static final int TYPE_DAILY = 0, TYPE_WEEKLY = 1, TYPE_MONTHLY = 2, TYPE_YEARLY = 3;


    private Long id;

    private String name;

    private Category category;

    private int type;

    private int typeParam;

    private Date lastOccurrence;

    private Date nextOccurrence;

    private double amount;

    private boolean income = false;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
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
