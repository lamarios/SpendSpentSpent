package com.ftpix.sss.automation.framework.rightcolumn;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.stream.Collectors;

public class RightColumn extends ElementImpl {

    private static final By DROP_DOWN = By.cssSelector(".month-select select");
    private static final By TOTAL = By.cssSelector(".total .amount span");

    public RightColumn(WebElement element) {
        super(element);
    }

    public DropDown getDropDown() {
        return new DropDown(findElement(DROP_DOWN));
    }

    public List<DayExpense> getDayExpenses(){
        return findElements(By.cssSelector(".DayExpense"))
                .stream()
                .map(DayExpense::new)
                .collect(Collectors.toList());
    }

    public WebElement getTotal(){
        return findElement(TOTAL);
    }
}
