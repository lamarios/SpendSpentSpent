package com.ftpix.sss.automation.framework.mainpage.gridview;

import com.ftpix.sss.automation.framework.common.AmountInputKeyBoard;
import com.ftpix.sss.automation.tests.SetUpAutomation;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class AddExpenseDialog extends AmountInputKeyBoard{
    private static final By OK_BUTTON = By.cssSelector(".actions .ok");

    private static final By HEADER_ICON = By.cssSelector(".header i");
    private static final By DATE_BUTTON = By.cssSelector(".options button");
    private static final By DATE_PICKER = By.cssSelector(".react-datepicker");

    public AddExpenseDialog(WebElement element) {
        super(element);
    }


    /**
     * Returns the icon where the category should be
     *
     * @return
     */
    public WebElement getHeaderIcon() {
        return findElement(HEADER_ICON);
    }



    public WebElement getOkButton() {
        return SetUpAutomation.DRIVER.findElement(OK_BUTTON);
    }


    public WebElement getDateButton(){
        return findElement(DATE_BUTTON);
    }

    public ExpenseDatePicker getDatePicker(){
        return new ExpenseDatePicker(findElement(DATE_PICKER));
    }
}
