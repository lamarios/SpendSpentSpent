package com.ftpix.sss.automation.framework.mainpage.recurring;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.stream.Collectors;

public class RecurringExpenseList extends ElementImpl {

    private static final By RECURRING_EXPENSES = By.cssSelector(".RecurringExpense");
    private static final By ADD_RECURRING_EXPENSE = By.cssSelector(".add i");
    private static final By ADD_RECURRING_EXPENSE_DIALOG = By.cssSelector(".AddRecurringExpenseDialog");

    public RecurringExpenseList(WebElement element) {
        super(element);
    }

    public List<RecurringExpense> getRecurringExpenses() {
        return findElements(RECURRING_EXPENSES)
                .stream()
                .map(RecurringExpense::new)
                .collect(Collectors.toList());
    }

    public WebElement getAddButton() {
        return findElement(ADD_RECURRING_EXPENSE);
    }

    public AddRecurringExpenseDialog getAddRecurringExpenseDialog() {
        return new AddRecurringExpenseDialog(findElement(ADD_RECURRING_EXPENSE_DIALOG));
    }
}
