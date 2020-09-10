package com.ftpix.sss.controllers.api;


import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.models.Setting;
import com.ftpix.sss.transformer.GsonBodyTransformer;
import com.ftpix.sss.transformer.GsonTransformer;
import spark.Request;
import spark.Response;
import spark.Spark;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;

@SparkController
public class UserSessionController {
    private final static String JWT_ISSUER = "SpendSpentSpent";

    @SparkBefore("/Login")
    public void loginHeader(@SparkHeader("origin") String origin, Request req, Response res) {

        if (!req.requestMethod().equalsIgnoreCase("OPTIONS")) {
            res.header("Access-Control-Allow-Origin", origin);
            res.type("application/json");
        }
    }

    /**
     * Logs in a user
     *
     * @return the user session with the token
     * @throws SQLException
     */
    @SparkPost(value = "/Login", transformer = GsonTransformer.class)
    public String logIn(@SparkBody(GsonBodyTransformer.class) UserCredentials creds) throws SQLException {

        try {
            if (creds.username.equalsIgnoreCase(SettingsController.get(Setting.USERNAME)) && SettingsController.hashString(creds.password).equalsIgnoreCase(SettingsController.get(Setting.PASSWORD))) {
                LocalDateTime in3Month = LocalDateTime.now().plusMonths(3);

                Algorithm algorithm = Algorithm.HMAC256(Constants.SALT);

                return JWT.create()
                        .withIssuer(JWT_ISSUER)
                        .withExpiresAt(Date.from(in3Month.atZone(ZoneId.systemDefault()).toInstant()))
                        .sign(algorithm);

            } else {
                Spark.halt(401, "Wrong login or password");
            }
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            Spark.halt(503, e.getMessage());
        }

        return null;
    }

    public void verifyToken(String token) {
        Algorithm algorithm = Algorithm.HMAC256(Constants.SALT);
        JWTVerifier verifier = JWT.require(algorithm)
                .withIssuer(JWT_ISSUER)
                .build(); //Reusable verifier instance
        DecodedJWT jwt = verifier.verify(token);

    }


    public static class UserCredentials {
        public String username, password;
    }

}
