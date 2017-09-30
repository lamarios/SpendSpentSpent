package com.ftpix.sss;

import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Category;

import java.sql.SQLException;
import java.util.List;

public class PrepareDB {

    private static boolean dbReady = false;

    public static synchronized void prepareDB() throws SQLException {
        if (!dbReady) {
            Category anchor = new Category();
            anchor.setId(1);
            anchor.setIcon("icon-anchor");

            Category violin = new Category();
            violin.setId(2);
            violin.setIcon("icon-violin");


            Category gas = new Category();
            gas.setId(3);
            gas.setIcon("icon-gas");


            DB.CATEGORY_DAO.create(List.of(anchor, violin, gas));
        }
        dbReady = true;
    }
}
