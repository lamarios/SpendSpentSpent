package com.ftpix.sss.automation.framework.mainpage.recurring;

import com.ftpix.sss.automation.framework.common.OkCancelDialog;
import com.ftpix.sss.automation.tests.SetUpAutomation;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class RecurringExpenseMenu extends ElementImpl {

    private static final By CLOSE_BUTTON = By.cssSelector(".fa-times");
    private static final By DELETE_BUTTON = By.cssSelector(".delete");
    private static final By DELETE_DIALOG = By.cssSelector(".Dialog");

    public RecurringExpenseMenu(WebElement element) {
        super(element);
    }

    public WebElement getCloseButton() {
        return findElement(CLOSE_BUTTON);
    }


    public WebElement getDeleteButton() {
        return findElement(DELETE_BUTTON);
    }


    public OkCancelDialog getDeleteConfirmDialog() {
        return new OkCancelDialog(SetUpAutomation.DRIVER.findElement(DELETE_DIALOG));
    }
}
