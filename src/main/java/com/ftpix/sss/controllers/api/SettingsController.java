package com.ftpix.sss.controllers.api;

import com.ftpix.sparknnotation.annotations.*;
import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.Setting;
import com.ftpix.sss.transformer.GsonBodyTransformer;
import com.ftpix.sss.transformer.GsonSettingListBodyTransformer;
import com.ftpix.sss.transformer.GsonTransformer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.Spark;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;


@SparkController("/API/Setting")
public class SettingsController {
    private final static Logger logger = LogManager.getLogger();

    private final static String FIELD_VALUE = "value";
    private static final String FIELD_NAME = "name";


    /**
     * Get all settings
     *
     * @return the list of settings
     * @throws SQLException
     */
    @SparkGet(transformer = GsonTransformer.class)
    public Map<String, Setting> getAll() throws SQLException {
        return DB.SETTING_DAO.queryForAll().stream().collect(Collectors.toMap(Setting::getName, Function.identity()));
    }

    /**
     * Update a setting
     *
     * @param settings A list setting to save;
     * @return
     * @throws SQLException
     */
    @SparkPut(transformer = GsonTransformer.class)
    public boolean update(@SparkBody(GsonSettingListBodyTransformer.class) ArrayList<Setting> settings) throws SQLException {

        settings.stream()
        .filter(s-> s != null)
        .forEach(setting -> {
            try {
                switch (setting.getName()) {
                    case Setting.PASSWORD:
                        try {
                            if (!setting.getValue().equalsIgnoreCase("")) {
                                setting.setValue(hashString(setting.getValue()));
                            }
                        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
                            logger.error("failed to save password", e);
                            Spark.halt(503, e.getMessage());
                        }
                        break;
                    default:
                        setting.setValue(setting.getValue());
                }
                DB.SETTING_DAO.createOrUpdate(setting);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        });
        return true;
    }

    /**
     * Gets a setting value by its name
     * @param name
     * @return
     */
    @SparkGet(value = "/:name", transformer = GsonTransformer.class)
    public String getByName(@SparkParam(":name") String name){
        return SettingsController.get(name);
    }

    /**
     * String hash for passowrds
     *
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
     *
     * @param name
     * @return
     */
    public static String get(String name) {
        try {
            return Optional.ofNullable(DB.SETTING_DAO.queryForId(name)).map(Setting::getValue).orElse("");
        } catch (SQLException e) {
            logger.error("Couldn't get setting {}", name, e);
            return "";
        }
    }
}
