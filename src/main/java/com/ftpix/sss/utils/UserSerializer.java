package com.ftpix.sss.utils;

import com.ftpix.sss.models.User;
import com.google.gson.*;

import java.lang.reflect.Type;

public class UserSerializer implements JsonSerializer<User> {
    @Override
    public JsonElement serialize(User user, Type type, JsonSerializationContext jsonSerializationContext) {
        final JsonObject asJsonObject = new Gson().toJsonTree(user).getAsJsonObject();

        asJsonObject.remove("password");
        return asJsonObject;
    }
}
