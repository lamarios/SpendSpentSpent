package com.ftpix.sss.automation.tests;

import com.ftpix.sss.Constants;
import com.ftpix.sss.SpendSpentSpent;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.phantomjs.PhantomJSDriver;
import org.openqa.selenium.phantomjs.PhantomJSDriverService;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.File;
import java.io.IOException;
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
            //if no chrome driver, we use phantomJS
            if (System.getProperty("webdriver.chrome.driver", "").equalsIgnoreCase("")) {

                String PHANTOMJS_BINARY = System.getProperty("phantomjs.binary");
                System.out.println("PHANTOM JS:"+PHANTOMJS_BINARY);

                assertNotNull(PHANTOMJS_BINARY);
                assertTrue(new File(PHANTOMJS_BINARY).exists());


                final DesiredCapabilities capabilities = new DesiredCapabilities();

                // Configure our WebDriver to support JavaScript and be able to find the PhantomJS binary
                capabilities.setJavascriptEnabled(true);
                capabilities.setCapability("takesScreenshot", false);
                capabilities.setCapability(
                        PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY,
                        PHANTOMJS_BINARY
                );

                DRIVER = new PhantomJSDriver(capabilities);
                WAIT = new WebDriverWait(DRIVER, 3, 250);
            }else{
                DRIVER = new ChromeDriver();
                WAIT = new WebDriverWait(DRIVER, 3, 250);
            }

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
