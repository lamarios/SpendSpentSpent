package com.ftpix.sss.automation.tests;

import com.ftpix.sss.Constants;
import com.ftpix.sss.SpendSpentSpent;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.*;
import com.j256.ormlite.table.TableUtils;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.phantomjs.PhantomJSDriver;
import org.openqa.selenium.phantomjs.PhantomJSDriverService;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

public class SetUpAutomation {
    public static final String BASE_URL = "http://localhost:" + Constants.HTTP_PORT;
    public static WebDriver DRIVER;
    public static WebDriverWait WAIT;

    private static int count = 0;

    public static synchronized void setUpApp() throws IOException {
        if (count == 0) {

            WebDriverManager.firefoxdriver().setup();

            DRIVER = new FirefoxDriver();
            WAIT = new WebDriverWait(DRIVER, 3, 250);

            new SpendSpentSpent();
        }
        count++;
    }


    public static synchronized void stopTests() throws SQLException {

        count--;
        if (count == 0) {
            DRIVER.close();

            TableUtils.clearTable(DB.CATEGORY_DAO.getConnectionSource(), Category.class);
            TableUtils.clearTable(DB.CATEGORY_DAO.getConnectionSource(), Expense.class);
            TableUtils.clearTable(DB.CATEGORY_DAO.getConnectionSource(), RecurringExpense.class);
            TableUtils.clearTable(DB.CATEGORY_DAO.getConnectionSource(), Setting.class);
            TableUtils.clearTable(DB.CATEGORY_DAO.getConnectionSource(), UserSession.class);

        }
    }
}
