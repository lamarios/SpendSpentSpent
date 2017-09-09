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

import java.sql.SQLException;

public class DB {

    public static Dao<Category, Integer> CATEGORY_DAO = null;
    public static Dao<Expense, Integer> EXPENSE_DAO = null;
    public static Dao<RecurringExpense, Integer> RECURRING_EXPENSE_DAO = null;
    public static Dao<Setting, String> SETTING_DAO = null;
    public static Dao<UserSession, String> USER_SESSION_DAO = null;

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
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            logger.info("Error while setting up ORM", e);
            System.exit(0);
        }
    }
}
