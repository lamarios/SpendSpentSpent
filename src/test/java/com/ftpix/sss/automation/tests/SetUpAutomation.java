package com.ftpix.sss.automation.tests;

import com.ftpix.sss.Constants;
import com.ftpix.sss.SpendSpentSpent;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicInteger;

public class SetUpAutomation {
    public static final String BASE_URL = "http://localhost:" + Constants.HTTP_PORT;
    public static WebDriver DRIVER = new ChromeDriver();
    public static WebDriverWait WAIT = new WebDriverWait(DRIVER, 3, 250);

    private static int count = 0;

    public static synchronized void setUpApp() throws IOException {
        if (count == 0) {
            new SpendSpentSpent();
        }
        count++;
    }


    public static synchronized void stopTests() {
        count--;
        if (count == 0) {
            DRIVER.close();
        }
    }
}
