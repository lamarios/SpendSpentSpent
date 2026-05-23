package com.ftpix.sss.services;

import com.ftpix.sss.models.ResetPassword;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.ResetPasswordRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ResetPasswordService {
    private final static Logger logger = LogManager.getLogger();
    private final UserService userService;
    private final EmailService emailService;
    private final ResetPasswordRepository resetPasswordRepository;


    private final String rootUrl;

    @Autowired
    public ResetPasswordService(UserService userService, EmailService emailService, ResetPasswordRepository resetPasswordRepository, String rootUrl) {
        this.userService = userService;
        this.emailService = emailService;
        this.resetPasswordRepository = resetPasswordRepository;
        this.rootUrl = rootUrl;
    }

    private void clearExpiredRequests() throws SQLException {
//        int i = resetPasswordDaoJooq.deleteWhere(RESET_PASSWORD.EXPIRYDATE.lt(System.currentTimeMillis()));
        List<ResetPassword> expiredRequests = resetPasswordRepository.findAllByExpiryDateBefore(System.currentTimeMillis());

        resetPasswordRepository.deleteAll(expiredRequests);

        logger.info("Deleted {} expired password requests", expiredRequests.size());
    }


    @Transactional
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
                            resetPasswordRepository.save(resetPassword);

                            Map<String, Object> templateData = new HashMap<>();

                            String resetPasswordUrl = rootUrl + "/reset-password?reset-id=" + resetPassword.getId()
                                    .toString();
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

    @Transactional
    public boolean resetPassword(ResetPasswordNew resetPasswordNew) throws Exception {

//        final ResetPassword resetPassword = resetPasswordDaoJooq.getById(resetPasswordNew.getResetId())
        final ResetPassword resetPassword = resetPasswordRepository.findById(resetPasswordNew.getResetId())
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
