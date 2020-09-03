package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.*;
import org.apache.commons.io.IOUtils;
import spark.Response;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@SparkController
public class ApplicationController {


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
    public String corsOptions(@SparkHeader("Access-Control-Request-Headers") String accessControlRequestHeaders, @SparkHeader("Access-Control-Request-Method") String accessControlRequestMethod, Response response) {
        if (accessControlRequestHeaders != null) {
            response.header("Access-Control-Allow-Headers", accessControlRequestHeaders);
        }

        if (accessControlRequestMethod != null) {
            response.header("Access-Control-Allow-Methods", accessControlRequestMethod);
        }

        return "OK";
    }


    @SparkBefore("/*")
    public void corsBefore(Response response) {
        response.header("Access-Control-Allow-Origin", "*");
        response.header("Access-Control-Request-Method", "GET, PUT, POST, DELETE, HEAD");
        response.header("Access-Control-Allow-Headers", "Authorization");
        // Note: this may or may not be necessary in your particular application
    }


/*
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
*/


}
