package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.security.JwtAuthenticationController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.fail;


@Import(TestConfig.class)
public class UserSessionControllerTest extends TestContainerTest {

    @Autowired
    private JwtAuthenticationController jwtAuthenticationController;

    @Test
    public void testLogin() throws Exception {

        final UserSessionController.UserCredentials userCredentials = new UserSessionController.UserCredentials();
        userCredentials.password = "pass";
        userCredentials.email = "test@example.org";
        assertNotNull(jwtAuthenticationController.generateAuthenticationToken(userCredentials));

        try {
            userCredentials.email = "wrong user";
            jwtAuthenticationController.generateAuthenticationToken(userCredentials);
            fail();
        } catch (BadCredentialsException e) {
            e.printStackTrace();
        }

        try {
            userCredentials.email = "lamarios";
            userCredentials.password = "Wrong password";
            jwtAuthenticationController.generateAuthenticationToken(userCredentials);
            fail();
        } catch (BadCredentialsException e) {
            e.printStackTrace();
        }

    }

}
