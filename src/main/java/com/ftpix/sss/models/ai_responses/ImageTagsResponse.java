package com.ftpix.sss.models.ai_responses;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public record ImageTagsResponse(List<String> tags, List<Double> amounts) implements  OllamaResponse{

    public ImageTagsResponse() {
        this(null, null);
    }

    public Map<String, Object> toOllamaFormat() {
        Map<String, Object> format = new HashMap<>();
        format.put("type", "object");
        format.put("properties", new HashMap<String, Object>() {
            {
                put("tags", new HashMap<String, Object>() {
                    {
                        put("type", "array");
                        put("items", Map.of("type", "string"));
                    }
                });
                put("amounts", new HashMap<String, Object>() {
                    {
                        put("type", "array");
                        put("items", Map.of("type", "number"));
                    }
                });
            }
        });
        format.put("required", Arrays.asList("tags", "amounts"));

        return format;
    }

}
