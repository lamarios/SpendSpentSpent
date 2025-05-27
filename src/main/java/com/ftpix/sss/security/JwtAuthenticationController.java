package com.ftpix.sss.security;

import com.ftpix.sss.controllers.api.UserSessionController;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.OIDCService;
import com.ftpix.sss.services.UserService;
import io.jsonwebtoken.Claims;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.Authorization;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;

@RestController
@Api(tags = {"Login"})
public class JwtAuthenticationController {

    @Autowired
    private UserService userService;

    @Autowired
    private OIDCService oidcService;


    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private JwtUserDetailsService jwtUserDetailsService;


    @RequestMapping(value = "/OidcLogin", method = RequestMethod.GET)
    @ApiOperation(value = "Logs into the system, will return a JWT token to pass to other requests as a bearer token via the Authorization header")
    public String loginWithOidcToken(@RequestHeader("Authorization") String authorizationHeader) throws Exception {
        String token = authorizationHeader.replaceAll("Bearer ", "");
        Claims claims = oidcService.getParser()
                .parseSignedClaims(token)
                .getPayload();
        var subject = claims.getSubject();

        // handle user
        var user = jwtUserDetailsService.loadUserByUsername(subject, token);
        if (user != null) {
            return jwtTokenUtil.generateToken(user);
        } else {
            return null;
        }

    }

    @RequestMapping(value = "/Login", method = RequestMethod.POST)
    @ApiOperation(value = "Logs into the system, will return a JWT token to pass to other requests as a bearer token via the Authorization header")
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

