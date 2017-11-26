package com.ftpix.sss.automation.framework.common;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class BottomBar extends ElementImpl {

    public BottomBar(WebElement element) {
        super(element);
    }

    public WebElement getRightcolumnLink() {
        return findElement(By.cssSelector(".main-links a:nth-of-type(3)"));
    }

    public WebElement getLeftcolumnLink() {
        return findElement(By.cssSelector(".main-links a:nth-of-type(1)"));
    }

    public WebElement getCentercolumnLink() {
        return findElement(By.cssSelector(".main-links a:nth-of-type(2)"));
    }
}
