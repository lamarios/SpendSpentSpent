package com.ftpix.sss.automation.framework.common;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class OkCancelDialog extends ElementImpl {

    private static final By OK_BUTTON = By.cssSelector(".actions .ok");
    private static final By CANCEL_BUTTON = By.cssSelector(".actions a:nth-of-type(1)");

    public OkCancelDialog(WebElement element) {
        super(element);
    }

    public WebElement getOkButton(){
        return findElement(OK_BUTTON);
    }

    public WebElement getCancelButton(){
        return findElement(CANCEL_BUTTON);
    }

}
