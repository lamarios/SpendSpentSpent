package com.ftpix.sss.models;

/**
 * Chass to represent how many months and years of expenses we have
 */
public class ExpenseLimits {
    int years, months;

    public ExpenseLimits(int years, int months) {
        this.years = years;
        this.months = months;
    }

    public int getYears() {
        return years;
    }

    public void setYears(int years) {
        this.years = years;
    }

    public int getMonths() {
        return months;
    }

    public void setMonths(int months) {
        this.months = months;
    }
}
