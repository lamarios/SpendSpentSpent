package com.ftpix.sss.models.ai_responses;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public record ImageTagsResponse(List<String> tags) {
    public static Map<String, Object> toOllamaFormat() {
        Map<String, Object> format = new HashMap<>();
        format.put("type", "array");
        format.put("properties", new HashMap<String, Object>() {
            {
                put("tags", new HashMap<String, Object>() {
                    {
                        put("type", "array");
                        put("items", Map.of("type", "string"));
                    }
                });
            }
        });
        format.put("required", Arrays.asList("tags"));

        return format;
    }

}
