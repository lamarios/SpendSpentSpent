package com.ftpix.sss.automation.tests;

import com.ftpix.sss.Constants;
import com.ftpix.sss.SpendSpentSpent;
import com.ftpix.sss.automation.framework.mainpage.AddCategoryDialog;
import com.ftpix.sss.automation.framework.mainpage.MainPage;
import org.junit.*;
import org.junit.runners.MethodSorters;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.IOException;
import java.util.List;
import java.util.Set;

import static com.ftpix.sss.automation.tests.SetUpAutomation.*;
import static org.junit.Assert.*;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class MainPageTests {


    @BeforeClass
    public static void setup() throws IOException {
        setUpApp();
    }

    @AfterClass
    public static void destroy(){
        stopTests();
    }

    @Test
    public void t1AddCategories() throws IOException, InterruptedException {

        DRIVER.get(BASE_URL);

        MainPage mainPage = PageFactory.initElements(DRIVER, MainPage.class);

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategory()));
        mainPage.getAddCategory().click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategoryDialog()));
        AddCategoryDialog dialog = mainPage.getAddCategoryDialog();
//            assertTrue("The dialog should be showing", dialog.isDisplayed());


        dialog.getSearchInput().sendKeys("sou");

        WAIT.until(webDriver -> dialog.getSearchResults().size() == 7);
        List<WebElement> searchResults = dialog.getSearchResults();

        assertEquals("We  should have 7 results", 7, searchResults.size());
        searchResults.get(0).click();

        dialog.getAddCategoryButton().click();


        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategory()));
        mainPage.getAddCategory().click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategoryDialog()));
//            assertTrue("The dialog should be showing", dialog.isDisplayed());


        dialog.getSearchInput().sendKeys("sou");

        WAIT.until(webDriver -> dialog.getSearchResults().size() == 6);
        searchResults = dialog.getSearchResults();

        assertEquals("We  should have 6 results", 6, searchResults.size());
        searchResults.get(0).click();

        dialog.getAddCategoryButton().click();

    }
}
