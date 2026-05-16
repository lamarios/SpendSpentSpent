package com.ftpix.sss.persistence.listeners;

import com.ftpix.sss.services.HistoryService;
import jakarta.persistence.PostPersist;
import jakarta.persistence.PostRemove;
import jakarta.persistence.PostUpdate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

@Component
public class HistoryServiceRefresher {

    private static HistoryService historyService;

    @Autowired
    public void setHistoryService(HistoryService historyService){
        HistoryServiceRefresher.historyService = historyService;
    }

    @PostPersist
    @PostUpdate
    @PostRemove
    public void onChanged(Object entity){
        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCommit() {
                historyService.refreshMaterializedViews();
            }
        });
    }
}
