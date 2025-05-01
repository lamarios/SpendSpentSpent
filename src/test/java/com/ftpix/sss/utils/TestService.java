package com.ftpix.sss.utils;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;


@Service
public class TestService {
    private final UserService userService;
    private final UserDao userDaoJooq;
    private final CategoryDao categoryDaoJooq;


    @Autowired
    public TestService(UserService userService, UserDao userDaoJooq, CategoryDao categoryDaoJooq) {
        this.userService = userService;
        this.userDaoJooq = userDaoJooq;
        this.categoryDaoJooq = categoryDaoJooq;
    }

    public User create(String email, boolean admin, String... categories) throws NoSuchAlgorithmException, SQLException {
        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail(email);
        user.setAdmin(admin);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        user = userDaoJooq.insert(user);

        for (String cat : categories) {
            Category newCat = new Category();
            newCat.setIcon(cat);
            newCat.setUser(user);

            categoryDaoJooq.insert(user, newCat);
        }

        return user;
    }
}
