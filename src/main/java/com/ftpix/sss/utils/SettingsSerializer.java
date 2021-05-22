package com.ftpix.sss.utils;

import com.ftpix.sss.models.Settings;
import com.google.gson.*;

import java.lang.reflect.Type;

import static com.ftpix.sss.services.SettingsService.OBFUSCATED_PASSWORD;

public class SettingsSerializer implements JsonSerializer<Settings> {


    @Override
    public JsonElement serialize(Settings settings, Type type, JsonSerializationContext jsonSerializationContext) {
        final JsonObject asJsonObject = new Gson().toJsonTree(settings).getAsJsonObject();

        if (settings.isSecret()) {
            asJsonObject.addProperty("value", OBFUSCATED_PASSWORD);
        }

        return asJsonObject;
    }
}
