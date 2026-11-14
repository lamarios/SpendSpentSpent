package com.ftpix.sss.websockets;

import static org.mockito.Mockito.*;

import com.ftpix.sss.models.NewHouseholdExpense;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.transaction.support.TransactionSynchronizationUtils;

public class AfterCommitMessagesTest {

  private record ExpenseChanged(long id) {}

  private void inTransaction(Runnable action) {
    TransactionSynchronizationManager.initSynchronization();
    try {
      action.run();
      TransactionSynchronizationUtils.triggerAfterCommit();
    } finally {
      TransactionSynchronizationManager.clearSynchronization();
    }
  }

  @Test
  public void equalMessagesAreSentOnceAndOthersAreKept() {
    try (MockedStatic<WebSocketSessionManager> manager =
        mockStatic(WebSocketSessionManager.class)) {
      inTransaction(
          () -> {
            AfterCommitMessages.sendToUsers(List.of("a"), new NewHouseholdExpense());
            AfterCommitMessages.sendToUsers(List.of("a", "b"), new NewHouseholdExpense());
            AfterCommitMessages.sendToUsers(List.of("a"), new ExpenseChanged(1));
            AfterCommitMessages.sendToUsers(List.of("a"), new ExpenseChanged(2));
            AfterCommitMessages.sendToUsers(List.of("a"), new ExpenseChanged(1));

            manager.verifyNoInteractions();
          });

      manager.verify(
          () -> WebSocketSessionManager.sendToUser("a", new NewHouseholdExpense()), times(1));
      manager.verify(
          () -> WebSocketSessionManager.sendToUser("b", new NewHouseholdExpense()), times(1));
      manager.verify(
          () -> WebSocketSessionManager.sendToUser("a", new ExpenseChanged(1)), times(1));
      manager.verify(
          () -> WebSocketSessionManager.sendToUser("a", new ExpenseChanged(2)), times(1));
      manager.verifyNoMoreInteractions();
    }
  }
}
