package com.ftpix.sss.automation.framework.mainpage.recurring;

import com.ftpix.sss.automation.framework.common.AmountInputKeyBoard;
import com.ftpix.sss.automation.tests.SetUpAutomation;
import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.stream.Collectors;

public class AddRecurringExpenseDialog extends ElementImpl {

    private static final By CATEGORIES = By.cssSelector(".categories ul li");
    private static final By NEXT_OK_BUTTON = By.cssSelector(".actions .ok");
    private static final By SELECT_TYPE = By.cssSelector(".select-type");
    private static final By AMOUNT_INPUT = By.cssSelector(".amount");

    public AddRecurringExpenseDialog(WebElement element) {
        super(element);
    }

    public List<WebElement> getAvailableCategories() {
        return findElements(CATEGORIES)
                .stream()
                .flatMap(e -> e.findElements(By.cssSelector("i")).stream())
                .collect(Collectors.toList());
    }


    public WebElement getNextButton() {
        return SetUpAutomation.DRIVER.findElement(NEXT_OK_BUTTON);
    }

    public SelectType getSelectType() {
        return new SelectType(findElement(SELECT_TYPE));
    }

    public AmountInputKeyBoard getAmountInputKeyBoard(){
        return new AmountInputKeyBoard(findElement(AMOUNT_INPUT));
    }
}
