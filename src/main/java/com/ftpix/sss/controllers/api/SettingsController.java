package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Setting;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;


@SparkController("/API/Setting")
public class SettingsController {
    private final static Logger logger = LogManager.getLogger();

    private final static String FIELD_VALUE = "value";
    private static final String FIELD_NAME = "name";


    /**
     * Get all settings
     * @return the list of settings
     * @throws SQLException
     */
    @SparkGet(transformer = GsonTransformer.class)
    public List<Setting> getAll() throws SQLException {
        return DB.SETTING_DAO.queryForAll();
    }

    /**
     * Update a setting
     * @param name the name of the setting
     * @param value the new value of the settings
     * @return
     * @throws SQLException
     */
    @SparkPut(value="/:name")
    public boolean update(@SparkParam(FIELD_NAME) String name, @SparkQueryParam(FIELD_VALUE) String value) throws SQLException {

        Setting setting = DB.SETTING_DAO.queryForId(name);

        if (setting == null) {
            setting = new Setting();
            setting.setName(name);
        }


        switch (setting.getName()) {
            case Setting.PASSWORD:
                try {
                    if (!value.equalsIgnoreCase("")) {
                        setting.setValue(hashString(value));
                        logger.info("Clearing all sessions");
                        DB.USER_SESSION_DAO.delete(DB.USER_SESSION_DAO.queryForAll());
                    } else {
                        return true;
                    }
                } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
                   logger.error("falied to save password", e);
                    Spark.halt(503, e.getMessage());
                }
                break;
            default:
                setting.setValue(value);
        }

        DB.SETTING_DAO.createOrUpdate(setting);

        return true;
    }


    /**
     * String hash for passowrds
     * @param str the string to hash
     * @return the new string
     * @throws NoSuchAlgorithmException
     * @throws UnsupportedEncodingException
     */
    public static String hashString(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest md5;
        md5 = MessageDigest.getInstance("MD5");
        str += Constants.SALT;

        md5.update(str.getBytes());

        byte[] byteData = md5.digest();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }

        return sb.toString();
    }


    /**
     * get a setting value
     * @param name
     * @return
     */
    public static String get(String name){
        try {
            return Optional.ofNullable(DB.SETTING_DAO.queryForId(name)).map(Setting::getValue).orElse("");
        } catch (SQLException e) {
            logger.error("Couldn't get setting {}", name, e);
            return "";
        }
    }
}
