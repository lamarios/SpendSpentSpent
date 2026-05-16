package com.ftpix.sss.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ftpix.sss.persistence.listeners.FileListener;
import com.ftpix.sss.persistence.utils.CsvToListConverter;
import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.List;
import java.util.UUID;


@Entity
@Table(name = "files")
@EntityListeners({FileListener.class})
public class SSSFile {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @JdbcTypeCode(SqlTypes.VARCHAR)
    private UUID id;

    @Enumerated(EnumType.STRING)
    private AiProcessingStatus status;
    @Convert(converter = CsvToListConverter.class)
    @Column(name = "ai_tags")
    private List<String> aiTags;
    @Convert(converter = CsvToListConverter.class)
    private List<Double> amounts;
    private String fileName;

    @Column(name = "time_created")
    private long timeCreated;
    @Column(name = "time_updated")
    private long timeUpdated;


    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User user;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "expense_id")
    private Expense expense;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }


    public AiProcessingStatus getStatus() {
        return status;
    }

    @Transient
    public String getEncryptedFileName() {
        return id.toString() + ".bin";
    }

    public void setStatus(AiProcessingStatus status) {
        this.status = status;
    }

    public List<String> getAiTags() {
        return aiTags;
    }

    public void setAiTags(List<String> aiTags) {
        this.aiTags = aiTags;
    }

    public long getTimeCreated() {
        return timeCreated;
    }

    public void setTimeCreated(long timeCreated) {
        this.timeCreated = timeCreated;
    }

    public long getTimeUpdated() {
        return timeUpdated;
    }

    public void setTimeUpdated(long timeUpdated) {
        this.timeUpdated = timeUpdated;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public List<Double> getAmounts() {
        return amounts;
    }

    public void setAmounts(List<Double> amounts) {
        this.amounts = amounts;
    }

    public Expense getExpense() {
        return expense;
    }

    public void setExpense(Expense expense) {
        this.expense = expense;
    }


}
