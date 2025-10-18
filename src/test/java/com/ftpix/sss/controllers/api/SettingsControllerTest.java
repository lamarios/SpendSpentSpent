package com.ftpix.sss.controllers.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Settings;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;

import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

@Import(TestConfig.class)
public class SettingsControllerTest extends TestContainerTest {

    @Autowired
    private SettingsController settingsController;

    @Autowired
    private ObjectMapper objectMapper;


    @BeforeEach
    public void setupSecurityContext() {
        User user = new User("test", "test", List.of(new SimpleGrantedAuthority("ROLE_ADMIN")));
        Authentication authentication = new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());

        SecurityContext securityContext = Mockito.mock(SecurityContext.class);
        Mockito.when(securityContext.getAuthentication()).thenReturn(authentication);
        SecurityContextHolder.setContext(securityContext);
    }


    @Test
    public void testSecretSetting() throws SQLException, JsonProcessingException {
        Settings s = new Settings();
        s.setSecret(true);
        s.setValue("aa");
        s.setName("a");

        settingsController.save(s);

        var saved = settingsController.get(s.getName());
        assertEquals(s.getValue(), saved.getValue());

        // now if we serialize it, it should be encrypted
        var json = objectMapper.writeValueAsString(saved);
        var deserialized = objectMapper.readValue(json, Settings.class);

        assertNotEquals(s.getValue(), deserialized.getValue());
    }
}
