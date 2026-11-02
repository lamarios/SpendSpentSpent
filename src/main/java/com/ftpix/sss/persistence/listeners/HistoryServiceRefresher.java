package com.ftpix.sss.persistence.listeners;

import com.ftpix.sss.services.HistoryService;
import jakarta.persistence.PostPersist;
import jakarta.persistence.PostRemove;
import jakarta.persistence.PostUpdate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.Ordered;
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
        // one refresh per transaction is enough, no matter how many entities changed
        boolean alreadyScheduled = TransactionSynchronizationManager.getSynchronizations()
                .stream()
                .anyMatch(RefreshAfterCommit.class::isInstance);
        if (!alreadyScheduled) {
            TransactionSynchronizationManager.registerSynchronization(new RefreshAfterCommit());
        }
    }

    private static class RefreshAfterCommit implements TransactionSynchronization {
        @Override
        public void afterCommit() {
            historyService.refreshMaterializedViews();
        }

        @Override
        public int getOrder() {
            // before the clients are told to reload, see AfterCommitMessages
            return Ordered.HIGHEST_PRECEDENCE;
        }
    }
}
