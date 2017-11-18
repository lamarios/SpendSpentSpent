package com.ftpix.sss;

import java.util.Optional;
import java.util.ResourceBundle;

public class Constants {

    public final static String DB_PATH, SALT;
    private final static int HTTP_PORT;
    public static final String JSON = "application/json";


    private static final String CFG_DB_URL = "db.url";

    private static final String CFG_SALT = "salt";

    private static final String CFG_PORT = "http.port";

    static {

        String dbUrl, salt;
        int httpPort;

        Optional<String> dbPathSysProp = Optional.ofNullable(System.getProperty(CFG_DB_URL));
        Optional<String> saltSysProp = Optional.ofNullable(System.getProperty(CFG_SALT));
        Optional<Integer> portSysProp = Optional.ofNullable(System.getProperty(CFG_PORT)).map(Integer::valueOf);


        if (dbPathSysProp.isPresent() && saltSysProp.isPresent() && portSysProp.isPresent()) {
            dbUrl = dbPathSysProp.get();
            salt = saltSysProp.get();
            httpPort = portSysProp.get();

        } else {

            ResourceBundle rs = ResourceBundle.getBundle("config");

            dbUrl = rs.getString(CFG_DB_URL);
            salt = rs.getString(CFG_SALT);
            httpPort = Integer.parseInt(rs.getString(CFG_PORT));
        }

        DB_PATH = dbUrl;
        SALT = salt;
        HTTP_PORT = httpPort;


        System.out.println("SpendSpentSpent config ====================");
        System.out.println("DB URL = " + DB_PATH);
        System.out.println("HTTP PORT = " + HTTP_PORT);
        System.out.println("SALT = " + SALT);
    }
}
