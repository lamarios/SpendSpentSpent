package com.ftpix.sss;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import com.ftpix.sss.persistence.*;
import com.ftpix.sss.services.EmailService;
import com.ftpix.sss.services.UserService;
import com.ftpix.sss.utils.MockEmailService;
import com.ftpix.sss.utils.UserServiceMock;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.postgresql.PostgreSQLContainer;

import java.security.NoSuchAlgorithmException;


@SpringBootTest(classes = App.class, properties = {"spring.main.allow-bean-definition-overriding=true", "ALLOW_SIGNUP=1"})
@Testcontainers
abstract public class TestContainerTest {

    private final static PostgreSQLContainer postgres = new PostgreSQLContainer("postgres:17");

    static {
        postgres.start();
    }

    protected User currentUser;

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private ExpenseRepository expenseRepository;
    @Autowired
    private FilesRepository filesRepository;
    @Autowired
    private HouseholdMemberRepository householdMemberRepository;
    @Autowired
    private HouseholdRepository householdRepository;
    @Autowired
    private ApiKeyRepository apiKeyRepository;
    @Autowired
    private EmailService emailService;

    @DynamicPropertySource
    static void configureSQLContainer(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
        registry.add("spring.flyway.url", postgres::getJdbcUrl);
        registry.add("spring.flyway.user", postgres::getUsername);
        registry.add("spring.flyway.password", postgres::getPassword);
    }


    @BeforeEach
    public void insertBaseData() throws NoSuchAlgorithmException {
        String random = RandomStringUtils.secure().nextAlphabetic(10); // from Apache Commons Lang
        User user = new User();
        user.setFirstName("Tester");
        user.setLastName("Super");
        user.setEmail(random+"@example.org");
        user.setAdmin(true);
        user.setPassword(userService.hashUserCredentials(user.getEmail(), "pass"));
        user.setSubscriptionExpiryDate(Long.MAX_VALUE);
        currentUser = userRepository.save(user);

        ((UserServiceMock) userService).setCurrentUser(currentUser);

        Category house = new Category();
        house.setIcon("house");
        house.setUser(currentUser);

        Category cloth = new Category();
        cloth.setIcon("cloth");
        cloth.setUser(currentUser);

        Category cloud = new Category();
        cloud.setIcon("cloud");
        cloud.setUser(currentUser);

        categoryRepository.save(house);
        categoryRepository.save(cloud);
        categoryRepository.save(cloth);
    }

    @AfterEach
    public void truncateData(){
        apiKeyRepository.deleteAll();
        householdMemberRepository.deleteAll();
        householdRepository.deleteAll();
        filesRepository.deleteAll();
        expenseRepository.deleteAll();
        categoryRepository.deleteAll();
        userRepository.deleteAll();
        MockEmailService mockMail = (MockEmailService) emailService;
        mockMail.getEmails().clear();
    }

}
