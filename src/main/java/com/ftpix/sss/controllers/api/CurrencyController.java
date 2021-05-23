package com.ftpix.sss.controllers.api;

import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.SettingsService;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.github.benmanes.caffeine.cache.LoadingCache;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import com.mashape.unirest.request.GetRequest;
import io.swagger.annotations.Api;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/API/Currency")
@Api(tags = {"Currency"})
public class CurrencyController {
    private final SettingsService settingsService;
    private final LoadingCache<String, Map<String, Double>> currencyCache = Caffeine.newBuilder()
            .expireAfterWrite(24, TimeUnit.HOURS)
            .build(this::getCurrency);

    @Autowired
    public CurrencyController(SettingsService settingsService) {
        this.settingsService = settingsService;
    }


    @GetMapping("{from}/{to}")
    public Double get(@PathVariable String from, @PathVariable String to) throws SQLException, UnirestException {
        if (from.equalsIgnoreCase(to)) {
            return 1D;
        }
        return currencyCache.get(from).get(to);
    }

    private Map<String, Double> getCurrency(String base) throws UnirestException, SQLException {
        final Settings apiKey = settingsService.getByName(Settings.CURRENCY_API_KEY);
        GetRequest request = Unirest.get("https://freecurrencyapi.net/api/v1/rates?base_currency=" + base)
                .header("accept", "application/json")
                .header("content-type", "application/json");

        if (apiKey != null) {
            request = request.header("apiKey", apiKey.getRealValue());
        }

        final JsonNode body = request.asJson().getBody();
        final JSONObject data = body.getObject().getJSONObject("data");
        if (!data.keySet().isEmpty()) {
            final JSONObject jsonObject = data.getJSONObject(data.keys().next());
            Map<String, Double> result = new HashMap<>();

            jsonObject.keySet().forEach(k -> result.put(k, jsonObject.getDouble(k)));

            return result;
        } else {
            return new HashMap<>();
        }


    }

}
