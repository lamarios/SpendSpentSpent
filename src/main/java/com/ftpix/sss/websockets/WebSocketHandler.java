package com.ftpix.sss.websockets;

import com.ftpix.sss.models.HouseholdWebsocketUpdate;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class WebSocketHandler extends TextWebSocketHandler {
  private static final Logger log = LogManager.getLogger();

  @Override
  public void afterConnectionEstablished(WebSocketSession session) {
    String userId = (String) session.getAttributes().get("userId");
    WebSocketSession registered = WebSocketSessionManager.register(userId, session);
    log.info("User connected: {}", userId);

    // Clients disconnect while in the background and miss what other household members did
    // meanwhile.
    // This makes them reload the household data, expenses and history (existing clients already do
    // so).
    WebSocketSessionManager.sendToSession(registered, new HouseholdWebsocketUpdate());
  }

  @Override
  protected void handleTextMessage(WebSocketSession session, TextMessage message) {
    // If you don’t want client messages, ignore this
    log.info("Received from client: {}", message.getPayload());
  }

  @Override
  public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
    String userId = (String) session.getAttributes().get("userId");
    WebSocketSessionManager.remove(userId, session);
    log.info("User disconnected: {}", userId);
  }
}
