package com.ftpix.sss.automation.tests;

import com.ftpix.sss.automation.framework.common.AmountInputKeyBoard;
import com.ftpix.sss.automation.framework.common.OkCancelDialog;
import com.ftpix.sss.automation.framework.mainpage.*;
import com.ftpix.sss.automation.framework.mainpage.gridview.AddCategoryDialog;
import com.ftpix.sss.automation.framework.mainpage.gridview.AddExpenseDialog;
import com.ftpix.sss.automation.framework.mainpage.gridview.CategoryGridIcon;
import com.ftpix.sss.automation.framework.mainpage.gridview.ExpenseDatePicker;
import com.ftpix.sss.automation.framework.mainpage.recurring.*;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import static com.ftpix.sss.automation.tests.SetUpAutomation.*;
import static org.junit.Assert.*;


public class MainPageTests {

    private static final String CLASS = "class";
    private final MainPage mainPage = PageFactory.initElements(DRIVER, MainPage.class);


    /**
     * Will add 2 categories, test if the category we added doesn't appear again in the search results
     *
     * @throws IOException
     * @throws InterruptedException
     */
    public void t1AddCategories() throws IOException, InterruptedException {

        DRIVER.get(BASE_URL);


        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategory()));
        mainPage.getAddCategory().click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategoryDialog()));
        AddCategoryDialog dialog = mainPage.getAddCategoryDialog();


        dialog.getSearchInput().sendKeys("sou");

        WAIT.until(webDriver -> dialog.getSearchResults().size() == 7);
        List<WebElement> searchResults = dialog.getSearchResults();

        assertEquals("We  should have 7 results", 7, searchResults.size());
        String firstSelected = searchResults.get(0).getAttribute(CLASS);
        searchResults.get(0).click();

        dialog.getAddCategoryButton().click();

        //We add a second category with the same search string, the first result should not appear
        mainPage.getAddCategory().click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategoryDialog()));


        dialog.getSearchInput().sendKeys("sou");

        WAIT.until(webDriver -> dialog.getSearchResults().size() == 6);
        searchResults = dialog.getSearchResults();

        assertEquals("We  should have 6 results", 6, searchResults.size());
        searchResults.get(0).click();
        String secondSelected = searchResults.get(0).getAttribute(CLASS);
        dialog.getAddCategoryButton().click();

        WAIT.until(driver -> mainPage.getCategoryList().getGridIcons().size() == 2);

        List<CategoryGridIcon> gridIcons = mainPage.getCategoryList().getGridIcons();
        assertEquals("We should have 2 categories", 2, gridIcons.size());

        assertNotEquals("The two categories should be different", firstSelected, secondSelected);
        assertTrue("First category on the grid should be the correct one", firstSelected.contains(gridIcons.get(0).getIcon().getAttribute(CLASS)));
        assertTrue("First category on the grid should be the correct one", secondSelected.contains(gridIcons.get(1).getIcon().getAttribute(CLASS)));
    }


    /**
     * Will test the add expense dialog to see if it works properly
     */
    public void t2TestExpenseDialog() throws InterruptedException {
        CategoryGridIcon categoryGridIcon = mainPage.getCategoryList().getGridIcons().get(0);

        categoryGridIcon.click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddExpenseDialog()));
        AddExpenseDialog expenseDialog = mainPage.getAddExpenseDialog();

        assertEquals("The category icon we clicked should have the same icon class as the one in the dialog", categoryGridIcon.getIcon().getAttribute(CLASS), expenseDialog.getHeaderIcon().getAttribute(CLASS));

        expenseDialog.getDigit1().click();
        expenseDialog.getDigit2().click();
        expenseDialog.getDigit3().click();
        expenseDialog.getDigit4().click();
        expenseDialog.getDigit5().click();
        expenseDialog.getDigit6().click();
        expenseDialog.getDigit7().click();
        expenseDialog.getDigit8().click();
        expenseDialog.getDigit9().click();
        expenseDialog.getDigit0().click();

        String expectedValue = "1234567890";
        assertEquals("We should have the proper value after clicking all the buttons", expectedValue, expenseDialog.getAmountInput().getAttribute("value"));

        expenseDialog.getDigitBackSpace().click();
        expenseDialog.getDigitDot().click();
        expenseDialog.getDigit8().click();
        expenseDialog.getDigit3().click();
        //the third digit should be ignored as only 2 digits post . should be allowed
        expenseDialog.getDigit7().click();

        expectedValue = "123456789.83";
        assertEquals("We should have the proper value after clicking all the buttons", expectedValue, expenseDialog.getAmountInput().getAttribute("value"));

        expenseDialog.getOkButton().click();

        //Now Adding one expense a month ago
        categoryGridIcon = mainPage.getCategoryList().getGridIcons().get(1);
        categoryGridIcon.click();
        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddExpenseDialog()));

        expenseDialog = mainPage.getAddExpenseDialog();
        expenseDialog.getDigit8().click();
        expenseDialog.getDigit3().click();
        expectedValue = "83";


        WebElement dateButton = expenseDialog.getDateButton();
        dateButton.click();

        WAIT.until(ExpectedConditions.visibilityOf(expenseDialog.getDatePicker()));
        ExpenseDatePicker datePicker = expenseDialog.getDatePicker();
        datePicker.getNavigatePrevious().click();

        LocalDate date = LocalDate.now();
        String expectedDate = datePicker.getDayInCenter().getText() + "/" + (date.getMonthValue() - 1) + "/" + date.getYear();
        datePicker.getDayInCenter().click();

        assertEquals("The date button should show the expected date", expectedDate, dateButton.getText());


        expenseDialog.getOkButton().click();
    }


    /**
     * This will test adding, checking and removing a recurring expense
     */
    public void t3RecurringExpensesTest() {
        mainPage.getTopSwitcher().getButtons().get(1).click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getRecurringExpenseList()));
        RecurringExpenseList recurringExpenseList = mainPage.getRecurringExpenseList();

        recurringExpenseList.getAddButton().click();
        WAIT.until(ExpectedConditions.visibilityOf(recurringExpenseList.getAddRecurringExpenseDialog()));

        AddRecurringExpenseDialog dialog = recurringExpenseList.getAddRecurringExpenseDialog();
        WAIT.until(driver -> dialog.getAvailableCategories().size() > 0);
        List<WebElement> categories = dialog.getAvailableCategories();

        assertEquals("We should have 2 categories according to previous tests", 2, categories.size());

        categories.get(1).click();
        String category = categories.get(1).getAttribute(CLASS);

        dialog.getNextButton().click();

        WAIT.until(ExpectedConditions.visibilityOf(dialog.getSelectType()));
        SelectType selectType = dialog.getSelectType();

        selectType.getFirstRow().getButtons().get(0).click();
        try {
            selectType.getSecondRow().getButtons();
            fail();
        } catch (NoSuchElementException e) {
            //we expect not to find anything
        }


        selectType.getFirstRow().getButtons().get(1).click();
        assertEquals("Clicking Weekly, we should have 7 button on the second row", 7, selectType.getSecondRow().getButtons().size());

        selectType.getFirstRow().getButtons().get(2).click();
        assertEquals("Clicking monthly, we should have 28 button on the second row", 28, selectType.getSecondRow().getButtons().size());
        selectType.getFirstRow().getButtons().get(3).click();
        assertEquals("Clicking Monthly, we should have 12 button on the second row", 12, selectType.getSecondRow().getButtons().size());

        //Clicking Month of April a we're already on the yearly selection
        selectType.getSecondRow().getButtons().get(3).click();

        dialog.getNextButton().click();
        WAIT.until(ExpectedConditions.visibilityOf(dialog.getAmountInputKeyBoard()));
        AmountInputKeyBoard amountInputKeyBoard = dialog.getAmountInputKeyBoard();

        amountInputKeyBoard.getDigit3().click();
        amountInputKeyBoard.getDigit7().click();
        amountInputKeyBoard.getDigit2().click();
        amountInputKeyBoard.getDigitBackSpace().click();
        amountInputKeyBoard.getDigitDot().click();
        amountInputKeyBoard.getDigit2().click();
        amountInputKeyBoard.getDigit5().click();

        assertEquals("The amount should be correct", "37.25", amountInputKeyBoard.getAmountInput().getAttribute("value"));

        dialog.getNextButton().click();

        //checking our recurring expense has been added
        WAIT.until(driver -> recurringExpenseList.getRecurringExpenses().size() > 0);
        List<RecurringExpense> recurringExpenses = recurringExpenseList.getRecurringExpenses();
        assertEquals("We should only have one expense", 1, recurringExpenses.size());

        RecurringExpense expense = recurringExpenses.get(0);
        assertEquals("The amount should still be correct", "37.25", expense.getAmount().getText());
        assertEquals("We selected Yearly frequency", "Yearly", expense.getFrequence().getText());
        assertTrue("The category should be the same as the one selected in the dialog", category.contains(expense.getIcon().getAttribute(CLASS)));


        expense.click();
        WAIT.until(ExpectedConditions.visibilityOf(expense.getBackFace()));
        BackFace back = expense.getBackFace();
        String nextOccurence = back.getNextOccurence().getText();

        //We've added April as a yearly expense, checking if the next occurrence is correct
        LocalDate now = LocalDate.now();
        System.out.println(nextOccurence);
        if (now.getMonthValue() >= 4) {
            assertTrue("next occurrence should be next year april", nextOccurence.contains("Apr 1, " + (now.getYear() + 1)));
        } else {
            assertTrue("next occurrence should be this year april", nextOccurence.contains("Apr 1, " + (now.getYear())));
        }


        //We clean everything by removing the recurring expense
        back.getMenubutton().click();
        WAIT.until(ExpectedConditions.visibilityOf(back.getMenu()));
        //closing for test purpose
        back.getMenu().getCloseButton().click();

        back.getMenubutton().click();
        WAIT.until(ExpectedConditions.visibilityOf(back.getMenu()));
        RecurringExpenseMenu menu = back.getMenu();
        menu.getDeleteButton().click();
        WAIT.until(ExpectedConditions.visibilityOf(menu.getDeleteConfirmDialog()));
        OkCancelDialog deleteConfirmDialog = menu.getDeleteConfirmDialog();
        deleteConfirmDialog.getCancelButton().click();


        menu.getDeleteButton().click();
        WAIT.until(ExpectedConditions.visibilityOf(menu.getDeleteConfirmDialog()));
        deleteConfirmDialog = menu.getDeleteConfirmDialog();
        deleteConfirmDialog.getOkButton().click();

        WAIT.until(driver -> recurringExpenseList.getRecurringExpenses().size() == 0);
        assertEquals("We sdhouldn't have any recurring expense", 0, recurringExpenseList.getRecurringExpenses().size());

    }

    /*
        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategory()));
        mainPage.getAddCategory().click();

        WAIT.until(ExpectedConditions.visibilityOf(mainPage.getAddCategoryDialog()));
        AddCategoryDialog dialog = mainPage.getAddCategoryDialog();


        dialog.getSearchInput().sendKeys("ho");

        List<WebElement> searchResults = dialog.getSearchResults();

        searchResults.get(0).click();

        dialog.getAddCategoryButton().click();

        //At the end we should get back to our 2 categories
        WAIT.until(driver -> mainPage.getCategoryList().getGridIcons().size() == 2);

        List<CategoryGridIcon> gridIcons = mainPage.getCategoryList().getGridIcons();
        assertEquals("We should have 2 categories", 2, gridIcons.size());
    }
    */
}
