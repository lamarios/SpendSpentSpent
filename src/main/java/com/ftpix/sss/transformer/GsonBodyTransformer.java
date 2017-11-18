package com.ftpix.sss.transformer;

import com.ftpix.sparknnotation.interfaces.BodyTransformer;
import com.ftpix.sss.SpendSpentSpent;

public class GsonBodyTransformer implements BodyTransformer {
    @Override
    public <T> T transform(String s, Class<T> aClass) {
        return SpendSpentSpent.GSON.fromJson(s, aClass);
    }
}
