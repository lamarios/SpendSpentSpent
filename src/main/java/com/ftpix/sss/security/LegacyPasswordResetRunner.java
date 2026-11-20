package com.ftpix.sss.security;

import com.ftpix.sss.services.ResetPasswordService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/** At startup, logs password reset links for users left without a password by the MD5 removal. */
@Component
public class LegacyPasswordResetRunner implements ApplicationRunner {
  private static final Logger logger = LogManager.getLogger();
  private final ResetPasswordService resetPasswordService;

  public LegacyPasswordResetRunner(ResetPasswordService resetPasswordService) {
    this.resetPasswordService = resetPasswordService;
  }

  @Override
  public void run(ApplicationArguments args) {
    try {
      resetPasswordService.logResetLinksForUsersWithoutPassword();
    } catch (Exception e) {
      // never prevent the app from starting because of this
      logger.error("Could not generate password reset links for users without a password", e);
    }
  }
}
