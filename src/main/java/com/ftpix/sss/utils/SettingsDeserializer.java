package com.ftpix.sss.utils;

import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.Encryption;
import com.google.gson.*;

import java.lang.reflect.Type;
import java.util.Optional;

public class SettingsDeserializer implements JsonDeserializer<Settings> {
    @Override
    public Settings deserialize(JsonElement jsonElement, Type type, JsonDeserializationContext jsonDeserializationContext) throws JsonParseException {
        JsonObject jsonObject = jsonElement.getAsJsonObject();

        Settings settings = new Settings();

        Optional.ofNullable(jsonObject.get("name"))
                .map(JsonElement::getAsString)
                .ifPresent(settings::setName);


        Optional.ofNullable(jsonObject.get("value"))
                .map(JsonElement::getAsString)
                .ifPresent(settings::setValue);


        Optional.ofNullable(jsonObject.get("secret"))
                .map(JsonElement::getAsBoolean)
                .ifPresent(settings::setSecret);

        if (settings.isSecret()) {
            try {
                settings.setValue(Encryption.encrypt(settings.getValue()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

        return settings;

    }
}
