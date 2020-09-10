package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.*;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Request;
import spark.Response;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@SparkController
public class ApplicationController {
    private final Logger logger = LogManager.getLogger();


//    @SparkGet(value="/", templateEngine = JadeTemplateEngine.class)
//    public ModelAndView index() throws SQLException {
//        String apiKey = "";
//
//        Setting googleMapApi = DB.SETTING_DAO.queryForId(Setting.GOOGLE_MAP);
//
//        if (googleMapApi != null) {
//            apiKey = googleMapApi.getValue();
//        }
//
//        Map<String, String> map = new HashMap<>();
//        map.put("apiKey", apiKey);
//
//        return new ModelAndView(map, "index-react");
//
//    }

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

}
