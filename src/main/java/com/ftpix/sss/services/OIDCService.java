package com.ftpix.sss.services;

import com.ftpix.sss.models.OIDCConfig;
import com.ftpix.sss.models.User;
import com.google.gson.Gson;
import io.jsonwebtoken.Identifiable;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Jwk;
import io.jsonwebtoken.security.Jwks;
import kong.unirest.GetRequest;
import kong.unirest.Unirest;
import kong.unirest.UnirestException;
import kong.unirest.json.JSONObject;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import static java.util.stream.Collectors.toMap;

@Service
public class OIDCService implements ApplicationContextAware {
    public static final String GIVEN_NAME_CLAIM = "given_name";
    public static final String FAMILY_NAME_CLAIM = "family_name";
    @Value("${OIDC_DISCOVERY_URL:}")
    private String oidcDiscoveryUrl;

    @Value("${OIDC_AUTO_SIGNUP_USERS:0}")
    private boolean autoSignUpUsers;

    @Value("${OIDC_CLIENT_ID:}")
    private String clientId;

    @Value("${OIDC_EMAIL_CLAIM:email}")
    private String oidcEmailClaim;

    @Value("${OIDC_NAME:SSO}")
    private String oidcName;

    private JwtParser parser;

    private OIDCConfig oidcConfig;


    private final UserService userService;

    @Autowired
    public OIDCService(UserService userService) {
        this.userService = userService;
    }

    public String getOidcDiscoveryUrl() {
        return oidcDiscoveryUrl;
    }

    public OIDCConfig getOidcConfig() {
        return oidcConfig;
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {

        if (oidcDiscoveryUrl != null && !oidcDiscoveryUrl.isBlank()) {
            GetRequest request = Unirest.get(oidcDiscoveryUrl);
            try {
                var body = request.asString();

                Gson gson = new Gson();
                oidcConfig = gson.fromJson(body.getBody(), OIDCConfig.class);

                request = Unirest.get(oidcConfig.getJwksUri());

                oidcConfig.setDiscoveryUrl(oidcDiscoveryUrl);
                oidcConfig.setClientId(clientId);
                oidcConfig.setEmailClaim(oidcEmailClaim);
                oidcConfig.setName(oidcName);

                var keyMap = Jwks.setParser()
                        .build()
                        .parse(request.asString().getBody())
                        .getKeys()
                        .stream()
                        .collect(toMap(Identifiable::getId, Jwk::toKey));

                parser = Jwts.parser()
                        .keyLocator(header -> keyMap.get(header.getOrDefault("kid", "").toString()))
                        .build();


            } catch (UnirestException e) {
                throw new RuntimeException(e);
            }
        }
    }


    public JwtParser getParser() {
        return parser;
    }

    public void setParser(JwtParser parser) {
        this.parser = parser;
    }

    public String getOidcEmailClaim() {
        return oidcEmailClaim;
    }

    public User handleUserSub(String sub, String accessToken) throws Exception {
        // check DB if we have  auser with this sub
        var user = userService.getByOidcSub(sub);

        // if we don't get the info
        if (user == null) {

            GetRequest request = Unirest.get(oidcConfig.getUserInfoUrl())
                    .header("Authorization", "Bearer " + accessToken);
            var body = request.asJson().getBody();

            JSONObject object = body.getObject();
            if (object.has(oidcEmailClaim)) {
                user = userService.getByEmail(object.getString(oidcEmailClaim));

                // if we still don't have  auser we might need to sign it up
                if (user != null) {
                    user.setOidcSub(sub);
                    return userService.updateUser(user);
                } else if (autoSignUpUsers) {
                    user = new User();
                    user.setOidcSub(sub);
                    user.setEmail(object.getString(oidcEmailClaim));
                    user.setFirstName(object.has(GIVEN_NAME_CLAIM) && !object.getString(GIVEN_NAME_CLAIM)
                            .isEmpty() ? object.getString(GIVEN_NAME_CLAIM) : "New");
                    user.setLastName(object.has(FAMILY_NAME_CLAIM) && !object.getString(FAMILY_NAME_CLAIM)
                            .isEmpty() ? object.getString(FAMILY_NAME_CLAIM) : "User");


                    return userService.createUser(user);
                } else {
                    throw new Exception();
                }

            } else {
                throw new Exception();
            }

        } else {
            return user;
        }
    }
}
