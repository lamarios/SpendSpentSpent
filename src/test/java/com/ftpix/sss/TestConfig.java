package com.ftpix.sss;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.UserService;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;


@TestConfiguration
@PropertySource("classpath:application.properties")
public class TestConfig {


    @Bean
    public User currentUser(UserService userService, UserDao userDaoJooq, CategoryDao categoryDaoJooq) throws NoSuchAlgorithmException, SQLException {

        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail("test@example.org");
        user.setAdmin(true);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        userDaoJooq.insert(user);

        return user;
    }
}
