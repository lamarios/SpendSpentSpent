package com.ftpix.sss.controllers.api;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.User;
import com.ftpix.sss.security.JwtAuthenticationController;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.utils.MockEmailService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;
import org.testcontainers.shaded.org.checkerframework.checker.units.qual.A;

import static org.junit.jupiter.api.Assertions.*;


@Import(TestConfig.class)
public class UserSessionControllerTest extends TestContainerTest {

    @Autowired
    private JwtAuthenticationController jwtAuthenticationController;

    @Autowired
    private UserSessionController userSessionController;

    @Autowired
    private EmailService emailService;

    @Autowired
    private User currentUser;


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


        assertThrows(BadCredentialsException.class, () -> {
            userCredentials.email = "lamarios";
            userCredentials.password = "Wrong password";
            jwtAuthenticationController.generateAuthenticationToken(userCredentials);
        });

    }

    @Test
    public void testResetPassword() {
        userSessionController.resetPasswordRequest("invalidEmail@email.com");

        MockEmailService mockMail = (MockEmailService) emailService;
        assertEquals(0, mockMail.getEmails().size());

        // if we try to reset the existing user email, we should have one email out
        userSessionController.resetPasswordRequest(currentUser.getEmail());
        var mail = mockMail.getEmails().poll();
        assertNotNull(mail);

        // our frontend somwhow sends payload with " before and after the email, making sure that this works as expected
        userSessionController.resetPasswordRequest("\""+currentUser.getEmail()+"\"");
        mail = mockMail.getEmails().poll();
        assertNotNull(mail);

    }

}
