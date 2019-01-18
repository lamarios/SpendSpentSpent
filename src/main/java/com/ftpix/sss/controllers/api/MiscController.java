package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sparknnotation.annotations.SparkGet;
import com.ftpix.sss.Constants;
import com.ftpix.sss.transformer.GsonTransformer;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * All things that don't really have a category
 */
@SparkController("/API/Misc")
public class MiscController {
    private String localVersion;


    public MiscController() {
        ResourceBundle rs = ResourceBundle.getBundle("version");
        localVersion = rs.getString("version");
    }


    @SparkGet(value = "/version", accept = Constants.JSON, transformer = GsonTransformer.class)
    public Map<String, String> getLocalAndLatestVersion() throws IOException, UnirestException {
        Map<String, String> versions = new HashMap<>();

        versions.put("local", localVersion);



        versions.put("latest", getLatestVersion());

        return versions;
    }


    /**
     * GEts the latest version from github
     * @return
     * @throws UnirestException
     */
    private String getLatestVersion() throws UnirestException {
        String url = "https://api.github.com/repos/lamarios/SpendSpentSpent/releases/latest";

        String response = Unirest.get(url).asString().getBody();

        JSONObject json = new JSONObject(response);
        if(json.has("name")){
            return json.getString("name");
        }else{
            return "";
        }

    }
}
