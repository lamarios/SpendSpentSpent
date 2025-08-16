package com.ftpix.sss.utils;

import com.google.gson.*;

import java.lang.reflect.Type;
import java.time.LocalDate;

import static com.ftpix.sss.Constants.dateFormatter;

public class LocalDateGsonAdapter implements JsonSerializer<LocalDate>, JsonDeserializer<LocalDate> {

    @Override
    public JsonElement serialize(LocalDate date, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(date.format(dateFormatter));
    }

    @Override
    public LocalDate deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {
        return LocalDate.parse(json.getAsString(), dateFormatter);
    }
}
