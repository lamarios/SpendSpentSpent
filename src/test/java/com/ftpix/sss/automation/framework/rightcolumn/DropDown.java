package com.ftpix.sss.automation.framework.rightcolumn;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;

public class DropDown extends ElementImpl {

    private static final By OPTIONS = By.cssSelector("option");

    public DropDown(WebElement element) {
        super(element);
    }


    public List<WebElement> getOptions() {
        return findElements(OPTIONS);
    }
}
