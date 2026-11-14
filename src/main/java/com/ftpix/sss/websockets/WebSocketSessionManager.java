package com.ftpix.sss.websockets;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.ftpix.sss.models.WebSocketMessage;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.ConcurrentWebSocketSessionDecorator;

public class WebSocketSessionManager {
  private static final Logger log = LogManager.getLogger();
  // sends to a session are serialized, Tomcat fails when sending while another message is still
  // being sent
  private static final int SEND_TIME_LIMIT_MS = 10_000;
  private static final int SEND_BUFFER_LIMIT_BYTES = 512 * 1024;
  // per user: session -> the same session with serialized sends
  private static final Map<String, Map<WebSocketSession, WebSocketSession>> sessions =
      new ConcurrentHashMap<>();
  private static final ObjectMapper objectMapper = new ObjectMapper();

  static {
    objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
  }

  /**
   * @return the session to send messages to
   */
  public static WebSocketSession register(String userId, WebSocketSession session) {
    WebSocketSession concurrent =
        new ConcurrentWebSocketSessionDecorator(
            session, SEND_TIME_LIMIT_MS, SEND_BUFFER_LIMIT_BYTES);
    // atomically, the last disconnect of the user removes the map in between otherwise
    sessions.compute(
        userId,
        (id, userSessions) -> {
          Map<WebSocketSession, WebSocketSession> result =
              userSessions == null ? new ConcurrentHashMap<>() : userSessions;
          result.put(session, concurrent);
          return result;
        });
    return concurrent;
  }

  public static void remove(String userId, WebSocketSession session) {
    sessions.computeIfPresent(
        userId,
        (id, userSessions) -> {
          userSessions.remove(session);
          if (userSessions.isEmpty()) {
            log.info("No more sessions for user {}, removing from map", userId);
            return null;
          }
          return userSessions;
        });
  }

  public static <T> void sendToUser(String userId, T content) {
    Map<WebSocketSession, WebSocketSession> userSessions = sessions.get(userId);
    if (userSessions != null) {
      userSessions.values().forEach(session -> sendToSession(session, content));
    }
  }

  /**
   * Failures are logged, sending is best effort and must not fail what triggered it (e.g. an
   * already committed change).
   */
  public static <T> void sendToSession(WebSocketSession session, T content) {
    if (session != null && session.isOpen()) {
      WebSocketMessage<T> message = new WebSocketMessage<T>();
      message.setType(WebSocketMessage.Type.getFromClass(content.getClass()));
      message.setMessage(content);

      try {
        session.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));
      } catch (IOException | RuntimeException e) {
        log.error("Error sending message:", e);
      }
    }
  }
}
