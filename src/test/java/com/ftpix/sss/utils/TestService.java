package com.ftpix.sss.utils;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.CategoryRepository;
import com.ftpix.sss.persistence.UserRepository;
import com.ftpix.sss.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;


@Service
public class TestService {
    private final UserService userService;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;

    @Autowired
    public TestService(UserService userService, UserRepository userRepository, CategoryRepository categoryRepository) {
        this.userService = userService;
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
    }

    public User create(String email, boolean admin, String... categories) throws NoSuchAlgorithmException, SQLException {
        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail(email);
        user.setAdmin(admin);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        user = userRepository.save(user);

        for (String cat : categories) {
            Category newCat = new Category();
            newCat.setIcon(cat);
            newCat.setUser(user);

            categoryRepository.save(newCat);
        }

        return user;
    }
}
