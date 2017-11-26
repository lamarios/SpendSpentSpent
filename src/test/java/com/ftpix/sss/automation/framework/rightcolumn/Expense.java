package com.ftpix.sss.automation.framework.rightcolumn;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class Expense extends ElementImpl {

    private static final By ICON = By.cssSelector(".front i.cat");
    private static final By AMOUNT = By.cssSelector(".front span");
    private static final By BACK = By.cssSelector(".back");

    public Expense(WebElement element) {
        super(element);
    }


    public WebElement getIcon(){
        return findElement(ICON);
    }

    public WebElement getAmount() {
        return findElement(AMOUNT);


    }
    public ExpenseBack getBack(){
        return new ExpenseBack(findElement(BACK));
    }
}
