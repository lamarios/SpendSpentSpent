package com.ftpix.sss;

import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.ExpenseService;
import com.ftpix.sss.services.SettingsService;
import com.ftpix.sss.services.UserService;
import com.ftpix.sss.utils.MockEmailService;
import com.ftpix.sss.utils.UserServiceMock;
import freemarker.template.Configuration;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;

import java.security.NoSuchAlgorithmException;
import java.time.ZoneId;


@TestConfiguration
@PropertySource("classpath:application.properties")
public class TestConfig {

    @Bean
    public UserService userService(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService, EmailService emailService, SettingsService settingsService, CategoryRepository categoryRepository, UserRepository userRepository) {
        return new UserServiceMock(recurringExpenseService,expenseService,categoryService,emailService,settingsService,userRepository,categoryRepository);
    }

    @Bean
    @Primary
    public ZoneId zoneId() {
        return ZoneId.systemDefault();
    }

/*
    @Bean
    public User currentUser(UserService userService, UserRepository userRepository) throws NoSuchAlgorithmException {

        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail("test@example.org");
        user.setAdmin(true);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        userRepository.save(user);

        ((UserServiceMock) userService).setCurrentUser(user);

        return user;
    }
*/


    @Bean
    public EmailService emailService(Configuration templateEngine) {
        return new MockEmailService(templateEngine);
    }
}
