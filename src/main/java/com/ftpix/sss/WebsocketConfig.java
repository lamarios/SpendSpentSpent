package com.ftpix.sss;

import com.ftpix.sss.websockets.JwtHandshakeInterceptor;
import com.ftpix.sss.websockets.WebSocketHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebsocketConfig implements WebSocketConfigurer {
    private final JwtHandshakeInterceptor jwtHandshakeInterceptor;
    private final WebSocketHandler customWebSocketHandler;

    public WebsocketConfig(JwtHandshakeInterceptor jwtHandshakeInterceptor,
                           WebSocketHandler customWebSocketHandler) {
        this.jwtHandshakeInterceptor = jwtHandshakeInterceptor;
        this.customWebSocketHandler = customWebSocketHandler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(customWebSocketHandler, "/ws")
                .addInterceptors(jwtHandshakeInterceptor)
                .setAllowedOrigins("*"); // TODO: tighten in prod
    }
}
