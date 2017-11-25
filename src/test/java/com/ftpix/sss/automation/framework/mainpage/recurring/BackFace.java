package com.ftpix.sss.automation.framework.mainpage.recurring;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;

public class BackFace extends ElementImpl {

    private static final By MENU_BUTTON = By.cssSelector(".fa.fa-ellipsis-v");
    private static final By LAST_OCCURRENCE = By.cssSelector("p:nth-of-type(1) .date");
    private static final By NEXT_OCCURRENCE = By.cssSelector("p:nth-of-type(2) .date");
    private static final By MENU = By.cssSelector(".bottom-menu");

    public BackFace(WebElement element) {
        super(element);
    }


    public WebElement getMenubutton() {
        return findElement(MENU_BUTTON);
    }

    public WebElement getLastOccurrence() {
        return findElement(LAST_OCCURRENCE);
    }

    public WebElement getNextOccurence() {
        try {
            return findElement(NEXT_OCCURRENCE);
        } catch (NoSuchElementException e) {
            //if gestLastOccurrence crashes, means next occurrence is actually the first item
            return getLastOccurrence();
        }
    }
    public RecurringExpenseMenu getMenu() {
        return new RecurringExpenseMenu(findElement(MENU));
    }
}
