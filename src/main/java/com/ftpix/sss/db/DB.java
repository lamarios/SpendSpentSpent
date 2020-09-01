package com.ftpix.sss.db;

import com.ftpix.sss.Constants;
import com.ftpix.sss.models.*;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.h2.table.Table;

import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

public class DB {

    public static Dao<Category, Long> CATEGORY_DAO = null;
    public static Dao<Expense, Long> EXPENSE_DAO = null;
    public static Dao<RecurringExpense, Long> RECURRING_EXPENSE_DAO = null;
    public static Dao<Setting, String> SETTING_DAO = null;
    public static Dao<UserSession, String> USER_SESSION_DAO = null;
    public static Dao<SchemaVersion, Integer> SCHEMA_DAO = null;

    private final static String databaseUrl = "jdbc:h2:" + Constants.DB_PATH;

    private static Logger logger = LogManager.getLogger();


    static {
        try {
            logger.info("Initiating DB and DAO to DB:[{}]", databaseUrl);

            // this uses h2 by default but change to match your database
            // create a connection source to our database
            ConnectionSource connectionSource = new JdbcConnectionSource(databaseUrl, "", "");

            logger.info("Creating CategoryDAO and tables if it doesn't exist");
            CATEGORY_DAO = DaoManager.createDao(connectionSource, Category.class);
            TableUtils.createTableIfNotExists(connectionSource, Category.class);

            logger.info("Creating Module DAO and tables if it doesn't exist");
            EXPENSE_DAO = DaoManager.createDao(connectionSource, Expense.class);
            TableUtils.createTableIfNotExists(connectionSource, Expense.class);

            logger.info("Creating Module DAO and tables if it doesn't exist");
            RECURRING_EXPENSE_DAO = DaoManager.createDao(connectionSource, RecurringExpense.class);
            TableUtils.createTableIfNotExists(connectionSource, RecurringExpense.class);

            logger.info("Creating Module DAO and tables if it doesn't exist");
            SETTING_DAO = DaoManager.createDao(connectionSource, Setting.class);
            TableUtils.createTableIfNotExists(connectionSource, Setting.class);

            logger.info("Creating Module DAO and tables if it doesn't exist");
            USER_SESSION_DAO = DaoManager.createDao(connectionSource, UserSession.class);
            TableUtils.createTableIfNotExists(connectionSource, UserSession.class);

            logger.info("Creating Module DAO and tables if it doesn't exist");
            SCHEMA_DAO = DaoManager.createDao(connectionSource, SchemaVersion.class);
            TableUtils.createTableIfNotExists(connectionSource, SchemaVersion.class);

            Integer current = SCHEMA_DAO.queryBuilder()
                    .orderBy("CURRENT", false)
                    .query()
                    .stream()
                    .findFirst()
                    .map(SchemaVersion::getCurrent)
                    .orElse(0);


            //setting last version in schema table
            updateSchema(current);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            logger.info("Error while setting up ORM", e);
            System.exit(0);
        }
    }


    /**
     * Perform sql migration
     *
     * @param schemaVersion
     */
    private static void updateSchema(Integer schemaVersion) throws SQLException {
        ConnectionSource connectionSource = new JdbcConnectionSource(databaseUrl, "", "");
        int newVersion = schemaVersion;


        if (schemaVersion < 4) {
            SCHEMA_DAO.executeRaw("ALTER TABLE expense ADD COLUMN IF NOT EXISTS NOTE TEXT");
            newVersion = 4;
        }


        if(schemaVersion < 5){
            SCHEMA_DAO.executeRaw("ALTER TABLE expense ADD COLUMN IF NOT EXISTS TIME VARCHAR(5)");
            newVersion = 5;
        }

        if(schemaVersion < 6){
            newVersion = 6;
            List<Category> categories = DB.CATEGORY_DAO.queryForAll();

            for(int i = 0; i < categories.size() ; i++){
                Category cat = categories.get(i);
                cat.setCategoryOrder(i);
                CATEGORY_DAO.update(cat);
            }
        }

        TableUtils.clearTable(connectionSource, SchemaVersion.class);
        SCHEMA_DAO.create(new SchemaVersion(newVersion));

    }
}
