package com.ftpix.sss.security;

import com.ftpix.sss.models.User;
import com.ftpix.sss.services.Encryption;
import com.ftpix.sss.services.UserService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.xml.bind.DatatypeConverter;
import java.io.Serializable;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtTokenUtil implements Serializable, ApplicationContextAware {

    public static final long JWT_TOKEN_VALIDITY = 90 * 24 * 60 * 60;
    private static final long serialVersionUID = -2550185165626007488L;


    @Value("${SALT}")
    private String salt;
    private String encodedSalt;

    @Autowired
    private UserService userService;

    public String getUsernameFromToken(String token) {
        return getClaimFromToken(token, Claims::getSubject);
    }

    public Date getIssuedAtDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getIssuedAt);
    }

    public Date getExpirationDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getExpiration);
    }

    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }

    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parser().setSigningKey(encodedSalt).parseClaimsJws(token).getBody();
    }

    private Boolean isTokenExpired(String token) {
        final Date expiration = getExpirationDateFromToken(token);
        return expiration.before(new Date());
    }

    private Boolean ignoreTokenExpiration(String token) {
        // here you specify tokens, for that the expiration is ignored
        return false;
    }

    public String generateToken(UserDetails userDetails) {
        try {
            User user = userService.getByEmail(userDetails.getUsername());
            Map<String, Object> userClaim = new HashMap<>();
            userClaim.put("id", user.getId().toString());
            userClaim.put("isAdmin", user.isAdmin());
            userClaim.put("firstName", user.getFirstName());
            userClaim.put("lastName", user.getLastName());
            userClaim.put("subscriptionExpiry", user.getSubscriptionExpiryDate());
            userClaim.put("email", user.getEmail());

            Map<String, Object> claims = new HashMap<>();
            claims.put("user", userClaim);
            return doGenerateToken(claims, userDetails.getUsername());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String doGenerateToken(Map<String, Object> claims, String subject) {
        return Jwts.builder().setClaims(claims).setSubject(subject).setIssuedAt(new Date(System.currentTimeMillis()))
                .setIssuer("SpendSpentSpent")
                .setExpiration(new Date(System.currentTimeMillis() + JWT_TOKEN_VALIDITY * 1000)).signWith(SignatureAlgorithm.HS512, encodedSalt).compact();
    }

    public Boolean canTokenBeRefreshed(String token) {
        return (!isTokenExpired(token) || ignoreTokenExpiration(token));
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = getUsernameFromToken(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    public void encodeSalt() {
        encodedSalt = Base64.getEncoder().encodeToString(salt.getBytes());
    }

    public String getSalt() {
        return salt;
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        final JwtTokenUtil bean = applicationContext.getBean(JwtTokenUtil.class);
        bean.encodeSalt();

        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(bean.getSalt().getBytes());
            byte[] digest = md.digest();
            String myHash = DatatypeConverter
                    .printHexBinary(digest).toUpperCase();

            Encryption.SALT = salt.substring(0, 16);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}

