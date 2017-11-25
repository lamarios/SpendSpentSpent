package com.ftpix.sss.automation.framework.mainpage.gridview;

import com.ftpix.sss.automation.framework.interfaces.SssPage;
import com.ftpix.sss.automation.tests.SetUpAutomation;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.internal.WrapsDriver;
import org.openqa.selenium.support.FindBy;

import java.util.List;

public class AddCategoryDialog extends ElementImpl {
    private final static String SELECTOR = ".AddCategoryDialog ";
    public static final By ADD_CATEGORY_BUTTTON = By.cssSelector(".actions .ok");
    public static final By SEARCH_INPUT = By.cssSelector(SELECTOR + ".search input");
    public static final By SEARCH_RESULTS = By.cssSelector(SELECTOR + ".SubCategory .category-icons i");

    public AddCategoryDialog(WebElement element) {
        super(element);
    }


    public WebElement getSearchInput() {
        return findElement(SEARCH_INPUT);
    }

    public List<WebElement> getSearchResults() {
        return findElements(SEARCH_RESULTS);
    }

    /**
     * Gets the button to add a category once it's selected
     * @return
     */
    public WebElement getAddCategoryButton() {
        //TODO: find better way than that to go back to parent
        return SetUpAutomation.DRIVER.findElement(ADD_CATEGORY_BUTTTON);
//        return findElement(ADD_CATEGORY_BUTTTON);
    }

}
