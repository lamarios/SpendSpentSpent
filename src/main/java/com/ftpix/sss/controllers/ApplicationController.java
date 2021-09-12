package com.ftpix.sss.controllers;


import com.ftpix.sss.Constants;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.SettingsService;
import com.j256.ormlite.dao.Dao;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Controller
public class ApplicationController {
    protected final Log logger = LogFactory.getLog(this.getClass());

    private final EmailService emailService;

    private final SettingsService settingsService;

    private final Dao<User, UUID> userDao;

    @Autowired
    public ApplicationController(EmailService emailService, SettingsService settingsService, Dao<User, UUID> userDao) {
        this.emailService = emailService;
        this.settingsService = settingsService;
        this.userDao = userDao;
    }


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


        Optional<String> motd = Optional.ofNullable(settingsService.getByName(Settings.MOTD))
                .map(Settings::getValue);

        if (!motd.isPresent()) {
            motd = Constants.ANNOUNCEMENT_MESSAGE;
        }

        motd.ifPresent(sb::append);


        long userCount = userDao.countOf();

        if (userCount == 0) {
            if (sb.length() > 0) {
                sb.append("\n\n");
            }
            sb.append("There are no users on this instance, the first user to sign up will be set as an admin. If the signup link doesn't show up above, add the environment variable ALLOW_SIGNUP=1.\n\nIf you had existing expenses from a previous version it will be all migrated to the first user to sign up.");
        }

        final boolean allowSignups = Optional.ofNullable(settingsService.getByName(Settings.ALLOW_SIGNUP))
                .map(Settings::getValue)
                .map(v -> v.equalsIgnoreCase("1"))
                .orElse(Constants.ALLOW_SIGNUP);


        results.put("hasSubscription", Constants.HAS_SUBSCRIPTIONS);

        results.put("announcement", sb.toString());

        results.put("allowSignup", allowSignups);

        results.put("canResetPassword", emailService.isEnabled());

        results.put("demoMode", Optional.ofNullable(settingsService.getByName(Settings.DEMO_MODE)).map(s -> s.getValue().equalsIgnoreCase("1")).orElse(false));

        return results;
    }

    @RequestMapping("/signup-screen")
    public String serveSignUp() throws IOException {
        return serveIndex();
    }


    @RequestMapping(value = "/")
    public String serveIndex() {
        return "index.html";
    }

    @RequestMapping("/reset-password")
    public String resetPassword() {
        return serveIndex();
    }

    @RequestMapping(value = "/history")
    public String serveHistory() throws IOException {
        return serveIndex();
    }

    @RequestMapping(value = "/login-screen")
    public String servceLogin() throws IOException {
        return serveIndex();
    }

    @RequestMapping(value = "/settings")
    public String serveSettings() throws IOException {
        return serveIndex();
    }

    @RequestMapping(value = "/graphs")
    public String serveGraphs() throws IOException {
        return serveIndex();
    }

    @RequestMapping(value = "/edit-profile")
    public String editProfile() throws IOException {
        return serveIndex();
    }

}
