package com.ftpix.sss.automation.framework.rightcolumn;

import com.ftpix.sss.automation.framework.common.BottomBar;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class RightColumnPage {


    @FindBy(css = ".BottomBar")
    private WebElement bottomBar;

    @FindBy(css = ".RightColumn")
    private WebElement rightColumn;

    public BottomBar getBottomBar() {
        return new BottomBar(bottomBar);
    }


    public RightColumn getRightColumn() {
        return new RightColumn(rightColumn);
    }
}
