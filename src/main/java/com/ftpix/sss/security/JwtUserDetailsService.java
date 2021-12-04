package com.ftpix.sss.security;

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

    @Autowired
    public JwtUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        try {
            return Optional.ofNullable(userService.getByEmail(email))
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

