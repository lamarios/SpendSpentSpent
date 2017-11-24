package com.ftpix.sss.automation.framework.mainpage;

import com.ftpix.sss.automation.framework.interfaces.SssPage;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.List;

public class AddCategoryDialog extends ElementImpl {
    private final static String SELECTOR = ".AddCategoryDialog ";
    public static final By ADD_CATEGORY_BUTTTON = By.cssSelector(".actions .ok");
    public static final By SEARCH_INPUT = By.cssSelector(SELECTOR + ".search input");
    public static final By SEARCH_RESULTS = By.cssSelector(SELECTOR + ".SubCategory .category-icons i");

    public AddCategoryDialog(WebElement element, SssPage parent) {
        super(element, parent);
    }


    public WebElement getSearchInput() {
        return getParentElement().findElement(SEARCH_INPUT);
    }

    public List<WebElement> getSearchResults() {
        return getParentElement().findElements(SEARCH_RESULTS);
    }

    public WebElement getAddCategoryButton() {
        return getParentElement().findElement(ADD_CATEGORY_BUTTTON);
    }

}
