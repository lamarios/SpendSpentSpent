package com.ftpix.sss.services;

import static org.junit.jupiter.api.Assertions.*;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.controllers.api.UserSessionController;
import com.ftpix.sss.models.ResetPassword;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ResetPasswordRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.security.JwtAuthenticationController;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;

@Import(TestConfig.class)
public class LegacyPasswordResetTest extends TestContainerTest {

  @Autowired private ResetPasswordService resetPasswordService;
  @Autowired private ResetPasswordRepository resetPasswordRepository;
  @Autowired private UserRepository userRepository;
  @Autowired private JwtAuthenticationController jwtAuthenticationController;

  @Test
  public void legacyUserGetsResetLinkAndCanSetNewPassword() throws Exception {
    // a user left over from the MD5 days: no bcrypt hash, not an OIDC user
    User legacy = new User();
    legacy.setFirstName("Legacy");
    legacy.setLastName("User");
    legacy.setEmail("legacy-md5@example.org");
    legacy.setSubscriptionExpiryDate(Long.MAX_VALUE);
    legacy = userRepository.save(legacy);

    // an OIDC user also has no bcrypt hash but must be ignored
    User oidc = new User();
    oidc.setFirstName("Oidc");
    oidc.setLastName("User");
    oidc.setEmail("oidc-user@example.org");
    oidc.setOidcSub("some-sub");
    oidc.setSubscriptionExpiryDate(Long.MAX_VALUE);
    oidc = userRepository.save(oidc);

    UserSessionController.UserCredentials creds = new UserSessionController.UserCredentials();
    creds.email = legacy.getEmail();
    creds.password = "anything";
    assertThrows(
        BadCredentialsException.class,
        () -> jwtAuthenticationController.generateAuthenticationToken(creds));

    resetPasswordService.logResetLinksForUsersWithoutPassword();

    final User legacyUser = legacy;
    final User oidcUser = oidc;
    // reset_password.user_id has no FK, rows from other tests can point to deleted users
    List<ResetPassword> all =
        resetPasswordRepository.findAll().stream().filter(r -> r.getUser() != null).toList();
    List<ResetPassword> legacyRequests =
        all.stream().filter(r -> r.getUser().getId().equals(legacyUser.getId())).toList();
    assertEquals(1, legacyRequests.size());
    assertTrue(all.stream().noneMatch(r -> r.getUser().getId().equals(oidcUser.getId())));
    // the regular test user has a bcrypt password and must not be listed either
    assertTrue(all.stream().noneMatch(r -> r.getUser().getId().equals(currentUser.getId())));

    // using the logged link lets the user set a password and log in again
    ResetPasswordNew reset = new ResetPasswordNew();
    reset.setResetId(legacyRequests.get(0).getId());
    reset.setNewPassword("brand new password");
    resetPasswordService.resetPassword(reset);

    creds.password = "brand new password";
    assertNotNull(jwtAuthenticationController.generateAuthenticationToken(creds));
  }
}
