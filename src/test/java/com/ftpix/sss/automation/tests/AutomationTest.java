package com.ftpix.sss.automation.tests;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import static com.ftpix.sss.automation.tests.SetUpAutomation.setUpApp;
import static com.ftpix.sss.automation.tests.SetUpAutomation.stopTests;
import static junit.framework.TestCase.assertNotNull;
import static junit.framework.TestCase.assertTrue;

@Ignore
public class AutomationTest {


    @BeforeClass
    public static void setup() throws IOException {

        setUpApp();
    }

    @AfterClass
    public static void destroy() {
        try {
            stopTests();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Test
    public void runTestsInOrder() throws IOException, InterruptedException {
        System.out.println("RUNNING AUTOMATION !");
        MainPageTests mainPageTests = new MainPageTests();

        mainPageTests.t1AddCategories();
        mainPageTests.t2TestExpenseDialog();
        mainPageTests.t3RecurringExpensesTest();


        RightColumnTests rightColumnTests = new RightColumnTests();
        rightColumnTests.t1DropDownTest();
        rightColumnTests.t2ExpensesTest();

    }
}
