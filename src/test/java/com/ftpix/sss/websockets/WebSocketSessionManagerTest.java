package com.ftpix.sss.websockets;

import com.ftpix.sss.models.NewHouseholdExpense;
import org.junit.jupiter.api.Test;
import org.springframework.web.socket.WebSocketSession;

import java.util.UUID;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class WebSocketSessionManagerTest {

    @Test
    public void sendsToTheSameSessionDontOverlap() throws Exception {
        String userId = UUID.randomUUID().toString();
        AtomicInteger sending = new AtomicInteger();
        AtomicInteger maxSending = new AtomicInteger();
        AtomicInteger sent = new AtomicInteger();
        CountDownLatch firstStarted = new CountDownLatch(1);
        WebSocketSession session = mock(WebSocketSession.class);
        when(session.isOpen()).thenReturn(true);
        doAnswer(invocation -> {
            maxSending.accumulateAndGet(sending.incrementAndGet(), Math::max);
            firstStarted.countDown();
            Thread.sleep(300);
            sending.decrementAndGet();
            sent.incrementAndGet();
            return null;
        }).when(session).sendMessage(any());

        WebSocketSessionManager.register(userId, session);
        ExecutorService executor = Executors.newFixedThreadPool(2);
        try {
            Future<?> first = executor.submit(() -> WebSocketSessionManager.sendToUser(userId, new NewHouseholdExpense()));
            firstStarted.await(5, TimeUnit.SECONDS);
            Future<?> second = executor.submit(() -> WebSocketSessionManager.sendToUser(userId, new NewHouseholdExpense()));
            first.get(5, TimeUnit.SECONDS);
            second.get(5, TimeUnit.SECONDS);

            assertEquals(1, maxSending.get());
            assertEquals(2, sent.get());
        } finally {
            WebSocketSessionManager.remove(userId, session);
            executor.shutdownNow();
        }
    }
}
