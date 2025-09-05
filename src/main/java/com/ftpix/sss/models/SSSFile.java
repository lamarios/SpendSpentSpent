package com.ftpix.sss.models;

import java.util.List;
import java.util.UUID;

public class SSSFile {
    private UUID id = UUID.randomUUID();
    private UUID userId;
    private Long expenseId;
    private AiProcessingStatus status;
    private List<String> aiTags;
    private List<Double> amounts;
    private String fileName;
    private long timeCreated;
    private long timeUpdated;


    public AiProcessingStatus getStatus() {
        return status;
    }

    public String getEncryptedFileName(){
        return id.toString()+".bin";
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

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public Long getExpenseId() {
        return expenseId;
    }

    public void setExpenseId(Long expenseId) {
        this.expenseId = expenseId;
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
}
