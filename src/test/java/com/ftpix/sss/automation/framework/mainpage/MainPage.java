package com.ftpix.sss.automation.framework.mainpage;

import com.ftpix.sss.automation.framework.common.Switcher;
import com.ftpix.sss.automation.framework.interfaces.SssPage;
import com.ftpix.sss.automation.framework.mainpage.gridview.AddCategoryDialog;
import com.ftpix.sss.automation.framework.mainpage.gridview.AddExpenseDialog;
import com.ftpix.sss.automation.framework.mainpage.gridview.CategoryList;
import com.ftpix.sss.automation.framework.mainpage.recurring.RecurringExpenseList;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MainPage implements SssPage {

    @FindBy(css = ".CenterColumn")
    private WebElement self;

    @FindBy(css = ".CategoryList .list-settings .fa-plus")
    private WebElement addCategory;

    @FindBy(css = ".AddCategoryDialog")
    private WebElement addCategoryDialog;

    @FindBy(css = ".CategoryList")
    private WebElement categoryList;

    @FindBy(css = ".AddExpenseDialog")
    private WebElement addExpenseDialog;

    @FindBy(css = ".Switcher")
    private WebElement switcher;

    @FindBy(css = ".RecurringExpenseList")
    private WebElement recurringExpenses;

    public CategoryList getCategoryList() {
        return new CategoryList(categoryList);
    }

    public AddCategoryDialog getAddCategoryDialog() {
        return new AddCategoryDialog(addCategoryDialog);
    }

    public WebElement getAddCategory() {
        return addCategory;
    }

    public AddExpenseDialog getAddExpenseDialog() {
        return new AddExpenseDialog(addExpenseDialog);
    }

    public Switcher getTopSwitcher() {
        return new Switcher(switcher);
    }

    public RecurringExpenseList getRecurringExpenseList() {
        return new RecurringExpenseList(recurringExpenses);
    }

    @Override
    public WebElement getSelf() {
        return self;
    }
}
