package com.ftpix.sss.automation.framework.mainpage.gridview;

import com.ftpix.sss.automation.framework.interfaces.SssPage;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class CategoryGridIcon extends ElementImpl {

    public static final By ICON = By.cssSelector("i.cat");

    public CategoryGridIcon(WebElement element) {
        super(element);
    }


    /**
     * Gets the <i> tag from the icon
     * @return
     */
    public WebElement getIcon(){
        return findElement(ICON);
    }
}
