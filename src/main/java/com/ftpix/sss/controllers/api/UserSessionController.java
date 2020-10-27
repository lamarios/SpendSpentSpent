package com.ftpix.sss.controllers.api;


import com.ftpix.sss.Constants;
import com.ftpix.sss.models.User;
import com.ftpix.sss.security.JwtTokenUtil;
import com.ftpix.sss.security.JwtUserDetailsService;
import com.ftpix.sss.services.UserService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserSessionController {
    private final static Logger logger = LogManager.getLogger();

    private final UserService userService;

    private final JwtTokenUtil jwtTokenUtil;
    private final JwtUserDetailsService jwtUserDetailsService;

    @Autowired
    public UserSessionController(UserService userService, JwtTokenUtil jwtTokenUtil, JwtUserDetailsService jwtUserDetailsService) {
        this.userService = userService;
        this.jwtTokenUtil = jwtTokenUtil;
        this.jwtUserDetailsService = jwtUserDetailsService;
    }


    @PostMapping(value = "/SignUp")
    public String signUp(@RequestBody User user) throws Exception {
        if (!Constants.ALLOW_SIGNUP) {
            throw new Exception("Signups not allowed");
        }

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
