package com.ftpix.sss.automation.framework.mainpage;

import com.ftpix.sss.automation.framework.interfaces.SssPage;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MainPage implements SssPage{

    @FindBy(css = ".CenterColumn")
    private WebElement self;

    @FindBy(css = ".CategoryList .list-settings .fa-plus")
    private WebElement addCategory;

    @FindBy(css = ".AddCategoryDialog")
    private WebElement addCategoryDialog;


    public AddCategoryDialog getAddCategoryDialog() {
        return new AddCategoryDialog(addCategoryDialog, this);
    }

    public WebElement getAddCategory() {
        return addCategory;
    }

    @Override
    public WebElement getSelf() {
        return self;
    }
}
