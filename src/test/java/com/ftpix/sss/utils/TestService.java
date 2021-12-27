package com.ftpix.sss.utils;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.UserService;
import com.j256.ormlite.dao.Dao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;


@Service
public class TestService {
    private final UserService userService;
    private final Dao<User, UUID> userDao;
    private final Dao<Category, Long> categoryDao;

    @Autowired
    public TestService(UserService userService, Dao<User, UUID> userDao, Dao<Category, Long> categoryDao) {
        this.userService = userService;
        this.userDao = userDao;
        this.categoryDao = categoryDao;
    }

    public User create(String email, boolean admin, String... categories) throws NoSuchAlgorithmException, SQLException {
        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail(email);
        user.setAdmin(admin);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        userDao.create(user);

        for (String cat : categories) {
            Category newCat = new Category();
            newCat.setIcon(cat);
            newCat.setUser(user);

            categoryDao.create(newCat);
        }

        return user;
    }
}
