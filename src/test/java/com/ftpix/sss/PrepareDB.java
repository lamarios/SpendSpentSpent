package com.ftpix.sss;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sss.controllers.api.UserSessionController;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class PrepareDB {

    public static User USER;
    public static String TOKEN;
    private static boolean dbReady = false;
    private static int count = 0;
    public static synchronized void prepareDB() throws SQLException, IOException {
        count++;
        if (!dbReady) {

            User user = new User();
            user.setFirstName("Tester");
            user.setLastName("Super");
            user.setEmail("supertester@example.org");
            user.setAdmin(true);
            user.setPassword("Passworrrrererere");
            user.setSubscriptionExpiryDate(Long.MAX_VALUE);
            DB.USER_DAO.create(user);
            USER = user;

            TOKEN = new UserSessionController().createTokenForUser(user);

            Category anchor = new Category();
            anchor.setId(1);
            anchor.setIcon("icon-anchor");
            anchor.setUser(user);

            Category violin = new Category();
            violin.setId(2);
            violin.setIcon("icon-violin");
            violin.setUser(user);

            Category gas = new Category();
            gas.setId(3);
            gas.setIcon("icon-gas");
            gas.setUser(user);

            DB.CATEGORY_DAO.create(List.of(anchor, violin, gas));

            Sparknotation.init();
        }
        dbReady = true;
    }


    private void stopSpark(){

    }
}
