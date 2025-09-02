package com.ftpix.sss.websockets;

import com.ftpix.sss.models.WebSocketMessage;
import com.google.gson.Gson;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

public class WebSocketSessionManager {
    private final static Logger log = LogManager.getLogger();
    private static final Map<String, List<WebSocketSession>> sessions = new ConcurrentHashMap<>();

    public static void register(String userId, WebSocketSession session) {
        sessions.putIfAbsent(userId, new ArrayList<>());
        sessions.get(userId).add(session);
    }

    public static void remove(String userId, WebSocketSession session) {
        var userSessions = sessions.get(userId);
        userSessions.remove(session);
        if (userSessions.isEmpty()) {
            log.info("No more sessions for user {}, removing from map", userId);
            sessions.remove(userId);
        }
    }

    public static <T> void sendToUser(String userId, T content) {
        Gson gson = new Gson();

        WebSocketMessage<T> message = new WebSocketMessage<T>();
        message.setType(WebSocketMessage.Type.getFromClass(content.getClass()));
        message.setMessage(content);

        if (sessions.containsKey(userId)) {
            List<WebSocketSession> userSessions = sessions.get(userId);
            for (WebSocketSession session : userSessions) {
                if (session != null && session.isOpen()) {
                    try {
                        session.sendMessage(new TextMessage(gson.toJson(message)));
                    } catch (IOException e) {
                        log.error("Error sending message:", e);
                    }
                }
            }
        }
    }
}

