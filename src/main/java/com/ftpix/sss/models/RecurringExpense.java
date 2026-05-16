package com.ftpix.sss.models;

import com.ftpix.sss.persistence.utils.BooleanToIntConverter;
import com.ftpix.sss.persistence.utils.LocalDateConverter;
import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "recurring_expense")
public class RecurringExpense  {

    public static final int TYPE_DAILY = 0, TYPE_WEEKLY = 1, TYPE_MONTHLY = 2, TYPE_YEARLY = 3;


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    private int type;

    @Column(name = "type_param")
    private int typeParam;

    @Column(name = "last_occurrence")
    @Convert(converter = LocalDateConverter.class)
    private LocalDate lastOccurrence;

    @Column(name = "next_occurrence")
    @Convert(converter = LocalDateConverter.class)
    private LocalDate nextOccurrence;

    private double amount;

    @Convert(converter = BooleanToIntConverter.class)
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

    public LocalDate getLastOccurrence() {
        return lastOccurrence;
    }

    public void setLastOccurrence(LocalDate lastOccurrence) {
        this.lastOccurrence = lastOccurrence;
    }

    public LocalDate getNextOccurrence() {
        return nextOccurrence;
    }

    public void setNextOccurrence(LocalDate nextOccurrence) {
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
