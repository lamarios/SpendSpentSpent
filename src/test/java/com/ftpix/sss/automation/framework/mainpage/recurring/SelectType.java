package com.ftpix.sss.automation.framework.mainpage.recurring;

import com.ftpix.sss.automation.framework.common.ButtonGroup;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class SelectType extends ElementImpl{

    private static final By FIRST_ROW = By.cssSelector(".ButtonGroup:nth-of-type(1)");
    private static final By SECOND_ROW = By.cssSelector(".ButtonGroup:nth-of-type(2)");

    public SelectType(WebElement element) {
        super(element);
    }

    public ButtonGroup getFirstRow(){
        return new ButtonGroup(findElement(FIRST_ROW));
    }

    public ButtonGroup getSecondRow(){
        return  new ButtonGroup(findElement(SECOND_ROW));
    }
}
