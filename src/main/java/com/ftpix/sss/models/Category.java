package com.ftpix.sss.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ftpix.sss.persistence.listeners.HistoryServiceRefresher;
import jakarta.persistence.*;

import java.util.List;


@Entity
@Table(name = "category")
@EntityListeners({HistoryServiceRefresher.class})
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String icon;

    @Column(name = "category_order")
    private int categoryOrder;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Expense> expenses;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<RecurringExpense> recurringExpenses;


    @Transient
    private double percentageOfMonthly = 0;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public int getCategoryOrder() {
        return categoryOrder;
    }

    public void setCategoryOrder(int order) {
        this.categoryOrder = order;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public double getPercentageOfMonthly() {
        return percentageOfMonthly;
    }

    public void setPercentageOfMonthly(double percentageOfMonthly) {
        this.percentageOfMonthly = percentageOfMonthly;
    }
}
