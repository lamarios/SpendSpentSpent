package com.ftpix.sss;


import com.ftpix.sss.models.*;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
import org.jooq.CloseableDSLContext;
import org.jooq.DSLContext;
import org.jooq.impl.DSL;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@Configuration
public class DbConfig implements ApplicationListener<ApplicationReadyEvent> {
    private final static int DB_VERSION = 8;
    @Value("${DB_PATH:./SSS}")
    private String dbPath;
    @Value("${DB_USER:}")
    private String dbUsername;
    @Value("${DB_PASSWORD:}")
    private String dbPassword;

    @Bean
    public ConnectionSource connectionSource(String jdbcUrl) throws SQLException {
        return new JdbcConnectionSource(jdbcUrl, dbUsername, dbPassword);
    }

    @Bean
    public String jdbcUrl() {
        if (!dbPath.startsWith("jdbc:")) {
            return "jdbc:h2:" + dbPath;
        } else {
            return dbPath;
        }
    }

    @Bean
    public Dao<Category, Long> categoryDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<Category, Long> dao = DaoManager.createDao(connectionSource, Category.class);
        TableUtils.createTableIfNotExists(connectionSource, Category.class);
        return dao;
    }

    @Bean
    public Dao<Expense, Long> expenseDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<Expense, Long> dao = DaoManager.createDao(connectionSource, Expense.class);
        TableUtils.createTableIfNotExists(connectionSource, Expense.class);
        return dao;
    }

    @Bean
    public Dao<RecurringExpense, Long> recurringExpenseDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<RecurringExpense, Long> dao = DaoManager.createDao(connectionSource, RecurringExpense.class);
        TableUtils.createTableIfNotExists(connectionSource, RecurringExpense.class);
        return dao;
    }

    @Bean
    public Dao<SchemaVersion, Long> schemaDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<SchemaVersion, Long> dao = DaoManager.createDao(connectionSource, SchemaVersion.class);
        TableUtils.createTableIfNotExists(connectionSource, SchemaVersion.class);
        return dao;
    }

    @Bean
    public Dao<User, UUID> userDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<User, UUID> dao = DaoManager.createDao(connectionSource, User.class);
        TableUtils.createTableIfNotExists(connectionSource, User.class);
        return dao;
    }

    @Bean
    public Dao<ResetPassword, UUID> resetPasswordDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<ResetPassword, UUID> dao = DaoManager.createDao(connectionSource, ResetPassword.class);
        TableUtils.createTableIfNotExists(connectionSource, ResetPassword.class);
        return dao;
    }


    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
        final ConnectionSource connectionSource = applicationReadyEvent.getApplicationContext().getBean(ConnectionSource.class);
        Dao<SchemaVersion, Long> schemaDao = (Dao<SchemaVersion, Long>) applicationReadyEvent.getApplicationContext().getBean("schemaDao");
        Dao<Category, Long> categoryDao = (Dao<Category, Long>) applicationReadyEvent.getApplicationContext().getBean("categoryDao");

        final String jdbcUrl = (String) applicationReadyEvent.getApplicationContext().getBean("jdbcUrl");

        Integer schemaVersion = null;
        try {
            schemaVersion = schemaDao.queryBuilder()
                    .orderBy("CURRENT", false)
                    .query()
                    .stream()
                    .findFirst()
                    .map(SchemaVersion::getCurrent)
                    .orElse(DB_VERSION);


            int newVersion = schemaVersion;


            if (schemaVersion < 4) {
                schemaDao.executeRaw("ALTER TABLE expense ADD COLUMN IF NOT EXISTS NOTE TEXT");
                newVersion = 4;
            }


            if (schemaVersion < 5) {
                schemaDao.executeRaw("ALTER TABLE expense ADD COLUMN IF NOT EXISTS TIME VARCHAR(5)");
                newVersion = 5;
            }

            if (schemaVersion < 6) {
                newVersion = 6;
                List<Category> categories = categoryDao.queryForAll();

                for (int i = 0; i < categories.size(); i++) {
                    Category cat = categories.get(i);
                    cat.setCategoryOrder(i);
                    categoryDao.update(cat);
                }
            }

            if (schemaVersion < 7) {
                newVersion = 7;
                TableUtils.dropTable(connectionSource, UserSession.class, true);
            }

            if (schemaVersion < 8) {
                newVersion = 8;
                schemaDao.executeRaw("ALTER TABLE category ADD COLUMN IF NOT EXISTS USER_ID VARCHAR(36)");
            }

            // since we ow support more than one DB types, future migration should happen using jooq
            // final DSLContext jooq = DSL.using(jdbcUrl, dbUsername, dbPassword);

            TableUtils.clearTable(connectionSource, SchemaVersion.class);
            schemaDao.create(new SchemaVersion(newVersion));
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Couldn't migrate schema");
        }
    }
}
