package com.ftpix.sss;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.dao.UserDao;
import com.ftpix.sss.models.User;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.SettingsService;
import com.ftpix.sss.services.UserService;
import com.ftpix.sss.utils.UserServiceMock;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.time.ZoneId;


@TestConfiguration
@PropertySource("classpath:application.properties")
public class TestConfig {

    @Bean
    public UserService userService(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService, CategoryDao categoryDaoJooq, EmailService emailService, SettingsService settingsService, UserDao userDaoJooq) {
        return new UserServiceMock(recurringExpenseService, expenseService, categoryService, categoryDaoJooq, emailService, settingsService, userDaoJooq);
    }

    @Bean
    @Primary
    public ZoneId zoneId(){
        return ZoneId.systemDefault();
    }

    @Bean
    public User currentUser(UserService userService, UserDao userDaoJooq) throws NoSuchAlgorithmException {

        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail("test@example.org");
        user.setAdmin(true);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        userDaoJooq.insert(user);

        ((UserServiceMock) userService).setCurrentUser(user);

        return user;
    }
}
