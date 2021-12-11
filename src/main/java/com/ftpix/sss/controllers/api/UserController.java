package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.PaginatedResults;
import com.ftpix.sss.models.User;
import com.ftpix.sss.security.JwtTokenUtil;
import com.ftpix.sss.security.JwtUserDetailsService;
import com.ftpix.sss.services.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiParam;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/API/User")
@Api(tags = {"Users"})
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
    public String updateProfile(@RequestBody User user) throws Exception {
        final User currentUser = userService.getCurrentUser();

        userService.updateUserProfile(currentUser, user);

        final UserDetails userDetails = jwtUserDetailsService
                .loadUserByUsername(currentUser.getEmail());

        final String token = jwtTokenUtil.generateToken(userDetails);
        return token;
    }

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public PaginatedResults<User> getUsers(@ApiParam("Page starts from 0") @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int pageSize, @RequestParam(defaultValue = "") String search) throws Exception {
        return userService.getAll(search, page, pageSize);
    }

    @GetMapping(value = "/{userId}/setAdmin/{isAdmin}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public boolean setAdmin(@PathVariable("userId") String userId, @PathVariable("isAdmin") boolean isAdmin) throws Exception {
        final User user = userService.getCurrentUser();

        return userService.setUserAdmin(userId, isAdmin, user);

    }

    @PostMapping("/{userId}/setPassword")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public boolean setPassword(@PathVariable("userId") String userId, @RequestBody String newPassword) throws Exception {
        return userService.setUserPassword(userId, newPassword);
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
