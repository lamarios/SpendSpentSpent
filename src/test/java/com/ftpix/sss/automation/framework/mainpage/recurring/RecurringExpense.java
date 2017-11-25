package com.ftpix.sss.automation.framework.mainpage.recurring;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class RecurringExpense extends ElementImpl {

    private static final By FREQUENCE = By.cssSelector(".frequence");
    private static final By ICON = By.cssSelector(".icon i");
    private static final By AMOUNT = By.cssSelector(".amount span");
    private static final By BACK_FACE = By.cssSelector(".back");

    public RecurringExpense(WebElement element) {
        super(element);
    }


    public WebElement getFrequence() {
        return findElement(FREQUENCE);
    }

    public WebElement getIcon() {
        return findElement(ICON);
    }

    public WebElement getAmount() {
        return findElement(AMOUNT);
    }

    public BackFace getBackFace() {
        return new BackFace(findElement(BACK_FACE));
    }

}
