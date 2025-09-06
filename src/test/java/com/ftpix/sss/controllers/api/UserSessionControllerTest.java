package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.security.JwtAuthenticationController;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;

import static org.junit.jupiter.api.Assertions.*;


@Import(TestConfig.class)
public class UserSessionControllerTest extends TestContainerTest {

    @Autowired
    private JwtAuthenticationController jwtAuthenticationController;

    @Test
    public void testLogin() throws Exception {

        final UserSessionController.UserCredentials userCredentials = new UserSessionController.UserCredentials();
        userCredentials.password = "pass";
        userCredentials.email = "test@example.org";
        String actual = jwtAuthenticationController.generateAuthenticationToken(userCredentials);
        assertNotNull(actual);

        Assertions.assertThrows(BadCredentialsException.class, () -> {
            userCredentials.email = "wrong user";
            jwtAuthenticationController.generateAuthenticationToken(userCredentials);
        });


        assertThrows(BadCredentialsException.class,() -> {
            userCredentials.email = "lamarios";
            userCredentials.password = "Wrong password";
            jwtAuthenticationController.generateAuthenticationToken(userCredentials);
        });

    }

}
