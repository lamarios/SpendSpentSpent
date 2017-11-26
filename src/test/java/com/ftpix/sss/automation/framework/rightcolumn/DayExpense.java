package com.ftpix.sss.automation.framework.rightcolumn;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.stream.Collectors;

public class DayExpense extends ElementImpl {

    private static final By EXPENSES = By.cssSelector(".Expense");
    private static final By DATE = By.cssSelector(".date");
    private static final By TOTAL = By.cssSelector(".total .amount span");

    public DayExpense(WebElement element) {
        super(element);
    }

    public WebElement getDate() {
        return findElement(DATE);
    }

   public WebElement getTotal() {
        return findElement(TOTAL);
    }

    public List<Expense> getExpenses() {
        return findElements(EXPENSES)
                .stream()
                .map(Expense::new)
                .collect(Collectors.toList());
    }
}
