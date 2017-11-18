package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.*;
import spark.ModelAndView;
import spark.Response;
import spark.template.jade.JadeTemplateEngine;

import java.io.IOException;
import java.util.HashMap;

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
    public ModelAndView serveIndex(Response res) throws IOException {

        return new ModelAndView(new HashMap<>(),"index");
    }

    @SparkGet(value = "/history", templateEngine = JadeTemplateEngine.class)
    public ModelAndView serveHistory(Response res) throws IOException {
//        res.redirect("/", 301);
        return serveIndex(res);
    }

    @SparkGet(value = "/login-screen", templateEngine = JadeTemplateEngine.class)
    public ModelAndView servceLogin(Response res) throws IOException {
        return serveIndex(res);
    }

    @SparkGet(value = "/settings", templateEngine = JadeTemplateEngine.class)
    public ModelAndView serveSettings(Response res) throws IOException {
        return serveIndex(res);
    }

    @SparkGet(value = "/graphs", templateEngine = JadeTemplateEngine.class)
    public ModelAndView serveGraphs(Response res) throws IOException {
        return serveIndex(res);
    }


}
