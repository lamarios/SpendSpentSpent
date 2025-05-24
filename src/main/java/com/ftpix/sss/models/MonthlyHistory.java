package com.ftpix.sss.models;


import com.ftpix.sss.dao.HasCategory;

import java.util.UUID;

public class MonthlyHistory implements HasCategory {

    private UUID id = UUID.randomUUID();

    private Category category;

    private double total;

    // date will be of format YYYYMM for easy comparison / sorting
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
