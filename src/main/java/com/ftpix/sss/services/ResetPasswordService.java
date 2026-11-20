package com.ftpix.sss.services;

import com.ftpix.sss.models.ResetPassword;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ResetPasswordRepository;
import com.ftpix.sss.persistence.UserRepository;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ResetPasswordService {
  private static final Logger logger = LogManager.getLogger();
  private final UserService userService;
  private final EmailService emailService;
  private final ResetPasswordRepository resetPasswordRepository;
  private final UserRepository userRepository;

  private final String rootUrl;

  @Autowired
  public ResetPasswordService(
      UserService userService,
      EmailService emailService,
      ResetPasswordRepository resetPasswordRepository,
      UserRepository userRepository,
      String rootUrl) {
    this.userService = userService;
    this.emailService = emailService;
    this.resetPasswordRepository = resetPasswordRepository;
    this.userRepository = userRepository;
    this.rootUrl = rootUrl;
  }

  private void clearExpiredRequests() throws SQLException {
    //        int i =
    // resetPasswordDaoJooq.deleteWhere(RESET_PASSWORD.EXPIRYDATE.lt(System.currentTimeMillis()));
    List<ResetPassword> expiredRequests =
        resetPasswordRepository.findAllByExpiryDateBefore(System.currentTimeMillis());

    resetPasswordRepository.deleteAll(expiredRequests);

    logger.info("Deleted {} expired password requests", expiredRequests.size());
  }

  /** Creates a reset request valid for a day and returns the link to use it. */
  private String createResetUrl(User user) {
    ResetPassword resetPassword = new ResetPassword();
    resetPassword.setUser(user);
    LocalDateTime expiry = LocalDateTime.now().plusDays(1);
    resetPassword.setExpiryDate(Timestamp.valueOf(expiry).getTime());
    resetPasswordRepository.save(resetPassword);

    return rootUrl + "/reset-password?reset-id=" + resetPassword.getId().toString();
  }

  /**
   * Local users without a bcrypt hash (legacy MD5 users who never logged in before the MD5 column
   * was dropped) can't log in. Self-hosted admins can read the logs, so we print a reset link for
   * each of them. Runs at every startup, so a restart gives fresh links once the old ones expire.
   */
  @Transactional
  public void logResetLinksForUsersWithoutPassword() throws SQLException {
    List<User> users = userRepository.findAllByPasswordBcryptIsNullAndOidcSubIsNull();
    if (users.isEmpty()) {
      return;
    }

    clearExpiredRequests();
    logger.warn(
        "{} user(s) have no password set (their legacy MD5 password hash was removed). They"
            + " need to reset their password using the links below, valid for 24h. Restart the"
            + " app to generate new links.",
        users.size());
    for (User user : users) {
      logger.warn("Password reset for {}: {}", user.getEmail(), createResetUrl(user));
    }
  }

  @Transactional
  public boolean createResetPasswordRequest(String email) throws SQLException {
    try {
      Optional.ofNullable(userService.getByEmail(email))
          .ifPresent(
              u -> {
                try {
                  String resetPasswordUrl = createResetUrl(u);

                  if (!emailService.isEnabled()) {
                    // no SMTP: self-hosted admins hand the link over from the logs
                    logger.warn(
                        "Password reset requested for {}, link valid for 24h: {}",
                        u.getEmail(),
                        resetPasswordUrl);
                    return;
                  }

                  Map<String, Object> templateData = new HashMap<>();
                  templateData.put("url", resetPasswordUrl);
                  templateData.put("firstName", u.getFirstName());

                  emailService.sendTemplate(
                      u.getEmail(),
                      "[SpendSpentSpent] Reset password request",
                      "email/reset-password.ftl",
                      templateData);
                  // sending email
                } catch (Exception e) {
                  throw new RuntimeException(e);
                }
              });
    } catch (Exception e) {
      logger.error("error while resetting password", e);
    }

    clearExpiredRequests();
    // never fail a reset password request, so people can't try to find emails in system
    return true;
  }

  @Transactional
  public boolean resetPassword(ResetPasswordNew resetPasswordNew) throws Exception {

    //        final ResetPassword resetPassword =
    // resetPasswordDaoJooq.getById(resetPasswordNew.getResetId())
    final ResetPassword resetPassword =
        resetPasswordRepository
            .findById(resetPasswordNew.getResetId())
            .orElseThrow(() -> new Exception("Invalid password request"));
    final LocalDateTime expiry = new Timestamp(resetPassword.getExpiryDate()).toLocalDateTime();

    if (expiry.isBefore(LocalDateTime.now())) {
      throw new Exception("Reset password link expired");
    }

    final User user = resetPassword.getUser();
    user.setPassword(resetPasswordNew.getNewPassword());
    userService.updateUserProfile(user, user);

    resetPasswordRepository.delete(resetPassword);
    clearExpiredRequests();
    return true;
  }
}
