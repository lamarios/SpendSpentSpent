package com.ftpix.sss.automation.framework.rightcolumn;

import com.ftpix.sss.automation.framework.common.OkCancelDialog;
import com.ftpix.sss.automation.tests.SetUpAutomation;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class ExpenseBack extends ElementImpl {

    private static final By CLOSE = By.cssSelector(".actions a:nth-of-type(1)");
    private static final By DELETE = By.cssSelector(".actions .delete");
    private static final By DELETE_DIALOG = By.cssSelector(".Dialog");

    public ExpenseBack(WebElement element) {
        super(element);
    }

    public WebElement getClose(){
        return findElement(CLOSE);
    }

    public WebElement getDelete(){
        return findElement(DELETE);
    }

    public OkCancelDialog getDeleteDialog(){
        return new OkCancelDialog(SetUpAutomation.DRIVER.findElement(DELETE_DIALOG));
    }
}
