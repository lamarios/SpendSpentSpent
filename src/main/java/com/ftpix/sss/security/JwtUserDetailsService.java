package com.ftpix.sss.security;

import com.ftpix.sss.services.OIDCService;
import com.ftpix.sss.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class JwtUserDetailsService implements UserDetailsService {
    private final UserService userService;
    private final static String EMAIL_REGEX = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

    private final OIDCService oidcService;

    @Autowired
    public JwtUserDetailsService(UserService userService, OIDCService oidcService) {
        this.userService = userService;
        this.oidcService = oidcService;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
       return loadUserByUsername(email, null);
    }

    public UserDetails loadUserByUsername(String email, String accessToken) throws UsernameNotFoundException {
        try {
            com.ftpix.sss.models.User user = null;
            if (email.matches(EMAIL_REGEX)) {
                user = userService.getByEmail(email);
            } else if (oidcService.getParser() != null) {
                user = oidcService.handleUserSub(email, accessToken);
            } else {
                throw new Exception();
            }

            return Optional.ofNullable(user)
                    .map(u -> {
                        List<GrantedAuthority> authorityList = new ArrayList<>();
                        if (u.isAdmin()) {
                            authorityList.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                        }
                        return new User(u.getEmail(), u.getPassword(), authorityList);
                    })
                    .orElseThrow(() -> new UsernameNotFoundException("No user with email " + email));
        } catch (Exception e) {
            throw new UsernameNotFoundException("No user with email " + email);
        }
    }

}

