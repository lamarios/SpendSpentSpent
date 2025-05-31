package com.ftpix.sss.services;

import com.ftpix.sss.models.CurrencyStatus;
import com.ftpix.sss.models.CurrencyValue;
import com.ftpix.sss.models.Settings;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.github.benmanes.caffeine.cache.LoadingCache;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import com.mashape.unirest.request.GetRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.logging.log4j.util.Strings;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Type;
import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class CurrencyService {
    private final SettingsService settingsService;
    private static final String BASE_CURRENCY = "USD";
    private final LoadingCache<String, Map<String, CurrencyValue>> currencyCache = Caffeine.newBuilder()
            .expireAfterWrite(24, TimeUnit.HOURS)
            .build(this::getCurrency);
    protected final Log log = LogFactory.getLog(this.getClass());

    @Autowired
    public CurrencyService(SettingsService settingsService) {
        this.settingsService = settingsService;
    }


    public boolean canUseCurrencyConversion() {
        try {
            Map<String, CurrencyValue> stringCurrencyValueMap = currencyCache.get(BASE_CURRENCY);

            return stringCurrencyValueMap != null && !stringCurrencyValueMap.isEmpty();
        } catch (Exception e) {
            log.error("Error while getting currency", e);
            return false;
        }
    }

    public Double getCurrency(String from, String to) {
        if (from.equalsIgnoreCase(to)) {
            return 1D;
        }
        // we always use US as a base
        Map<String, CurrencyValue> currencies = currencyCache.get(BASE_CURRENCY);

        if (!currencies.containsKey(to) || !currencies.containsKey(from)) {
            throw new InvalidParameterException("unknown currency");
        }

        if (from.equalsIgnoreCase(BASE_CURRENCY)) {
            return currencies.get(to).getValue();
        }

        double fromToUsd = currencies.get(from).getValue();
        double toToUsd = currencies.get(to).getValue();
        double percentage = toToUsd / fromToUsd;


        return Math.ceil(percentage * 100) / 100;
    }

    private Map<String, CurrencyValue> getCurrency(String base) throws UnirestException, SQLException {
        final Settings apiKey = settingsService.getByName(Settings.CURRENCY_API_KEY);
        if (apiKey == null || Strings.isBlank(apiKey.getRealValue())) {
            throw new InvalidParameterException("currency api key is required");
        }


        var decryptedKey = apiKey.getRealValue();
        GetRequest request = Unirest.get("https://api.currencyapi.com/v3/latest?apikey=" + decryptedKey)
                .header("accept", "application/json")
                .header("content-type", "application/json");


        final JsonNode body = request.asJson().getBody();
        final JSONObject data = body.getObject().getJSONObject("data");
        Type currencyType = new TypeToken<Map<String, CurrencyValue>>() {
        }.getType();
        return new Gson().fromJson(data.toString(0), currencyType);

    }

    public CurrencyStatus getQuota() throws SQLException, UnirestException {
        final Settings apiKey = settingsService.getByName(Settings.CURRENCY_API_KEY);
        if (apiKey == null || Strings.isBlank(apiKey.getRealValue())) {
            throw new InvalidParameterException("currency api key is required");
        }

        GetRequest request = Unirest.get("https://api.currencyapi.com/v3/status?apikey=" + apiKey.getRealValue())
                .header("accept", "application/json")
                .header("content-type", "application/json");


        final JsonNode body = request.asJson().getBody();
        final JSONObject quotas = body.getObject().getJSONObject("quotas");
        final JSONObject month = quotas.getJSONObject("month");


        return new Gson().fromJson(month.toString(0), CurrencyStatus.class);
    }

    public void resetCache() {
        currencyCache.invalidateAll();
    }
}
