package com.ftpix.sss.security;

import com.ftpix.sss.controllers.api.UserSessionController;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

@RestController
public class JwtAuthenticationController {

    @Autowired
    private UserService userService;


    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private JwtUserDetailsService jwtUserDetailsService;


    @RequestMapping(value = "/Login", method = RequestMethod.POST)
    public String generateAuthenticationToken(@RequestBody UserSessionController.UserCredentials creds)
            throws Exception {

        authenticate(creds.email, creds.password);

        final UserDetails userDetails = jwtUserDetailsService
                .loadUserByUsername(creds.email);

        final String token = jwtTokenUtil.generateToken(userDetails);


        return token;
    }

    private void authenticate(String email, String password) throws Exception {
        Objects.requireNonNull(email);
        Objects.requireNonNull(password);
        final User byEmail = userService.getByEmail(email);
        final String hash = userService.hashUserCredentials(email, password);
        if (byEmail == null || !byEmail.getPassword().equalsIgnoreCase(hash)) {
            throw new BadCredentialsException("Invalid username or password");
        }

    }
}

