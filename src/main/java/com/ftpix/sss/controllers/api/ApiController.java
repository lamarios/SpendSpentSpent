package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.SparkAfter;
import com.ftpix.sparknnotation.annotations.SparkBefore;
import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkHeader;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Setting;
import com.ftpix.sss.models.UserSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Request;
import spark.Response;
import spark.Spark;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;

@SparkController
public class ApiController {
    private final Logger logger = LogManager.getLogger();
    private final static String TOKEN = "Authorization";


    @SparkAfter("/API/*")
    public void after(Request req, Response res) {
        res.header("Content-type", Constants.JSON);
    }

    @SparkBefore("/*")
    public void before(Request req, Response res) {
        logger.info("{} - {}", req.requestMethod(), req.url());
    }


    /**
     * Handles authentitcation
     *
     * @param res   Spark response object, used to set error code in case of failure
     * @param token the API token from the headers
     * @throws SQLException
     */
    @SparkBefore("/API/*")
    public void chechAuth(Request req, Response res, @SparkHeader(TOKEN) String token) throws SQLException {
        res.type("application/json");

        if (req.requestMethod() != "OPTIONS") {
            if (SettingsController.get(Setting.AUTHENTICATION).equalsIgnoreCase("true")) {
                if (token != null) {
                    UserSession session = DB.USER_SESSION_DAO.queryForId(token);
                    if (session != null) {
                        LocalDateTime tokenExpiry = LocalDateTime.ofInstant(session.getExpiryDate().toInstant(), ZoneId.systemDefault());
                        if (LocalDateTime.now().isAfter(tokenExpiry)) {
                            Spark.halt(401, "API token expired, please log in again");
                        }
                    } else {
                        Spark.halt(401, "API key not matching");
                    }
                } else {
                    Spark.halt(401, "No API Key");
                }
            }
        }else{
            logger.info("OPTION Request, skipping auth");
        }
    }
}
