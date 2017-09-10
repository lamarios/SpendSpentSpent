package com.ftpix.sss.controllers;


import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkGet;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Setting;
import spark.ModelAndView;
import spark.template.jade.JadeTemplateEngine;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

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


}
