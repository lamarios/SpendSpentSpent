package com.ftpix.sss.models;


import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import org.hibernate.annotations.Immutable;

@Entity
@Table(name = "monthly_history")
@Immutable
public class MonthlyHistory {

    @EmbeddedId
    private HistoryId id;


    private double total;


    public Category getCategory() {
        return id.getCategory();
    }

    public void setCategory(Category category) {
        if (id == null) {
            id = new HistoryId();
        }

        id.setCategory(category);
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getDate() {
        return id.getDate();
    }

    public void setDate(int date) {
        if (id == null) {
            id = new HistoryId();
        }
        id.setDate(date);
    }

    public HistoryId getId() {
        return id;
    }

    public void setId(HistoryId id) {
        this.id = id;
    }
}
