package com.ftpix.sss;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.UserService;
import com.j256.ormlite.dao.Dao;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;


@TestConfiguration
@PropertySource("classpath:application.properties")
public class TestConfig {


    @Bean
    public User currentUser(UserService userService, Dao<User, UUID> userDao, Dao<Category, Long> categoryDao) throws NoSuchAlgorithmException, SQLException {

        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail("test@example.org");
        user.setAdmin(true);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        userDao.create(user);


        Category anchor = new Category();
        anchor.setId(1L);
        anchor.setIcon("icon-anchor");
        anchor.setUser(user);

        Category violin = new Category();
        violin.setId(2L);
        violin.setIcon("icon-violin");
        violin.setUser(user);

        Category gas = new Category();
        gas.setId(3L);
        gas.setIcon("icon-gas");
        gas.setUser(user);

        categoryDao.create(List.of(anchor, violin, gas));

        return user;
    }
}
