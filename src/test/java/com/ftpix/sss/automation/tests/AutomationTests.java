package com.ftpix.sss.automation.tests;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;

import static com.ftpix.sss.automation.tests.SetUpAutomation.setUpApp;
import static com.ftpix.sss.automation.tests.SetUpAutomation.stopTests;

public class AutomationTests {


    @BeforeClass
    public static void setup() throws IOException {
        setUpApp();
    }

    @AfterClass
    public static void destroy() {
        stopTests();
    }


    @Test
    public void runTestsInOrder() throws IOException, InterruptedException {
        MainPageTests mainPageTests = new MainPageTests();

        mainPageTests.t1AddCategories();
        mainPageTests.t2TestExpenseDialog();
        mainPageTests.t3RecurringExpensesTest();


        RightColumnTests rightColumnTests = new RightColumnTests();
        rightColumnTests.t1DropDownTest();
        rightColumnTests.t2ExpensesTest();

        Thread.sleep(3000);
    }
}
