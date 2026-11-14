package com.ftpix.sss.websockets;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

public class WebSocketHandlerTest {

  @Test
  public void connectingClientsAreToldToReload() throws Exception {
    WebSocketSession session = mock(WebSocketSession.class);
    Map<String, Object> attributes = new HashMap<>();
    attributes.put("userId", UUID.randomUUID().toString());
    when(session.getAttributes()).thenReturn(attributes);
    when(session.isOpen()).thenReturn(true);

    WebSocketHandler handler = new WebSocketHandler();
    handler.afterConnectionEstablished(session);
    try {
      // they might have missed messages while disconnected, existing clients reload on
      // householdUpdate
      ArgumentCaptor<TextMessage> message = ArgumentCaptor.forClass(TextMessage.class);
      verify(session, times(1)).sendMessage(message.capture());
      assertEquals(
          "{\"type\":\"householdUpdate\",\"message\":{}}", message.getValue().getPayload());
    } finally {
      handler.afterConnectionClosed(session, CloseStatus.NORMAL);
    }
  }
}
