package com.ftpix.sss.controllers.api;

import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

public class UpdateControllerTest {


    @Test
    public void testVersionNumbers() {
        UpdateController updater = new UpdateController();

        String left = "1";
        String right = "2";
        assertEquals(-1, updater.compareVersion(left, right));

        left = "2";
        right = "1";
        assertEquals(1, updater.compareVersion(left, right));

        left = "1";
        right = "1";
        assertEquals(0, updater.compareVersion(left, right));

        left = "1";
        right = "1-B1";
        assertEquals(1, updater.compareVersion(left, right));

        left = "1-B1";
        right = "1";
        assertEquals(-1, updater.compareVersion(left, right));

        left = "1-B1";
        right = "1-RC1";
        assertEquals(-1, updater.compareVersion(left, right));

        left = "1-RC1";
        right = "1-B4";
        assertEquals(1, updater.compareVersion(left, right));

        left = "1-B3";
        right = "1-B4";
        assertEquals(-1, updater.compareVersion(left, right));

        left = "1-B5";
        right = "1-B4";
        assertEquals(1, updater.compareVersion(left, right));

        left = "1-B4";
        right = "1-B4";
        assertEquals(0, updater.compareVersion(left, right));

        left = "fdfsd";
        right = "1-B4";
        assertEquals(0, updater.compareVersion(left, right));

    }

}
