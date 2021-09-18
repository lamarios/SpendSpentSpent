package com.ftpix.sss.controllers.api;


import com.ftpix.sss.Constants;
import com.ftpix.sss.models.ResetPasswordNew;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.models.User;
import com.ftpix.sss.security.JwtTokenUtil;
import com.ftpix.sss.security.JwtUserDetailsService;
import com.ftpix.sss.services.ResetPasswordService;
import com.ftpix.sss.services.SettingsService;
import com.ftpix.sss.services.UserService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
public class UserSessionController {
    private final static Logger logger = LogManager.getLogger();

    private final UserService userService;

    private final JwtTokenUtil jwtTokenUtil;
    private final JwtUserDetailsService jwtUserDetailsService;

    private final ResetPasswordService resetPasswordService;

    private final SettingsService settingsService;

    @Autowired
    public UserSessionController(UserService userService, JwtTokenUtil jwtTokenUtil, JwtUserDetailsService jwtUserDetailsService, ResetPasswordService resetPasswordService, SettingsService settingsService) {
        this.userService = userService;
        this.jwtTokenUtil = jwtTokenUtil;
        this.jwtUserDetailsService = jwtUserDetailsService;
        this.resetPasswordService = resetPasswordService;
        this.settingsService = settingsService;
    }

    @PostMapping("/ResetPasswordRequest")
    public boolean resetPasswordRequest(@RequestBody String email) {
        try {
            resetPasswordService.createResetPasswordRequest(email);
        } catch (Exception e) {
            logger.error("Rest password failed", e);
        }
        return true;
    }

    @PostMapping("/ResetPassword")
    public boolean resetPassword(@RequestBody ResetPasswordNew resetPasswordNew) throws Exception {
        return resetPasswordService.resetPassword(resetPasswordNew);
    }

    @PostMapping(value = "/SignUp")
    public String signUp(@RequestBody User user) throws Exception {

        final boolean allowSignups = Optional.ofNullable(settingsService.getByName(Settings.ALLOW_SIGNUP))
                .map(Settings::getValue)
                .map(v -> v.equalsIgnoreCase("1"))
                .orElse(Constants.ALLOW_SIGNUP);

        if (!allowSignups) {
            throw new Exception("Signups not allowed");
        }

        // set users as non admin by default
        user.setAdmin(false);

        User newUser = userService.createUser(user);

        final UserDetails userDetails = jwtUserDetailsService
                .loadUserByUsername(newUser.getEmail());
        final String token = jwtTokenUtil.generateToken(userDetails);

        return token;
    }

    public static class UserCredentials {
        public String email, password;
    }

}
