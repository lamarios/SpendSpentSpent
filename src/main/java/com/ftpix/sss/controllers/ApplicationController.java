package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.*;
import spark.Response;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.stream.Collectors;

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
        response.type("application/json");
    }


    @SparkGet("/")
    public String serveIndex(Response res) throws IOException {
        ClassLoader loader = getClass().getClassLoader();
        File f = new File(loader.getResource("web/public/index.html").getFile());
res.header("Content-Type", "text/html");
        return Files.readAllLines(f.toPath()).stream().collect(Collectors.joining(""));
    }

    @SparkGet("/history")
    public String serveHistory(Response res) throws IOException {
//        res.redirect("/", 301);
        return serveIndex(res);
    }
    @SparkGet("/login")
    public String servceLogin(Response res) throws IOException {
        return serveIndex(res);
    }
    @SparkGet("/graphs")
    public String serveGraphs(Response res) throws IOException {
        return serveIndex(res);
    }


}
