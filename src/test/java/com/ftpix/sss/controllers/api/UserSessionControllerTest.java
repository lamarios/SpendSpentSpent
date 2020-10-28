package com.ftpix.sss.controllers.api;

import com.ftpix.sss.App;
import com.ftpix.sss.TestConfig;
import com.ftpix.sss.security.JwtAuthenticationController;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

@SpringBootTest(classes = App.class)
@RunWith(SpringJUnit4ClassRunner.class)
@Import(TestConfig.class)
public class UserSessionControllerTest {

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
