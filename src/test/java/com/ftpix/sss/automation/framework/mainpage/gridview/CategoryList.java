package com.ftpix.sss.automation.framework.mainpage.gridview;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.stream.Collectors;

public class CategoryList extends ElementImpl {

    private final static String SELECTOR = ".CategoryList ";
    public static final By CATEGORY_GRID_ICONS = By.cssSelector(SELECTOR + ".CategoryGridIcon");

    public CategoryList(WebElement element) {
        super(element);
    }


    /**
     * Get the list of icons from the main page grid
     *
     * @return the list of items
     */
    public List<CategoryGridIcon> getGridIcons() {
        return findElements(CATEGORY_GRID_ICONS)
                .stream()
                .map(e -> new CategoryGridIcon(e))
                .collect(Collectors.toList());
    }
}
