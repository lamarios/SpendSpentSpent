package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.Setting;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;

public class SettingsControllerTest {
    private SettingsController controller = new SettingsController();

    @BeforeClass
    public static void prepareDB() throws SQLException, IOException {
        PrepareDB.prepareDB();
    }



    @Test
    public void testInsert() throws SQLException, UnsupportedEncodingException, NoSuchAlgorithmException {
        int count =  controller.getAll().size();


        Setting setting = new Setting();
        setting.setValue("Yo");
        setting.setName("mysetting");

        ArrayList<Setting> settings = new ArrayList<>();
        settings.add(setting);

        controller.update(settings);

        assertEquals(count +1, controller.getAll().size());
        assertEquals("Yo", SettingsController.get("mysetting"));

        setting.setValue("new value");
        controller.update(settings);

        assertEquals(count +1, controller.getAll().size());
        assertEquals("new value", SettingsController.get("mysetting"));


        //testing when the setting doesn't exist
        assertEquals("", SettingsController.get("some random setting"));


        setting.setName(Setting.PASSWORD);
        controller.update(settings);

        assertEquals(SettingsController.hashString("new value"), SettingsController.get(Setting.PASSWORD));

    }
}
