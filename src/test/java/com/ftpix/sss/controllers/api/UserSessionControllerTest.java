package com.ftpix.sss.controllers.api;

import com.ftpix.sss.PrepareDB;
import org.junit.BeforeClass;
import org.junit.Test;
import spark.HaltException;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

public class UserSessionControllerTest {
/*
    private SettingsController settingsController = new SettingsController();
    private UserSessionController userSessionController = new UserSessionController(userController, settingsController);


    @BeforeClass
    public static void prepareDB() throws SQLException, IOException, NoSuchAlgorithmException {
        PrepareDB.prepareDB();
    }


    @Test
    public void testLogin() throws SQLException {

        final UserSessionController.UserCredentials userCredentials = new UserSessionController.UserCredentials();
        userCredentials.password = "pass";
        userCredentials.email = "test@example.org";
        assertNotNull(userSessionController.logIn(userCredentials));

        try {
            userCredentials.email = "wrong user";
            userSessionController.logIn(userCredentials);
            fail();
        } catch (HaltException e) {
            e.printStackTrace();
        }

        try {
            userCredentials.email = "lamarios";
            userCredentials.password = "Wrong password";
            userSessionController.logIn(userCredentials);
            fail();
        } catch (HaltException e) {
            e.printStackTrace();
        }

    }
*/
}
