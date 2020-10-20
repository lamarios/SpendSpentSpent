package com.ftpix.sss.utils;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;

public class JsonIgnoreStrategy implements ExclusionStrategy {
    public boolean shouldSkipField(FieldAttributes f) {
        return f.getAnnotation(JsonIgnore.class) != null;
    }

    public boolean shouldSkipClass(Class<?> clazz) {
        return false;
    }
}
