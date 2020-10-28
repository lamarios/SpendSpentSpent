package com.ftpix.sss;

import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.UserService;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;


@TestConfiguration
public class TestConfig {

    @Bean
    public User currentUser(UserService userService) throws NoSuchAlgorithmException, SQLException {

        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail("test@example.org");
        user.setAdmin(true);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        DB.USER_DAO.create(user);


        Category anchor = new Category();
        anchor.setId(1);
        anchor.setIcon("icon-anchor");
        anchor.setUser(user);

        Category violin = new Category();
        violin.setId(2);
        violin.setIcon("icon-violin");
        violin.setUser(user);

        Category gas = new Category();
        gas.setId(3);
        gas.setIcon("icon-gas");
        gas.setUser(user);

        DB.CATEGORY_DAO.create(List.of(anchor, violin, gas));

        return user;
    }
}
