package com.ftpix.sss.security;

import com.ftpix.sss.models.User;
import com.ftpix.sss.services.Encryption;
import com.ftpix.sss.services.OIDCService;
import com.ftpix.sss.services.UserService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.xml.bind.DatatypeConverter;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.io.Serializable;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtTokenUtil implements Serializable, ApplicationContextAware {
    private final SecretKey key;

    public static final long JWT_TOKEN_VALIDITY = 90 * 24 * 60 * 60;
    private static final long serialVersionUID = -2550185165626007488L;


    private final String salt;

    private final OIDCService oidcService;


    private final UserService userService;

    @Autowired
    public JwtTokenUtil(OIDCService oidcService, UserService userService, @Value("${SALT}") String salt) throws Exception {
        this.oidcService = oidcService;
        this.userService = userService;
        this.salt = salt;

        this.key = deriveKey(salt);

    }

    private static SecretKey deriveKey(String salt) throws Exception {

        // If shorter than 64 bytes, repeat until length ≥ 64
        byte[] saltBytes = salt.getBytes();
        if (saltBytes.length < 64) {
            byte[] extended = new byte[64];
            for (int i = 0; i < 64; i++) {
                extended[i] = saltBytes[i % saltBytes.length];
            }
            saltBytes = extended;
        } else if (saltBytes.length > 64) {
            // Truncate to 64 bytes if longer
            saltBytes = Arrays.copyOf(saltBytes, 64);
        }

        return new SecretKeySpec(saltBytes, "HmacSHA512");
    }


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
        try {
            return Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload();
        } catch (Exception e) {
            if (oidcService.getParser() != null) {
                return oidcService.getParser().parseSignedClaims(token).getPayload();
            } else {
                throw e;
            }
        }
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
        return Jwts.builder()
                .claims(claims).subject(subject).issuedAt(new Date(System.currentTimeMillis()))
                .issuer("SpendSpentSpent")
                .expiration(new Date(System.currentTimeMillis() + JWT_TOKEN_VALIDITY * 1000)).signWith(key).compact();
    }

    public Boolean canTokenBeRefreshed(String token) {
        return (!isTokenExpired(token) || ignoreTokenExpiration(token));
    }

    public Boolean validateToken(String token, UserDetails userDetails) throws SQLException {
        final String username = getUsernameFromToken(token);
        var user = userService.getByEmail(userDetails.getUsername());
        return ((username.equals(userDetails.getUsername()) || username.equalsIgnoreCase(user.getOidcSub())) && !isTokenExpired(token));
    }

    public String getSalt() {
        return salt;
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        final JwtTokenUtil bean = applicationContext.getBean(JwtTokenUtil.class);

        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(bean.getSalt().getBytes());
            byte[] digest = md.digest();
            String myHash = DatatypeConverter
                    .printHexBinary(digest);

            Encryption.SALT = myHash.substring(0, 16);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}

