package com.ftpix.sss.automation.framework.common;

import com.ftpix.sss.automation.utils.ElementImpl;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

public class AmountInputKeyBoard extends ElementImpl {
    private static final By AMOUNT_INPUT = By.cssSelector(".amount input");

    private static final By DIGIT_BACKSPACE = By.cssSelector(".digit:nth-of-type(4) div:nth-of-type(3)");
    private static final By DIGIT_0 = By.cssSelector(".digit:nth-of-type(4) div:nth-of-type(2)");
    private static final By DIGIT_DOT = By.cssSelector(".digit:nth-of-type(4) div:nth-of-type(1)");
    private static final By DIGIT_9 = By.cssSelector(".digit:nth-of-type(3) div:nth-of-type(3)");
    private static final By DIGIT_8 = By.cssSelector(".digit:nth-of-type(3) div:nth-of-type(2)");
    private static final By DIGIT_7 = By.cssSelector(".digit:nth-of-type(3) div:nth-of-type(1)");
    private static final By DIGIT_6 = By.cssSelector(".digit:nth-of-type(2) div:nth-of-type(3)");
    private static final By DIGIT_5 = By.cssSelector(".digit:nth-of-type(2) div:nth-of-type(2)");
    private static final By DIGIT_4 = By.cssSelector(".digit:nth-of-type(2) div:nth-of-type(1)");
    private static final By DIGIT_3 = By.cssSelector(".digit:nth-of-type(1) div:nth-of-type(3)");
    private static final By DIGIT_2 = By.cssSelector(".digit:nth-of-type(1) div:nth-of-type(2)");
    private static final By DIGIT_1 = By.cssSelector(".digit:nth-of-type(1) div:nth-of-type(1)");

    public AmountInputKeyBoard(WebElement element) {
        super(element);
    }

    public WebElement getAmountInput() {
        return findElement(AMOUNT_INPUT);
    }

    public WebElement getDigit1() {
        return findElement(DIGIT_1);
    }


    public WebElement getDigit2() {
        return findElement(DIGIT_2);
    }

    public WebElement getDigit3() {
        return findElement(DIGIT_3);
    }

    public WebElement getDigit4() {
        return findElement(DIGIT_4);
    }

    public WebElement getDigit5() {
        return findElement(DIGIT_5);
    }

    public WebElement getDigit6() {
        return findElement(DIGIT_6);
    }

    public WebElement getDigit7() {
        return findElement(DIGIT_7);
    }

    public WebElement getDigit8() {
        return findElement(DIGIT_8);
    }

    public WebElement getDigit9() {
        return findElement(DIGIT_9);
    }

    public WebElement getDigitDot() {
        return findElement(DIGIT_DOT);
    }

    public WebElement getDigit0() {
        return findElement(DIGIT_0);
    }

    public WebElement getDigitBackSpace() {
        return findElement(DIGIT_BACKSPACE);
    }
}
