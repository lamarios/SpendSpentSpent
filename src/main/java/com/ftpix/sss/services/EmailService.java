package com.ftpix.sss.services;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.simplejavamail.api.email.Email;
import org.simplejavamail.api.mailer.Mailer;
import org.simplejavamail.email.EmailBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class EmailService {

    private final static Logger logger = LogManager.getLogger();

    private final Optional<Mailer> mailer;

    @Value("${SMTP_FROM:}")
    private String smtpFrom;

    @Autowired
    public EmailService(Optional<Mailer> mailer) {
        this.mailer = mailer;
    }

    public boolean isEnabled() {
        return mailer.isPresent();
    }

    /**
     * Sends email with template
     *
     * @param to
     * @param message
     * @param subject
     */
    public void send(String to, String subject, String message) {
        try {
            mailer.ifPresent(m -> {
                logger.info("Sending email [{}]", subject);
                Email email = EmailBuilder.startingBlank()
                        .to(to)
                        .from(smtpFrom)
                        .withSubject(subject)
                        .withHTMLText(message)
//                        .withPlainText(message)
                        .buildEmail();

                m.sendMail(email);
            });
        } catch (Exception e) {
            logger.error("Error while sending email", e);
        }
    }
}
