package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.SettingsService;
import com.google.gson.Gson;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.context.SecurityContext;

import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

@Import(TestConfig.class)
public class SettingsControllerTest extends TestContainerTest {

    @Autowired
    private SettingsController settingsController;

    @Autowired
    private SettingsService settingsService;

    @Autowired
    private Gson gson;


    @BeforeEach
    public void setupSecurityContext() {
        User user = new User("test", "test", List.of(new SimpleGrantedAuthority("ROLE_ADMIN")));
        Authentication authentication = new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());

        SecurityContext securityContext = Mockito.mock(SecurityContext.class);
        Mockito.when(securityContext.getAuthentication()).thenReturn(authentication);
        SecurityContextHolder.setContext(securityContext);
    }


    @Test
    public void testSecretSetting() throws SQLException {
        Settings s = new Settings();
        s.setSecret(true);
        s.setValue("a");
        s.setName("a");

        settingsController.save(s);

        var saved = settingsController.get(s.getName());
        assertEquals(s.getValue(), saved.getValue());

        // now if we serialize it, it should be encrypted
        var json = gson.toJson(saved);
        var deserialized = gson.fromJson(json, Settings.class);

        assertNotEquals(s.getValue(), deserialized.getValue());
    }
}
