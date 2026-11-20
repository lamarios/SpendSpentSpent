package com.ftpix.sss.controllers.api;

import static org.junit.jupiter.api.Assertions.*;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ResetPasswordRepository;
import com.ftpix.sss.security.JwtAuthenticationController;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.utils.MockEmailService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;

@Import(TestConfig.class)
public class UserSessionControllerTest extends TestContainerTest {

  @Autowired private JwtAuthenticationController jwtAuthenticationController;

  @Autowired private UserSessionController userSessionController;

  @Autowired private EmailService emailService;

  @Autowired private ResetPasswordRepository resetPasswordRepository;

  @Test
  public void testLogin() throws Exception {

    final UserSessionController.UserCredentials userCredentials =
        new UserSessionController.UserCredentials();
    userCredentials.password = "pass";
    userCredentials.email = currentUser.getEmail();
    String actual = jwtAuthenticationController.generateAuthenticationToken(userCredentials);
    assertNotNull(actual);

    Assertions.assertThrows(
        BadCredentialsException.class,
        () -> {
          userCredentials.email = "wrong user";
          jwtAuthenticationController.generateAuthenticationToken(userCredentials);
        });

    assertThrows(
        BadCredentialsException.class,
        () -> {
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

    // our frontend somwhow sends payload with " before and after the email, making sure that this
    // works as expected
    userSessionController.resetPasswordRequest("\"" + currentUser.getEmail() + "\"");
    mail = mockMail.getEmails().poll();
    assertNotNull(mail);
  }

  @Test
  public void testResetPasswordWithoutSmtp() {
    MockEmailService mockMail = (MockEmailService) emailService;
    mockMail.getEmails().clear();
    mockMail.setEnabled(false);
    try {
      long before = countResetRequestsFor(currentUser);
      // still answers true and creates a usable request, the link goes to the logs not an email
      assertTrue(userSessionController.resetPasswordRequest(currentUser.getEmail()));
      assertEquals(0, mockMail.getEmails().size());
      assertEquals(before + 1, countResetRequestsFor(currentUser));
    } finally {
      mockMail.setEnabled(true);
    }
  }

  private long countResetRequestsFor(User user) {
    // reset_password.user_id has no FK, rows from other tests can point to deleted users
    return resetPasswordRepository.findAll().stream()
        .filter(r -> r.getUser() != null && r.getUser().getId().equals(user.getId()))
        .count();
  }
}
