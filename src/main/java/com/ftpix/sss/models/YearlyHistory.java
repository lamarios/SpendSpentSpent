package com.ftpix.sss.models;

import com.ftpix.sss.dao.HasCategory;

import java.util.UUID;

public class YearlyHistory implements HasCategory {

    private Category category;

    private double total;

    private int date;

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
