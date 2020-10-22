package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Request;
import spark.Response;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@SparkController
public class ApplicationController {
    private final Logger logger = LogManager.getLogger();

    /**
     * Returns few values that will be use by the login screen so it knows what to display
     *
     * @return
     */
    @SparkGet(value = "/config", transformer = GsonTransformer.class)
    public Map<String, Object> getConfig(Response res) throws SQLException {

        res.header("Content-type", Constants.JSON);
        Map<String, Object> results = new HashMap<>();

        StringBuilder sb = new StringBuilder();
        Constants.ANNOUNCEMENT_MESSAGE.ifPresent(sb::append);


        long userCount = DB.USER_DAO.countOf();

        if (userCount == 0) {
            if (sb.length() > 0) {
                sb.append("\n\n");
            }
            sb.append("There are no users on this instance, the first user to sign up will be set as an admin. If the signup link doesn't show up above, add the environment variable ALLOW_SIGNUP=1.\n\nIf you had existing expenses from a previous version it will be all migrated to the first user to sign up.");
        }

        results.put("hasSubscription", Constants.HAS_SUBSCRIPTIONS);

        results.put("announcement", sb.toString());

        results.put("allowSignup", Constants.ALLOW_SIGNUP);

        return results;
    }

    @SparkGet(value = "/signup-screen")
    public String serveSignUp(Response res) throws IOException {
        return serveIndex(res);
    }

    @SparkOptions("/*")
    public String corsOptions(Response response, @SparkHeader("Origin") String origin) {
        response.header("Access-Control-Allow-Origin", origin);
        return "";
    }

    @SparkBefore("/*")
    public void corsBefore(Request req, Response response, @SparkHeader("Access-Control-Request-Headers") String accessControlRequestHeaders, @SparkHeader("Origin") String origin, @SparkHeader("Access-Control-Request-Method") String accessControlRequestMethod) {
        logger.info("{} - {}", req.requestMethod(), req.url());


        if (accessControlRequestHeaders != null) {
            response.header("Access-Control-Allow-Headers", accessControlRequestHeaders);
        }

        if (accessControlRequestMethod != null) {
            response.header("Access-Control-Allow-Methods", accessControlRequestMethod);
        }

        response.header("Access-Control-Allow-Credentials", "true");
    }

    @SparkGet(value = "/")
    public String serveIndex(Response res) throws IOException {
        try (InputStream index = getClass().getClassLoader().getResourceAsStream("web/public/index.html");
             InputStreamReader reader = new InputStreamReader(index, StandardCharsets.UTF_8)
        ) {
            res.raw().addHeader("Content-Type", "text/html");
            IOUtils.copy(reader, res.raw().getOutputStream(), StandardCharsets.UTF_8);
        }

        return "";
    }

    @SparkGet(value = "/history")
    public String serveHistory(Response res) throws IOException {
        return serveIndex(res);
    }

    @SparkGet(value = "/login-screen")
    public String servceLogin(Response res) throws IOException {
        return serveIndex(res);
    }

    @SparkGet(value = "/settings")
    public String serveSettings(Response res) throws IOException {
        return serveIndex(res);
    }

    @SparkGet(value = "/graphs")
    public String serveGraphs(Response res) throws IOException {
        return serveIndex(res);
    }
    @SparkGet(value = "/edit-profile")
    public String editProfile(Response res) throws IOException {
        return serveIndex(res);
    }

}
