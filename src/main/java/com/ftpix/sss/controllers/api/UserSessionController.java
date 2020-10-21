package com.ftpix.sss.controllers.api;


import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.User;
import com.ftpix.sss.transformer.GsonBodyTransformer;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Request;
import spark.Response;
import spark.Spark;

import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.function.Supplier;

@SparkController
public class UserSessionController {
    public final static String EMAIL_REGEX = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    private final static Logger logger = LogManager.getLogger();
    public final static Supplier<? extends Exception> UNAUTHORIZED_SUPPLIER = () -> {
        logger.error("Access not allowed");
//        Spark.halt(401);
        return new IllegalAccessException("Unauthorized access");
    };
    private final static Algorithm JWT_ALGORITHM = Algorithm.HMAC256(Constants.SALT);
    private final static String JWT_ISSUER = "SpendSpentSpent";
    private final static JWTVerifier JWT_VERIFIER = JWT.require(JWT_ALGORITHM)
            .withIssuer(JWT_ISSUER)
            .build(); //Reusable verifier instance

    public static Optional<User> getCurrentUser(String token) {
        final DecodedJWT decodedJWT = verifyToken(token);
        return Optional.ofNullable(decodedJWT.getClaim("user"))
                .map(Claim::asMap)
                .map(c -> c.get("id"))
                .map(id -> (String) id)
                .map(id -> {
                    try {
                        return DB.USER_DAO.queryForId(UUID.fromString(id));
                    } catch (SQLException throwables) {
                        logger.error("Couldn't get user", throwables);
                        return null;
                    }
                });
    }

    public static DecodedJWT verifyToken(String token) {
        return JWT_VERIFIER.verify(token);
    }

    @SparkBefore("/Login")
    public void loginHeader(@SparkHeader("origin") String origin, Request req, Response res) {
        if (!req.requestMethod().equalsIgnoreCase("OPTIONS")) {
            res.header("Access-Control-Allow-Origin", origin);
            res.type("application/json");
        }
    }

    @SparkBefore("/SignUp")
    public void signUpHeader(@SparkHeader("origin") String origin, Request req, Response res) {
        loginHeader(origin, req, res);
    }

    /**
     * Logs in a user
     *
     * @return the user session with the token
     * @throws SQLException
     */
    @SparkPost(value = "/Login", transformer = GsonTransformer.class)
    public String logIn(@SparkBody(GsonBodyTransformer.class) UserCredentials creds) throws SQLException {

        final UserController controller = Sparknotation.getController(UserController.class);
        return controller.getByEmail(creds.email)
                .filter(u -> {
                    try {
                        final SettingsController settingsController = Sparknotation.getController(SettingsController.class);
                        final String hash = settingsController.hashUserCredentials(creds.email, creds.password);

                        return u.getPassword().equalsIgnoreCase(hash);
                    } catch (NoSuchAlgorithmException e) {
                        logger.error("Couldn't hash string", e);
                        return false;
                    }
                })
                .map(this::createTokenForUser)
                .orElseGet(() -> {
                    Spark.halt(401, "Wrong login or password");
                    return "Wrong login or password";
                });
    }

    public String createTokenForUser(User user) {
        LocalDateTime in3Month = LocalDateTime.now().plusMonths(3);

        Map<String, Object> userClaim = new HashMap<>();
        userClaim.put("id", user.getId().toString());
        userClaim.put("isAdmin", user.isAdmin());
        userClaim.put("firstName", user.getFirstName());
        userClaim.put("lastName", user.getLastName());
        userClaim.put("subscriptionExpiry", user.getSubscriptionExpiryDate());
        userClaim.put("email", user.getEmail());

        final String token = JWT.create()
                .withIssuer(JWT_ISSUER)
                .withClaim("user", userClaim)
                .withExpiresAt(Date.from(in3Month.atZone(ZoneId.systemDefault()).toInstant()))
                .sign(JWT_ALGORITHM);

        return token;
    }


    @SparkPost(value = "/SignUp", transformer = GsonTransformer.class)
    public String signUp(@SparkBody(GsonBodyTransformer.class) User user) throws SQLException, NoSuchAlgorithmException {
        if (!Constants.ALLOW_SIGNUP) {
            Spark.halt(400, "Signups not allowed");
        }

        User newUser = Sparknotation.getController(UserController.class).createUser(user);

        return createTokenForUser(newUser);
    }

    public static class UserCredentials {
        public String email, password;
    }

}
