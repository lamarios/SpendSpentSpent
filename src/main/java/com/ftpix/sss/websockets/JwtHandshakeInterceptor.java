package com.ftpix.sss.websockets;

import com.ftpix.sss.security.JwtTokenUtil;
import com.ftpix.sss.services.UserService;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.net.URI;
import java.util.Map;


@Component
public class JwtHandshakeInterceptor implements HandshakeInterceptor {

    private final JwtTokenUtil jwtTokenUtil;
    private final UserService userService;

    public JwtHandshakeInterceptor(JwtTokenUtil jwtTokenUtil, UserService userService) {
        this.jwtTokenUtil = jwtTokenUtil;
        this.userService = userService;
    }


    @Override
    public boolean beforeHandshake(ServerHttpRequest request,
                                   ServerHttpResponse response,
                                   WebSocketHandler wsHandler,
                                   Map<String, Object> attributes) {
        String token = null;
        URI uri = request.getURI();
        String query = uri.getQuery(); // e.g. "token=abc123"
        if (query != null) {
            for (String param : query.split("&")) {
                String[] kv = param.split("=");
                if (kv.length == 2 && kv[0].equals("token")) {
                    token = kv[1];
                    break;
                }
            }
        }

        if (token != null && !token.isEmpty()) {
            try {
                String email = jwtTokenUtil.getUsernameFromToken(token);
                String userId = userService.getByEmail(email).getId().toString();
                attributes.put("userId", userId);
                return true;
            } catch (Exception e) {
                return false;
            }
        }
        return false;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request,
                               ServerHttpResponse response,
                               WebSocketHandler wsHandler,
                               Exception ex) {
    }
}
