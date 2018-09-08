package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.*;
import spark.Response;
import spark.template.jade.JadeTemplateEngine;
import spark.utils.IOUtils;

import java.io.IOException;

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


    @SparkGet(value = "/", templateEngine = JadeTemplateEngine.class)
    public String serveIndex() throws IOException {
        return IOUtils.toString(getClass().getClassLoader().getResourceAsStream("web/public/index.html"));
    }

    @SparkGet(value = "/history", templateEngine = JadeTemplateEngine.class)
    public String serveHistory() throws IOException {
        return serveIndex();
    }

    @SparkGet(value = "/login-screen", templateEngine = JadeTemplateEngine.class)
    public String servceLogin() throws IOException {
        return serveIndex();
    }

    @SparkGet(value = "/settings", templateEngine = JadeTemplateEngine.class)
    public String serveSettings() throws IOException {
        return serveIndex();
    }

    @SparkGet(value = "/graphs", templateEngine = JadeTemplateEngine.class)
    public String serveGraphs() throws IOException {
        return serveIndex();
    }


}
