package com.ftpix.sss.controllers;


import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import spark.Response;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@Controller
public class ApplicationController {
    protected final Log logger = LogFactory.getLog(this.getClass());

    /**
     * Returns few values that will be use by the login screen so it knows what to display
     *
     * @return
     */
    @GetMapping(value = "/config", produces = {MediaType.APPLICATION_JSON_VALUE})
    @ResponseBody
    public Map<String, Object> getConfig() throws SQLException {

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

    @RequestMapping("/signup-screen")
    public String serveSignUp(Response res) throws IOException {
        return serveIndex(res);
    }


    @RequestMapping(value = "/")
    public String serveIndex(Response res) throws IOException {
        return "index.html";
    }

    @RequestMapping(value = "/history")
    public String serveHistory(Response res) throws IOException {
        return serveIndex(res);
    }

    @RequestMapping(value = "/login-screen")
    public String servceLogin(Response res) throws IOException {
        return serveIndex(res);
    }

    @RequestMapping(value = "/settings")
    public String serveSettings(Response res) throws IOException {
        return serveIndex(res);
    }

    @RequestMapping(value = "/graphs")
    public String serveGraphs(Response res) throws IOException {
        return serveIndex(res);
    }

    @RequestMapping(value = "/edit-profile")
    public String editProfile(Response res) throws IOException {
        return serveIndex(res);
    }

}
