package com.ftpix.sss;

import java.util.ResourceBundle;

public class Constants {

    public final static String DB_PATH, SALT;
    public final static int HTTP_PORT;
    public static final String JSON = "application/json";

    static {
        ResourceBundle rs = ResourceBundle.getBundle("config");

        DB_PATH = rs.getString("db.url");
        SALT = rs.getString("salt");
        HTTP_PORT = Integer.parseInt(rs.getString("http.port"));
    }
}
