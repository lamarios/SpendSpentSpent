package com.ftpix.sss.controllers;


import com.ftpix.sss.Constants;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.CurrencyStatus;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.CurrencyService;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.SettingsService;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.io.StringWriter;
import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class ApplicationController {
    protected final Log logger = LogFactory.getLog(this.getClass());

    private final EmailService emailService;

    private final SettingsService settingsService;


    private final Configuration templateEngine;
    private final BuildProperties buildProperties;
    private final CurrencyService currencyService;

    public final static int MIN_APP_VERSION = 47;
    private final UserDao userDaoJooq;

    @Autowired
    public ApplicationController(EmailService emailService, SettingsService settingsService, Configuration templateEngine, BuildProperties buildProperties, CurrencyService currencyService, UserDao userDaoJooq) {
        this.emailService = emailService;
        this.settingsService = settingsService;

        this.templateEngine = templateEngine;
        this.buildProperties = buildProperties;
        this.currencyService = currencyService;
        this.userDaoJooq = userDaoJooq;
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


        long userCount = userDaoJooq.countUsers();

        if (userCount == 0) {
            if (sb.length() > 0) {
                sb.append("\n\n");
            }
            sb.append("There are no users on this instance, the first user to sign up will be set as an admin. If the signup link doesn't show up, add the environment variable ALLOW_SIGNUP=1.\n\nIf you had existing expenses from a previous version it will be all migrated to the first user to sign up.");
        }

        final boolean allowSignups = Optional.ofNullable(settingsService.getByName(Settings.ALLOW_SIGNUP))
                .map(Settings::getValue)
                .map(v -> v.equalsIgnoreCase("1"))
                .orElse(Constants.ALLOW_SIGNUP);


        results.put("hasSubscription", Constants.HAS_SUBSCRIPTIONS);

        results.put("announcement", sb.toString());

        results.put("allowSignup", allowSignups);

        results.put("canResetPassword", emailService.isEnabled());

        results.put("backendVersion", Integer.parseInt(buildProperties.getVersion()));
        results.put("minAppVersion", Integer.toString(MIN_APP_VERSION));

        results.put("canConvertCurrency", currencyService.canUseCurrencyConversion());

        try {
            CurrencyStatus currencyStatus = currencyService.getQuota();
            results.put("convertCurrencyQuota", "" + currencyStatus.getRemaining() + "/" + currencyStatus.getTotal());
        } catch (Exception e) {
            results.put("convertCurrencyQuota", "");
        }


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

    @GetMapping(value = "/reset-password", produces = MediaType.TEXT_HTML_VALUE)
    @ResponseBody
    public String resetPassword(@RequestParam("reset-id") String resetId) throws IOException, TemplateException {
        if (resetId == null) {
            throw new InvalidParameterException("Invalid request");
        }

        try (StringWriter templateStr = new StringWriter()) {

            Map<String, Object> templateData = new HashMap<>();
            templateData.put("resetId", resetId);
            final Template template = templateEngine.getTemplate("web/reset-password.ftl");
            template.process(templateData, templateStr);

            return templateStr.toString();
        }
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
