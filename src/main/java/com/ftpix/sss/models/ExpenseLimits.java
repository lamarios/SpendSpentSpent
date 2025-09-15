package com.ftpix.sss.models;

/**
 * Chass to represent how many months and years of expenses we have
 */
public class ExpenseLimits {
    long years, months;

    public ExpenseLimits(long years, long months) {
        this.years = years;
        this.months = months;
    }

    public long getYears() {
        return years;
    }

    public void setYears(long years) {
        this.years = years;
    }

    public long getMonths() {
        return months;
    }

    public void setMonths(long months) {
        this.months = months;
    }
}
