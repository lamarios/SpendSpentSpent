package com.ftpix.sss.services;

import com.ftpix.sss.models.ResetPassword;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.DeleteBuilder;
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
import java.util.UUID;

@Service
public class ResetPasswordService {
    private final static Logger logger = LogManager.getLogger();
    private final Dao<ResetPassword, UUID> resetPasswordDao;
    private final UserService userService;
    private final EmailService emailService;


    private final String rootUrl;

    @Autowired
    public ResetPasswordService(Dao<ResetPassword, UUID> resetPasswordDao, UserService userService, EmailService emailService, String rootUrl) {
        this.resetPasswordDao = resetPasswordDao;
        this.userService = userService;
        this.emailService = emailService;
        this.rootUrl = rootUrl;
    }

    private void clearExpiredRequests() throws SQLException {
        final DeleteBuilder<ResetPassword, UUID> builder = resetPasswordDao.deleteBuilder();
        var delete = builder.where().lt("expiryDate", System.currentTimeMillis());
        builder.setWhere(delete);
        final int count = builder.delete();
        logger.info("Deleted {} expired password requests", count);
    }

    public boolean createResetPasswordRequest(String email) throws SQLException {
        Optional.ofNullable(userService.getByEmail(email))
                .ifPresent(u -> {
                    try {
                        ResetPassword resetPassword = new ResetPassword();
                        resetPassword.setUser(u);
                        // it expires in a day
                        LocalDateTime expiry = LocalDateTime.now().plusDays(1);
                        resetPassword.setExpiryDate(Timestamp.valueOf(expiry).getTime());
                        resetPasswordDao.create(resetPassword);

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
        clearExpiredRequests();
        // never fail a reset password request, so peopel can't try to find emails in system
        return true;
    }

    public boolean resetPassword(ResetPasswordNew resetPasswordNew) throws Exception {

        final ResetPassword resetPassword = resetPasswordDao.queryForId(resetPasswordNew.getResetId());

        if (resetPassword == null) {
            throw new Exception("Invalid password request");
        }
        final LocalDateTime expiry = new Timestamp(resetPassword.getExpiryDate()).toLocalDateTime();

        if (expiry.isBefore(LocalDateTime.now())) {
            throw new Exception("Reset password link expired");
        }

        final User user = resetPassword.getUser();
        user.setPassword(resetPasswordNew.getNewPassword());
        userService.updateUserProfile(user, user);

        resetPasswordDao.delete(resetPassword);
        clearExpiredRequests();
        return true;
    }
}
