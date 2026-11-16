package com.ftpix.sss.controllers.api;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.ftpix.sss.TestConfig;
import com.ftpix.sss.TestContainerTest;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ResetPasswordRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.security.JwtAuthenticationController;
import com.ftpix.sss.services.UserService;
import com.ftpix.sss.utils.UserServiceMock;
import java.util.List;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

/** A changed password is the one to log in with afterwards, the old one doesn't work anymore. */
@Import(TestConfig.class)
public class PasswordChangeTest extends TestContainerTest {

  @Autowired private JwtAuthenticationController jwtAuthenticationController;
  @Autowired private UserController userController;
  @Autowired private UserSessionController userSessionController;
  @Autowired private UserService userService;
  @Autowired private UserRepository userRepository;
  @Autowired private ResetPasswordRepository resetPasswordRepository;

  /** Setting someone's password is for admins only. */
  @BeforeEach
  public void logInAsAdmin() {
    SecurityContextHolder.getContext()
        .setAuthentication(
            new UsernamePasswordAuthenticationToken(
                currentUser.getEmail(), null, List.of(new SimpleGrantedAuthority("ROLE_ADMIN"))));
  }

  @AfterEach
  public void logOut() {
    SecurityContextHolder.clearContext();
  }

  private boolean canLogIn(String password) throws Exception {
    var credentials = new UserSessionController.UserCredentials();
    credentials.email = currentUser.getEmail();
    credentials.password = password;
    try {
      return jwtAuthenticationController.generateAuthenticationToken(credentials) != null;
    } catch (BadCredentialsException e) {
      return false;
    }
  }

  /** Sets the current user's password through the admin endpoint, sent with the content type. */
  private void setPassword(String body, String contentType) throws Exception {
    MockMvcBuilders.standaloneSetup(userController)
        .build()
        .perform(
            post("/API/User/{userId}/setPassword", currentUser.getId())
                .contentType(contentType)
                .content(body))
        .andExpect(status().isOk())
        .andExpect(content().string("true"));
  }

  /** Logging in once stores the bcrypt hash, that's then what is checked on login. */
  private void logInOnce() throws Exception {
    assertTrue(canLogIn("pass"));
    // the current user is loaded from the database for each request
    ((UserServiceMock) userService)
        .setCurrentUser(userRepository.findFirstById(currentUser.getId()));
  }

  @Test
  public void changingTheOwnPassword() throws Exception {
    logInOnce();

    var profile = new User();
    profile.setFirstName("Tester");
    profile.setLastName("Super");
    profile.setPassword("new password");
    userController.updateProfile(profile);

    assertTrue(canLogIn("new password"));
    assertFalse(canLogIn("pass"));
  }

  @Test
  public void anAdminSettingThePassword() throws Exception {
    logInOnce();

    // as the app sends it
    setPassword("\"new password\"", "application/json");

    assertTrue(canLogIn("new password"));
    assertFalse(canLogIn("pass"));
    assertFalse(canLogIn("\"new password\""));
  }

  @Test
  public void anAdminSettingThePasswordAsPlainText() throws Exception {
    logInOnce();

    setPassword("\"keep these quotes\"", "text/plain;charset=UTF-8");

    assertTrue(canLogIn("\"keep these quotes\""));
    assertFalse(canLogIn("keep these quotes"));
    assertFalse(canLogIn("pass"));
  }

  @Test
  public void anAdminSettingThePasswordOfSomeoneWhoHasntLoggedInSince() throws Exception {
    setPassword("\"new password\"", "application/json");

    assertTrue(canLogIn("new password"));
    assertFalse(canLogIn("pass"));
  }

  @Test
  public void resettingThePasswordByEmail() throws Exception {
    logInOnce();

    userSessionController.resetPasswordRequest(currentUser.getEmail());
    var reset = new ResetPasswordNew();
    reset.setResetId(
        resetPasswordRepository.findAll().stream()
            .filter(r -> r.getUser() != null && r.getUser().getId().equals(currentUser.getId()))
            .findFirst()
            .orElseThrow()
            .getId());
    reset.setNewPassword("new password");
    userSessionController.resetPassword(reset);

    assertTrue(canLogIn("new password"));
    assertFalse(canLogIn("pass"));
  }
}
