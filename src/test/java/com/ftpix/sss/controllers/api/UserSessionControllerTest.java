package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import com.ftpix.sss.models.Setting;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.sql.SQLException;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

public class UserSessionControllerTest {
    private SettingsController settingsController = new SettingsController();
    private UserSessionController userSessionController = new UserSessionController();


    @BeforeClass
    public static void prepareDB() throws SQLException {
        PrepareDB.prepareDB();
    }


    @Test
    public void testLogin() throws SQLException {
        ArrayList<Setting> settings = new ArrayList<>();

        Setting setting = new Setting();
        setting.setName(Setting.PASSWORD);
        setting.setValue("yo");


        Setting username = new Setting();
        username.setName(Setting.USERNAME);
        username.setValue("lamarios");

        settings.add(setting);
        settings.add(username);

        settingsController.update(settings);

        final UserSessionController.UserCredentials userCredentials = new UserSessionController.UserCredentials();
        userCredentials.password = "yo";
        userCredentials.username = "lamarios";
        assertNotNull(userSessionController.logIn(userCredentials));

        try {
            userCredentials.username = "wrong user";
            userSessionController.logIn(userCredentials);
            fail();
        } catch (HaltException e) {

        }

        try {
            userCredentials.username = "lamarios";
            userCredentials.password = "Wrong password";
            userSessionController.logIn(userCredentials);
            fail();
        } catch (HaltException e) {

        }

    }
}
