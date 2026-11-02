package com.ftpix.sss.websockets;

import com.ftpix.sss.models.NewHouseholdExpense;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.socket.WebSocketSession;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
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

    @Test
    @SuppressWarnings("unchecked")
    public void connectingWhileTheLastSessionDisconnectsKeepsTheNewSession() throws Exception {
        String userId = UUID.randomUUID().toString();
        WebSocketSession oldSession = mock(WebSocketSession.class);
        WebSocketSession newSession = mock(WebSocketSession.class);
        when(newSession.isOpen()).thenReturn(true);
        WebSocketSessionManager.register(userId, oldSession);

        // pauses the registration of the new session right when it is added to the user's sessions
        CountDownLatch registering = new CountDownLatch(1);
        CountDownLatch finishRegistering = new CountDownLatch(1);
        Map<String, Map<WebSocketSession, WebSocketSession>> registry = (Map<String, Map<WebSocketSession, WebSocketSession>>) ReflectionTestUtils.getField(WebSocketSessionManager.class, "sessions");
        Map<WebSocketSession, WebSocketSession> userSessions = new ConcurrentHashMap<>() {
            @Override
            public WebSocketSession put(WebSocketSession key, WebSocketSession value) {
                if (key == newSession) {
                    registering.countDown();
                    try {
                        assertTrue(finishRegistering.await(5, TimeUnit.SECONDS));
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                }
                return super.put(key, value);
            }
        };
        userSessions.putAll(registry.get(userId));
        registry.put(userId, userSessions);

        ExecutorService executor = Executors.newFixedThreadPool(2);
        try {
            Future<?> registration = executor.submit(() -> WebSocketSessionManager.register(userId, newSession));
            assertTrue(registering.await(5, TimeUnit.SECONDS));
            Future<?> disconnect = executor.submit(() -> WebSocketSessionManager.remove(userId, oldSession));
            Thread.sleep(300);
            finishRegistering.countDown();
            registration.get(5, TimeUnit.SECONDS);
            disconnect.get(5, TimeUnit.SECONDS);

            WebSocketSessionManager.sendToUser(userId, new NewHouseholdExpense());
            verify(newSession, times(1)).sendMessage(any());
        } finally {
            finishRegistering.countDown();
            executor.shutdownNow();
            WebSocketSessionManager.remove(userId, oldSession);
            WebSocketSessionManager.remove(userId, newSession);
        }
    }
}
