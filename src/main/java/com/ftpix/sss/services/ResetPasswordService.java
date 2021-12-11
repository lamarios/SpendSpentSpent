package com.ftpix.sss.services;

import com.ftpix.sss.dao.ResetPasswordDao;
import com.ftpix.sss.models.ResetPassword;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.User;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static com.ftpix.sss.dsl.Tables.*;

@Service
public class ResetPasswordService {
    private final static Logger logger = LogManager.getLogger();
    private final UserService userService;
    private final EmailService emailService;
    private final ResetPasswordDao resetPasswordDaoJooq;


    private final String rootUrl;

    @Autowired
    public ResetPasswordService(UserService userService, EmailService emailService, ResetPasswordDao resetPasswordDaoJooq, String rootUrl) {
        this.userService = userService;
        this.emailService = emailService;
        this.resetPasswordDaoJooq = resetPasswordDaoJooq;
        this.rootUrl = rootUrl;
    }

    private void clearExpiredRequests() throws SQLException {
        int i = resetPasswordDaoJooq.deleteWhere(RESET_PASSWORD.EXPIRYDATE.lt(System.currentTimeMillis()));

        logger.info("Deleted {} expired password requests", i);
    }

    public boolean createResetPasswordRequest(String email) throws SQLException {
        try {
            Optional.ofNullable(userService.getByEmail(email))
                    .ifPresent(u -> {
                        try {
                            ResetPassword resetPassword = new ResetPassword();
                            resetPassword.setUser(u);
                            // it expires in a day
                            LocalDateTime expiry = LocalDateTime.now().plusDays(1);
                            resetPassword.setExpiryDate(Timestamp.valueOf(expiry).getTime());
                            resetPasswordDaoJooq.insert(resetPassword);

                            Map<String, Object> templateData = new HashMap<>();

                            String resetPasswordUrl = rootUrl + "/reset-password?reset-id=" + resetPassword.getId().toString();
                            templateData.put("url", resetPasswordUrl);
                            templateData.put("firstName", u.getFirstName());

                            emailService.sendTemplate(u.getEmail(), "[SpendSpentSpent] Reset password request", "email/reset-password.ftl", templateData);
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

    public boolean resetPassword(ResetPasswordNew resetPasswordNew) throws Exception {

        final ResetPassword resetPassword = resetPasswordDaoJooq.getById(resetPasswordNew.getResetId()).orElseThrow(() -> new Exception("Invalid password request"));
        final LocalDateTime expiry = new Timestamp(resetPassword.getExpiryDate()).toLocalDateTime();

        if (expiry.isBefore(LocalDateTime.now())) {
            throw new Exception("Reset password link expired");
        }

        final User user = resetPassword.getUser();
        user.setPassword(resetPasswordNew.getNewPassword());
        userService.updateUserProfile(user, user);

        resetPasswordDaoJooq.delete(resetPassword);
        clearExpiredRequests();
        return true;
    }
}
