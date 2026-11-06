package com.ftpix.sss.websockets;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Sends websocket messages once the current transaction is committed, so the clients reloading their data on a message
 * get the new state. Equal messages are sent once per transaction to each recipient, messages carrying data need to
 * implement equals.
 * <p>
 * Messages are sent after the other synchronizations with a higher precedence, like the refresh of the history views.
 */
public final class AfterCommitMessages {
    private static final Logger logger = LogManager.getLogger();

    private AfterCommitMessages() {
    }

    /**
     * @param userIds recipients, resolve them before the commit as entities can't be loaded anymore after it
     */
    public static void sendToUsers(Collection<String> userIds, Object message) {
        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            userIds.forEach(userId -> WebSocketSessionManager.sendToUser(userId, message));
            return;
        }

        Pending pending = TransactionSynchronizationManager.getSynchronizations()
                .stream()
                .filter(Pending.class::isInstance)
                .map(Pending.class::cast)
                .filter(p -> p.message.equals(message))
                .findFirst()
                .orElseGet(() -> {
                    Pending created = new Pending(message);
                    TransactionSynchronizationManager.registerSynchronization(created);
                    return created;
                });
        pending.recipients.addAll(userIds);
    }

    private static class Pending implements TransactionSynchronization {
        private final Object message;
        private final Set<String> recipients = new LinkedHashSet<>();

        private Pending(Object message) {
            this.message = message;
        }

        @Override
        public void afterCommit() {
            // the change is committed, a failing message must not make it look like it failed
            recipients.forEach(userId -> {
                try {
                    WebSocketSessionManager.sendToUser(userId, message);
                } catch (RuntimeException e) {
                    logger.error("Error notifying user {}", userId, e);
                }
            });
        }
    }
}
