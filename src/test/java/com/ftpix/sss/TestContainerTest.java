package com.ftpix.sss;

import com.ftpix.sss.dao.CategoryDao;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;
import org.jooq.impl.DefaultDSLContext;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Testcontainers;

import static com.ftpix.sss.dsl.Tables.*;


@SpringBootTest(classes = App.class)
@Testcontainers
abstract public class TestContainerTest {

    private final static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:17");

    static {
        postgres.start();
    }

    @Autowired
    private DefaultDSLContext dslContext;

    @Autowired
    private User currentUser;

    @Autowired
    private CategoryDao categoryDaoJooq;

    @DynamicPropertySource
    static void configureSQLContainer(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
        registry.add("spring.flyway.url", postgres::getJdbcUrl);
        registry.add("spring.flyway.user", postgres::getUsername);
        registry.add("spring.flyway.password", postgres::getPassword);
    }

    @AfterEach
    public void cleaningDB() {
        dslContext.truncate(EXPENSE).cascade().execute();
        dslContext.truncate(CATEGORY).cascade().execute();
        dslContext.truncate(RECURRING_EXPENSE).cascade().execute();
    }

    @BeforeEach
    public void insertBaseData() {
        Category house = new Category();
        house.setIcon("house");
        house.setUser(currentUser);

        Category cloth = new Category();
        cloth.setIcon("cloth");
        cloth.setUser(currentUser);

        Category cloud = new Category();
        cloud.setIcon("cloud");
        cloud.setUser(currentUser);

        categoryDaoJooq.insert(currentUser, house);
        categoryDaoJooq.insert(currentUser, cloud);
        categoryDaoJooq.insert(currentUser, cloth);
    }


    @Test
    void test() {
        System.out.println(postgres.getMappedPort(5432));
        Assertions.assertTrue(postgres.isRunning());
    }
}
