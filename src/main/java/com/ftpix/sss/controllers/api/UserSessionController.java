package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkPost;
import com.ftpix.sparknnotation.annotations.SparkQueryParam;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Setting;
import com.ftpix.sss.models.UserSession;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;

@SparkController
public class UserSessionController {
    private final static String FIELD_USERNAME = "username", FIELD_PASSWORD = "password";
    private final static Logger logger = LogManager.getLogger();

    /**
     * Logs in a user
     * @param username his username
     * @param password his password
     * @return the user session with the token
     * @throws SQLException
     */
    @SparkPost(value = "/Login", transformer = GsonTransformer.class)
    public UserSession logIn(@SparkQueryParam(FIELD_USERNAME) String username, @SparkQueryParam(FIELD_PASSWORD) String password) throws SQLException {

        try {
            if (username.equalsIgnoreCase(SettingsController.get(Setting.USERNAME)) && SettingsController.hashString(password).equalsIgnoreCase(SettingsController.get(Setting.PASSWORD))) {
                LocalDateTime in3Month = LocalDateTime.now().plusMonths(3);
                String token = SettingsController.hashString(username + password + in3Month.toString());

                UserSession session = new UserSession();
                session.setToken(token);
                session.setExpiryDate(Date.from(in3Month.atZone(ZoneId.systemDefault()).toInstant()));

                DB.USER_SESSION_DAO.create(session);

                logger.info("New Session token[{}] expiryDay [{}]", session.getToken(), session.getExpiryDate());
                return session;
            } else {
                Spark.halt(401, "Wrong login or password");
            }
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            Spark.halt(503, e.getMessage());
        }

        return null;
    }
}
