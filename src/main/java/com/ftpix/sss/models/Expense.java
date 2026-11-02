package com.ftpix.sss.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ftpix.sss.persistence.listeners.HistoryServiceRefresher;
import com.ftpix.sss.persistence.utils.BooleanToIntConverter;
import com.ftpix.sss.persistence.utils.LocalDateConverter;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "expense")
@EntityListeners({HistoryServiceRefresher.class})
public class Expense  {

    public static final int TYPE_NORMAL = 1, TYPE_RECURRENT = 2;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private double amount;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    /**
     * Who created the expense. Categories can be shared within a household, so the category owner isn't necessarily
     * the person who spent the money.
     */
    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private User user;

    @Convert(converter = LocalDateConverter.class)
    private LocalDate date;

    private int type = 1;

    @Convert(converter = BooleanToIntConverter.class)
    private boolean income = false;

    private Double latitude;

    private Double longitude;

    private String note;

    private String time;

    private long timestamp = System.currentTimeMillis();

    @Column(name = "timecreated")
    private Long timeCreated= System.currentTimeMillis();

    @OneToMany(mappedBy = "expense", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SSSFile> files = new ArrayList<>();


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    @Deprecated
    public LocalDate getDate() {
        return date;
    }

    @Deprecated
    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public boolean isIncome() {
        return income;
    }

    public void setIncome(boolean income) {
        this.income = income;
    }

    @JsonIgnore
    public Category getCategory() {
        return category;
    }

    @JsonProperty("category")
    public void setCategory(Category category) {
        this.category = category;
    }

    /**
     * Clients use category.user to show which household member an expense belongs to. As categories are shared within
     * a household, the category owner isn't necessarily who spent the money, so clients get a copy of the category
     * where the user is the creator of the expense.
     */
    @JsonProperty("category")
    public Category getCategoryForClients() {
        if (category == null || user == null) {
            return category;
        }

        Category copy = new Category();
        copy.setId(category.getId());
        copy.setIcon(category.getIcon());
        copy.setCategoryOrder(category.getCategoryOrder());
        copy.setPercentageOfMonthly(category.getPercentageOfMonthly());
        copy.setUser(user);
        return copy;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    @Deprecated
    public String getTime() {
        return time;
    }

    @Deprecated
    public void setTime(String time) {
        this.time = time;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public List<SSSFile> getFiles() {
        return files;
    }

    public void setFiles(List<SSSFile> files) {
        this.files = files;
    }

    public Long getTimeCreated() {
        return timeCreated;
    }

    public void setTimeCreated(Long timeCreated) {
        this.timeCreated = timeCreated;
    }
}
