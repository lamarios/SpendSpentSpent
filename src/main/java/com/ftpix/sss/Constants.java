package com.ftpix.sss;

import java.util.Optional;
import java.util.ResourceBundle;

public class Constants {

    public final static String DB_PATH, SALT;
    public final static int HTTP_PORT;
    public static final String JSON = "application/json";
    public static final boolean ALLOW_SIGNUP = Optional.ofNullable(System.getenv("ALLOW_SIGNUP"))
            .map(s -> s.equalsIgnoreCase("1"))
            .orElse(false);

    public static final Optional<String> ANNOUNCEMENT_MESSAGE = Optional.ofNullable(System.getenv("ANNOUNCEMENT_MESSAGE"));


    public static final String CFG_DB_URL = "db.url";

    public static final String CFG_SALT = "salt";

    public static final String CFG_PORT = "http.port";
    public static final String CFG_HAS_SUBSCRIPTION = "HAS_SUBSCRIPTION";
    public static final boolean HAS_SUBSCRIPTIONS;
    public static boolean DEV_MODE = false;

    static {

        String dbUrl, salt;
        int httpPort;

        Optional<String> dbPathSysProp = Optional.ofNullable(System.getProperty(CFG_DB_URL));
        Optional<String> saltSysProp = Optional.ofNullable(System.getProperty(CFG_SALT));
        Optional<Integer> portSysProp = Optional.ofNullable(System.getProperty(CFG_PORT)).map(Integer::valueOf);
        Optional<Boolean> hasSubscriptions = Optional.ofNullable(System.getenv(CFG_HAS_SUBSCRIPTION))
                .map(Boolean::valueOf);

        HAS_SUBSCRIPTIONS = hasSubscriptions.orElse(false);


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
