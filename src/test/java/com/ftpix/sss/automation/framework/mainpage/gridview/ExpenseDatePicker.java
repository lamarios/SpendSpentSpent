package com.ftpix.sss.automation.framework.mainpage.gridview;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class ExpenseDatePicker extends ElementImpl{

    private static final By MIDDLE_OF_MONTH = By.cssSelector(".react-datepicker__week:nth-of-type(3) .react-datepicker__day--wed");
    private static final By NAVIGATE_PREVIOUS_MONTH = By.cssSelector(".react-datepicker__navigation--previous");

    public ExpenseDatePicker(WebElement element) {
        super(element);
    }


    public WebElement getNavigatePrevious(){
        return findElement(NAVIGATE_PREVIOUS_MONTH);
    }


    /**
     * Will get a day more or less in the middle of the month so we don't click on some of the overlapping months
     * @return
     */
    public WebElement getDayInCenter(){
        return findElement(MIDDLE_OF_MONTH);
    }
}
