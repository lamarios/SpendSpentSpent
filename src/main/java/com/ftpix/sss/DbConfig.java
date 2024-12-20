package com.ftpix.sss;


import com.ftpix.sss.dao.ExpenseDao;
import com.ftpix.sss.models.*;
import com.ftpix.sss.services.HistoryService;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jooq.AlterTableAddStep;
import org.jooq.CloseableDSLContext;
import org.jooq.impl.DSL;
import org.jooq.impl.DefaultDSLContext;
import org.jooq.impl.SQLDataType;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.time.Year;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Configuration
public class DbConfig implements ApplicationListener<ApplicationReadyEvent> {
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final static int DB_VERSION = 11;
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
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, Category.class);
        }
        return dao;
    }

    @Bean
    public Dao<Expense, Long> expenseDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<Expense, Long> dao = DaoManager.createDao(connectionSource, Expense.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, Expense.class);
        }
        return dao;
    }

    @Bean
    public Dao<RecurringExpense, Long> recurringExpenseDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<RecurringExpense, Long> dao = DaoManager.createDao(connectionSource, RecurringExpense.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, RecurringExpense.class);
        }
        return dao;
    }

    @Bean
    public Dao<SchemaVersion, Long> schemaDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<SchemaVersion, Long> dao = DaoManager.createDao(connectionSource, SchemaVersion.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, SchemaVersion.class);
        }
        return dao;
    }

    @Bean
    public Dao<User, UUID> userDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<User, UUID> dao = DaoManager.createDao(connectionSource, User.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, User.class);
        }
        return dao;
    }

    @Bean
    public Dao<ResetPassword, UUID> resetPasswordDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<ResetPassword, UUID> dao = DaoManager.createDao(connectionSource, ResetPassword.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, ResetPassword.class);
        }
        return dao;
    }

    @Bean
    public Dao<Settings, String> settingsDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<Settings, String> dao = DaoManager.createDao(connectionSource, Settings.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, Settings.class);
        }
        return dao;
    }

    @Bean
    Dao<YearlyHistory, UUID> yearlyHistoryDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<YearlyHistory, UUID> dao = DaoManager.createDao(connectionSource, YearlyHistory.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, YearlyHistory.class);
        }
        return dao;
    }

    @Bean
    Dao<MonthlyHistory, UUID> monthlyHistoryDao(ConnectionSource connectionSource) throws SQLException {
        final Dao<MonthlyHistory, UUID> dao = DaoManager.createDao(connectionSource, MonthlyHistory.class);
        if (!dao.isTableExists()) {
            TableUtils.createTableIfNotExists(connectionSource, MonthlyHistory.class);
        }
        return dao;
    }

    @Bean
    public DefaultDSLContext dslContext(String jdbcUrl) {
        DefaultDSLContext using = (DefaultDSLContext) DSL.using(jdbcUrl, dbUsername, dbPassword);
        using.settings().setRenderSchema(false);
        return using;
    }


    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
        final ConnectionSource connectionSource = applicationReadyEvent.getApplicationContext().getBean(ConnectionSource.class);
        Dao<SchemaVersion, Long> schemaDao = (Dao<SchemaVersion, Long>) applicationReadyEvent.getApplicationContext().getBean("schemaDao");
        Dao<Category, Long> categoryDao = (Dao<Category, Long>) applicationReadyEvent.getApplicationContext().getBean("categoryDao");
        Dao<Expense, Long> expenseDao = (Dao<Expense, Long>) applicationReadyEvent.getApplicationContext().getBean("expenseDao");
        Dao<User, Long> userDao = (Dao<User, Long>) applicationReadyEvent.getApplicationContext().getBean("userDao");

        final String jdbcUrl = (String) applicationReadyEvent.getApplicationContext().getBean("jdbcUrl");
        final HistoryService historyService = (HistoryService) applicationReadyEvent.getApplicationContext().getBean("historyService");
        final ExpenseDao expenseDaoJooq = (ExpenseDao) applicationReadyEvent.getApplicationContext().getBean("expenseDaoJooq");

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


            if (schemaVersion < 9) {
                newVersion = 9;
                // since we now support more than one DB types, future migration should happen using jooq
                try (final CloseableDSLContext jooq = DSL.using(jdbcUrl, dbUsername, dbPassword)) {
                    jooq.alterTable("EXPENSE").addColumn("TIMESTAMP", SQLDataType.BIGINT.default_(0L).nullable(false)).execute();
                } catch (Exception e) {
                    // issues with original migration
                    if (!e.getMessage().contains("Duplicate column name")) {
                        e.printStackTrace();
                        throw e;
                    }
                }

                // migrating existing expenses by adding a timestamp
                expenseDao.queryForAll().forEach(e -> {
                    try {
                        final Date date = e.getDate();

                        if (e.getTime() != null && e.getTime().length() > 0) {
                            final List<Integer> time = Stream.of(e.getTime().split(":"))
                                    .map(Integer::parseInt)
                                    .collect(Collectors.toList());

                            date.setHours(time.get(0));
                            date.setMinutes(time.get(1));
                        }

                        e.setTimestamp(date.getTime());
                        expenseDao.update(e);
                    } catch (Exception err) {
                        err.printStackTrace();
                        throw new RuntimeException(err);
                    }
                });

            }

            if (schemaVersion < 10) {
                newVersion = 10;
                try (final CloseableDSLContext jooq = DSL.using(jdbcUrl, dbUsername, dbPassword)) {
                    final AlterTableAddStep alterTableAddStep = jooq.alterTable("USER").addColumn("TIMECREATED", SQLDataType.BIGINT.nullable(false).default_(0L));
                    System.out.println(alterTableAddStep.getSQL());
                    alterTableAddStep.execute();
                } catch (Exception e) {
                    e.printStackTrace();
                    throw e;
                }
            }

            if (schemaVersion < 11) {
                newVersion = 11;
                int pageSize = 1000;
                int page = 0;
                int totalProcessed = 0;

                PaginatedResults<Expense> expenses;
                for (User user : userDao.queryForAll()) {

                    do {
                        logger.info("user:" + user.getId() + " page " + page);
                        expenses = expenseDaoJooq.getPaginatedWhere(user, page, pageSize);
                        for (Expense e : expenses.getData()) {
                            historyService.cacheForExpense(user, e);
                        }
                        page++;
                        totalProcessed += expenses.getData().size();
                        logger.info("Proccessed " + totalProcessed + "/" + expenses.getPagination().getTotal());
                    } while (expenses.getData().size() == pageSize);
                }
            }

            // redoing migration of history records, as bug was introduce for instances with multiple users
            // as there was a bug where page  was not reset to 0 for each user...
            if (schemaVersion < 12) {
                newVersion = 12;
                int pageSize = 1000;
                PaginatedResults<Expense> expenses;
                for (User user : userDao.queryForAll()) {
                    int page = 0;
                    int totalProcessed = 0;
                    do {
                        logger.info("user:" + user.getId() + " page " + page);
                        expenses = expenseDaoJooq.getPaginatedWhere(user, page, pageSize);
                        for (Expense e : expenses.getData()) {
                            historyService.cacheForExpense(user, e);
                        }
                        page++;
                        totalProcessed += expenses.getData().size();
                        logger.info("Proccessed " + totalProcessed + "/" + expenses.getPagination().getTotal());
                    } while (expenses.getData().size() == pageSize);
                }
            }

/*
            if (schemaVersion < 12) {
                newVersion = 11;
                int pageSize = 20;
                int page = 0;

                try (final CloseableDSLContext jooq = DSL.using(jdbcUrl, dbUsername, dbPassword)) {
                    // migrating expenses
                    jooq.alterTable("EXPENSE").dropPrimaryKey().execute();
                    jooq.alterTable("EXPENSE").
                    jooq.alterTable("EXPENSE").renameColumn("ID").to("ID_OLD").execute();
                    jooq.alterTable("EXPENSE").addColumn("ID", SQLDataType.VARCHAR(48)).before("ID_OLD").execute();
                    try {
                        jooq.alterTable("EXPENSE").dropForeignKey(DSL.foreignKey(DSL.field("CATEGORY_ID")).references(DSL.table("CATEGORY"))).execute();
                    } catch (Exception e) {
                        logger.error("Probably ok, no foreign key", e);
                    }

                    List<Long> fetch;

                    do {
                        fetch = (List<Long>) jooq.select().from("EXPENSE")
                                .limit(pageSize)
                                .offset(page * pageSize).fetch("ID_OLD");

                        fetch.forEach(id -> {
                            logger.info("Updating id of expense " + id);
                            jooq.update(DSL.table("EXPENSE"))
                                    .set(DSL.field("ID"), UUID.randomUUID().toString())
                                    .where(DSL.field("ID_OLD").eq(id))
                                    .execute();
                        });
                        page++;
                    } while (fetch.size() == pageSize);

                    jooq.alterTable("RECURRING_EXPENSE").dropPrimaryKey().execute();
                    jooq.alterTable("RECURRING_EXPENSE").renameColumn("ID").to("ID_OLD").execute();
                    jooq.alterTable("RECURRING_EXPENSE").addColumn("ID", SQLDataType.VARCHAR(48)).before("ID_OLD").execute();
                    try {
                        jooq.alterTable("RECURRING_EXPENSE").dropForeignKey(DSL.constraint().foreignKey(DSL.field("CATEGORY_ID")).references(DSL.table("CATEGORY"))).execute();
                    } catch (Exception e) {
                        logger.error("Probably ok, no foreign key", e);
                    }
                    page = 0;
                    do {
                        fetch = (List<Long>) jooq.select().from("RECURRING_EXPENSE")
                                .limit(pageSize)
                                .offset(page * pageSize).fetch("ID_OLD");

                        fetch.forEach(id -> {
                            logger.info("Updating id of recurring expense " + id);
                            jooq.update(DSL.table("RECURRING_EXPENSE"))
                                    .set(DSL.field("ID"), UUID.randomUUID().toString())
                                    .where(DSL.field("ID_OLD").eq(id))
                                    .execute();
                        });
                        page++;
                    } while (fetch.size() == pageSize);

                    jooq.alterTable("CATEGORY").dropPrimaryKey().execute();
                    jooq.alterTable("CATEGORY").renameColumn("ID").to("ID_OLD").execute();
                    jooq.alterTable("CATEGORY").addColumn("ID", SQLDataType.VARCHAR(48)).before("ID_OLD").execute();

                    page = 0;
                    do {
                        fetch = (List<Long>) jooq.select().from("CATEGORY")
                                .limit(pageSize)
                                .offset(page * pageSize).fetch("ID_OLD");

                        fetch.forEach(id -> {
                            logger.info("Updating id of category " + id);
                            String uuid = UUID.randomUUID().toString();
                            jooq.update(DSL.table("CATEGORY"))
                                    .set(DSL.field("ID"), uuid)
                                    .where(DSL.field("ID_OLD").eq(id))
                                    .execute();


                            logger.info("Updating expenses");
                            int updated = jooq.update(DSL.table("EXPENSE"))
                                    .set(DSL.field("CATEGORY_ID"), uuid)
                                    .where(DSL.field("CATEGORY_ID").eq(id))
                                    .execute();
                            logger.info("Updated " + updated + " expenses");

                            logger.info("Updating recurring expenses");
                            updated = jooq.update(DSL.table("RECURRING_EXPENSE"))
                                    .set(DSL.field("CATEGORY_ID"), uuid)
                                    .where(DSL.field("CATEGORY_ID").eq(id))
                                    .execute();
                            logger.info("Updated " + updated + " recurring expenses");


                        });
                        page++;
                    } while (fetch.size() == pageSize);
                }
            }
*/

            TableUtils.clearTable(connectionSource, SchemaVersion.class);
            schemaDao.create(new SchemaVersion(newVersion));
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Couldn't migrate schema");
        }
    }
}
