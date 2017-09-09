package com.ftpix.sss.transformer;

import com.ftpix.sss.SpendSpentSpent;
import spark.ResponseTransformer;

public class GsonTransformer implements ResponseTransformer{
    @Override
    public String render(Object o) throws Exception {
        return SpendSpentSpent.GSON.toJson(o);
    }
}
