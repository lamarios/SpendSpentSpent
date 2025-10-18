package com.ftpix.sss.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.models.CurrencyStatus;
import com.ftpix.sss.models.CurrencyValue;
import com.ftpix.sss.models.Settings;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.github.benmanes.caffeine.cache.LoadingCache;
import kong.unirest.GetRequest;
import kong.unirest.JsonNode;
import kong.unirest.Unirest;
import kong.unirest.UnirestException;
import kong.unirest.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class CurrencyService {
    private final SettingsService settingsService;
    private static final String BASE_CURRENCY = "USD";
    private final LoadingCache<String, Map<String, CurrencyValue>> currencyCache;
    protected final Log log = LogFactory.getLog(this.getClass());
    private final ObjectMapper objectMapper;

    @Autowired
    public CurrencyService(SettingsService settingsService, ObjectMapper objectMapper) {
        this.settingsService = settingsService;
        currencyCache = Caffeine.newBuilder()
                .expireAfterWrite(24, TimeUnit.HOURS)
                .build(this::getCurrency);
        this.objectMapper = objectMapper;
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


    @Transactional(readOnly = true)
    public Map<String, CurrencyValue> getCurrency(String base) throws UnirestException, SQLException, JsonProcessingException {
        final Settings apiKey = settingsService.getByName(Settings.CURRENCY_API_KEY);
        if (apiKey == null || Strings.isBlank(apiKey.getRealValue())) {
//            throw new InvalidParameterException("currency api key is required");
            log.warn("No currency api key");
            return new HashMap<>();
        }


        var decryptedKey = apiKey.getRealValue();
        GetRequest request = Unirest.get("https://api.currencyapi.com/v3/latest?apikey=" + decryptedKey)
                .header("accept", "application/json")
                .header("content-type", "application/json");


        final JsonNode body = request.asJson().getBody();
        final JSONObject data = body.getObject().getJSONObject("data");
        return objectMapper.readValue(data.toString(0), new TypeReference<Map<String, CurrencyValue>>() {
        });

    }

    @Transactional(readOnly = true)
    public CurrencyStatus getQuota() throws SQLException, UnirestException, JsonProcessingException {
        final Settings apiKey = settingsService.getByName(Settings.CURRENCY_API_KEY);
        if (apiKey == null || Strings.isBlank(apiKey.getRealValue())) {
            log.warn("no api key");
            return null;
        }

        GetRequest request = Unirest.get("https://api.currencyapi.com/v3/status?apikey=" + apiKey.getRealValue())
                .header("accept", "application/json")
                .header("content-type", "application/json");

        try {
            final JsonNode body = request.asJson().getBody();
            final JSONObject quotas = body.getObject().getJSONObject("quotas");
            final JSONObject month = quotas.getJSONObject("month");

            return objectMapper.readValue(month.toString(0), CurrencyStatus.class);
        } catch (Exception e) {
            log.warn("Error while getting currency status", e);
            return null;
        }
    }

    public void resetCache() {
        currencyCache.invalidateAll();
    }
}
