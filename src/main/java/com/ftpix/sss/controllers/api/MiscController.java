package com.ftpix.sss.controllers.api;


import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * All things that don't really have a category
 */
@RestController
@RequestMapping("/API/Misc")
public class MiscController {

    @Autowired
    private final BuildProperties buildProperties;

    public MiscController(BuildProperties buildProperties) {
        this.buildProperties = buildProperties;
    }


    @GetMapping("/version")
    public Map<String, String> getLocalAndLatestVersion() throws IOException, UnirestException {
        Map<String, String> versions = new HashMap<>();

        versions.put("local", buildProperties.getVersion());


        versions.put("latest", getLatestVersion());

        return versions;
    }


    /**
     * GEts the latest version from github
     *
     * @return
     * @throws UnirestException
     */
    private String getLatestVersion() throws UnirestException {
        String url = "https://api.github.com/repos/lamarios/SpendSpentSpent/releases/latest";

        String response = Unirest.get(url).asString().getBody();

        JSONObject json = new JSONObject(response);
        if (json.has("name")) {
            return json.getString("name");
        } else {
            return "";
        }

    }
}
