package com.ftpix.sss.transformer;

import com.ftpix.sparknnotation.interfaces.BodyTransformer;
import com.ftpix.sss.SpendSpentSpent;
import com.ftpix.sss.models.Setting;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;

public class GsonSettingListBodyTransformer implements BodyTransformer {
    @Override
    public <T> T transform(String s, Class<T> aClass) {
        Type listType = new TypeToken<ArrayList<Setting>>() {
        }.getType();


        return SpendSpentSpent.GSON.fromJson(s, listType);
    }
}
