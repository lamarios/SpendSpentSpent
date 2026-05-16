package com.ftpix.sss.models;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class HistoryId implements Serializable {


    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
    @Column(name = "date")
    private int date;

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    @Override
    public final boolean equals(Object o) {
        if (!(o instanceof HistoryId that)) return false;

        return date == that.date && Objects.equals(getCategory(), that.getCategory());
    }

    @Override
    public int hashCode() {
        int result = Objects.hashCode(getCategory());
        result = 31 * result + date;
        return result;
    }

    public int getDate() {
        return date;
    }

    public void setDate(int date) {
        this.date = date;
    }
}
