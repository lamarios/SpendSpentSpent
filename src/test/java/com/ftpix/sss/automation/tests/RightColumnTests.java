package com.ftpix.sss.automation.tests;

import com.ftpix.sss.automation.framework.common.OkCancelDialog;
import com.ftpix.sss.automation.framework.mainpage.recurring.BackFace;
import com.ftpix.sss.automation.framework.rightcolumn.*;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;

import static com.ftpix.sss.automation.tests.SetUpAutomation.DRIVER;
import static com.ftpix.sss.automation.tests.SetUpAutomation.WAIT;
import static org.junit.Assert.assertEquals;

public class RightColumnTests {


    private static final String CLASS = "class";
    private final RightColumnPage page = PageFactory.initElements(DRIVER, RightColumnPage.class);

    public void t1DropDownTest() {
        page.getBottomBar().getRightcolumnLink().click();

        WAIT.until(ExpectedConditions.visibilityOf(page.getRightColumn()));
        RightColumn rightColumn = page.getRightColumn();

        WAIT.until(ExpectedConditions.visibilityOf(rightColumn.getDropDown()));
        DropDown dropDown = rightColumn.getDropDown();

        WAIT.until(driver -> dropDown.getOptions().size() > 0);
        List<WebElement> options = dropDown.getOptions();

        assertEquals("We should have 2 months in the dropdown according to main page tests", 2, options.size());

        //we should have current month and the previous month
        LocalDate now = LocalDate.now();
        LocalDate oneMonthBack = now.minusMonths(1);
        String currentMonth = now.getMonth().getDisplayName(TextStyle.FULL, Locale.getDefault());
        String previousMonth = oneMonthBack.getMonth().getDisplayName(TextStyle.FULL, Locale.getDefault());

        assertEquals("Testing dropdown value for first entry", previousMonth + " " + oneMonthBack.getYear(), options.get(0).getText());
        assertEquals("Testing dropdown value for second entry", currentMonth + " " + now.getYear(), options.get(1).getText());


    }

    /**
     * Testing if the expenses tally
     */
    public void t2ExpensesTest() throws InterruptedException {
        NumberFormat numberFormat = NumberFormat.getNumberInstance();
        numberFormat.setMinimumFractionDigits(2);

        WAIT.until(ExpectedConditions.visibilityOf(page.getRightColumn()));
        RightColumn rightColumn = page.getRightColumn();

        WAIT.until(driver -> rightColumn.getDayExpenses().size() > 0);
        List<DayExpense> dayExpenses = rightColumn.getDayExpenses();
        assertEquals("We should only have on expense according to MainPageTests", 1, dayExpenses.size());

        assertEquals("The total should be equals to the only expense", numberFormat.format(Double.valueOf(MainPageTests.CURRENT_MONTH_EXPENSE_VALUE)), rightColumn.getTotal().getText());


        DayExpense dayExpense = dayExpenses.get(0);
        assertEquals("The total should be equals to the only expense", numberFormat.format(Double.valueOf(MainPageTests.CURRENT_MONTH_EXPENSE_VALUE)), dayExpense.getTotal().getText());

        //now checking the expense itself rather than the total.
        assertEquals("We should have one expense", 1, dayExpense.getExpenses().size());

        Expense expense = dayExpense.getExpenses().get(0);
        assertEquals("The total should be equals to the only expense", numberFormat.format(Double.valueOf(MainPageTests.CURRENT_MONTH_EXPENSE_VALUE)), expense.getAmount().getText());
        MainPageTests.FIRST_CATEGORY.ifPresent(category -> {
            assertEquals("The icon should be the same as the first expense of MainPageTests", category, expense.getIcon().getAttribute(CLASS));
        });




        //now going back the previous month expense and checking everything again

        rightColumn.getDropDown().getOptions().get(0).click();


        WAIT.until(driver -> rightColumn.getDayExpenses().size() > 0);
        dayExpenses = rightColumn.getDayExpenses();
        assertEquals("We should only have on expense according to MainPageTests", 1, dayExpenses.size());

        assertEquals("The total should be equals to the only expense", numberFormat.format(Double.valueOf(MainPageTests.PREVIOUS_MONTH_EXPENSE_VALUE)), rightColumn.getTotal().getText());


        dayExpense = dayExpenses.get(0);
        assertEquals("The total should be equals to the only expense", numberFormat.format(Double.valueOf(MainPageTests.PREVIOUS_MONTH_EXPENSE_VALUE)), dayExpense.getTotal().getText());

        //now checking the expense itself rather than the total.
        assertEquals("We should have one expense", 1, dayExpense.getExpenses().size());

        Expense expense2 = dayExpense.getExpenses().get(0);
        assertEquals("The total should be equals to the only expense", numberFormat.format(Double.valueOf(MainPageTests.PREVIOUS_MONTH_EXPENSE_VALUE)), expense2.getAmount().getText());
        MainPageTests.SECOND_CATEGORY.ifPresent(category -> {
            assertEquals("The icon should be the same as the first expense of MainPageTests", category, expense2.getIcon().getAttribute(CLASS));
        });


        expense2.click();
        WAIT.until(ExpectedConditions.visibilityOf(expense2.getBack()));
        ExpenseBack back = expense2.getBack();
        WAIT.until(ExpectedConditions.elementToBeClickable(back.getClose()));
        back.getClose().click();

        expense2.click();
        Thread.sleep(1000);
        WAIT.until(ExpectedConditions.visibilityOf(expense2.getBack()));
        Thread.sleep(1000);
        back = expense2.getBack();
        WAIT.until(ExpectedConditions.visibilityOf(back.getDelete()));
        back.getDelete().click();

        WAIT.until(ExpectedConditions.visibilityOf(back.getDeleteDialog()));
        OkCancelDialog deleteDialog = back.getDeleteDialog();
        WAIT.until(ExpectedConditions.elementToBeClickable(deleteDialog.getCancelButton()));
        //Not sure why but this will fail randomly without the 1s sleep
        Thread.sleep(1000);
        deleteDialog.getCancelButton().click();
        WAIT.until(ExpectedConditions.stalenessOf(deleteDialog));

        back.getDelete().click();
//        WAIT.until(ExpectedConditions.visibilityOf(back.getDeleteDialog()));
        WAIT.until(ExpectedConditions.elementToBeClickable(back.getDeleteDialog().getOkButton()));
        //Not sure why but this will fail randomly without the 1s sleep
        Thread.sleep(1000);
        back.getDeleteDialog().getOkButton().click();
        WAIT.until(driver -> rightColumn.getDayExpenses().size() == 0);
        assertEquals("We shouldn't have any expense left as we just deleted the only one", 0,rightColumn.getDayExpenses().size());




    }


}
