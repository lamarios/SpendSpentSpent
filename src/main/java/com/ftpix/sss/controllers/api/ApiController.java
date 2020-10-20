package com.ftpix.sss.controllers.api;


import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.controllers.ApplicationController;
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
    public final static String TOKEN = "Authorization";
    private final Logger logger = LogManager.getLogger();


    @SparkAfter("/API/*")
    public void after(Request req, Response res) {
        if (!req.requestMethod().equalsIgnoreCase("OPTIONS")) {
            res.header("Content-type", Constants.JSON);
        }
    }


    /**
     * Handles authentitcation
     *
     * @param res   Spark response object, used to set error code in case of failure
     * @param token the API token from the headers
     * @throws SQLException
     */
    @SparkBefore("/API/*")
    public void chechAuth(Request req, Response res, @SparkHeader(TOKEN) String token, @SparkHeader("Origin") String origin) throws SQLException {


        if (!req.requestMethod().equalsIgnoreCase("OPTIONS")) {
            res.header("Access-Control-Allow-Origin", origin);
            res.type("application/json");

            final String requireAuth = SettingsController.get(Setting.AUTHENTICATION);
            if (requireAuth.equalsIgnoreCase("true")) {
                if (token != null) {
                    try {
                        final UserSessionController controller = Sparknotation.getController(UserSessionController.class);
                        controller.verifyToken(token);
                    } catch (Exception e) {
                        Spark.halt(401, "TOken verification failed");
                    }
                } else {
                    Spark.halt(401, "No JWT token");
                }
            }
        } else {
            logger.info("OPTION Request, skipping auth");
        }
    }
}
