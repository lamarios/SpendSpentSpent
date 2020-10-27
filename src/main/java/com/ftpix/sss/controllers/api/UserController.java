package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.User;
import com.ftpix.sss.security.JwtTokenUtil;
import com.ftpix.sss.security.JwtUserDetailsService;
import com.ftpix.sss.services.UserService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/API/User")
public class UserController {
    private final static Logger logger = LogManager.getLogger();

    private final UserService userService;
    private final JwtTokenUtil jwtTokenUtil;
    private final JwtUserDetailsService jwtUserDetailsService;

    @Autowired
    public UserController(UserService userService, JwtTokenUtil jwtTokenUtil, JwtUserDetailsService jwtUserDetailsService) {
        this.userService = userService;
        this.jwtTokenUtil = jwtTokenUtil;
        this.jwtUserDetailsService = jwtUserDetailsService;
    }

    @PostMapping
    public String updateUser(@RequestBody User user) throws Exception {
        final User currentUser = userService.getCurrentUser();

        if (user.getFirstName() == null || user.getFirstName().length() == 0 || user.getLastName() == null || user.getLastName().length() == 0) {
            throw new Exception("first name and lat name can't be empty");
        }

        currentUser.setFirstName(user.getFirstName());
        currentUser.setLastName(user.getLastName());

        if (user.getPassword() != null && user.getPassword().length() > 0) {
            currentUser.setPassword(userService.hashUserCredentials(currentUser.getEmail(), user.getPassword()));
        }

        currentUser.update();

        final UserDetails userDetails = jwtUserDetailsService
                .loadUserByUsername(currentUser.getEmail());

        final String token = jwtTokenUtil.generateToken(userDetails);
        return token;
    }

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public List<User> getUsers() throws Exception {
        return userService.getAll();
    }

    @GetMapping(value = "/{userId}/setAdmin/{isAdmin}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public boolean setAdmin(@PathVariable("userId") String userId, @PathVariable("isAdmin") boolean isAdmin) throws Exception {
        final User user = userService.getCurrentUser();

        if (user.getId().toString().equals(userId) && !isAdmin) {
            throw new Exception("You can't remove admin rights to yourself");
        }

        return Optional.ofNullable(userService.getById(UUID.fromString(userId)))
                .map(u -> {
                    u.setAdmin(isAdmin);
                    try {
                        u.update();
                        return true;
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).orElse(false);

    }

    @PostMapping("/{userId}/setPassword")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public boolean setPassword(@PathVariable("userId") String userId, @RequestBody String newPassword) throws Exception {

        return Optional.ofNullable(userService.getById(UUID.fromString(userId)))
                .map(u -> {
                    try {
                        u.setPassword(userService.hashUserCredentials(u.getEmail(), newPassword));
                        u.update();
                        return true;
                    } catch (NoSuchAlgorithmException | SQLException e) {
                        throw new RuntimeException(e);
                    }
                }).orElse(false);
    }

    @PutMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public User addUser(@RequestBody User user) throws Exception {
        return userService.createUser(user);
    }


    @DeleteMapping(value = "/{userId}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public boolean deleteUser(@PathVariable("userId") String userId) throws Exception {
        User currentUser = userService.getCurrentUser();
        // deleting all the data
        return userService.deleteUser(userId, currentUser);

    }

}
