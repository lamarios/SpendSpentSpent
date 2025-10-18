package com.ftpix.sss.services.aiClients;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.models.ai_responses.OllamaResponse;
import io.github.ollama4j.OllamaAPI;
import io.github.ollama4j.models.response.OllamaResult;
import io.github.ollama4j.utils.OptionsBuilder;

import java.io.File;
import java.util.List;

public class OllamaAiClient implements AiClient {

    private final String ollamaUrl, ollamaApiKey;

    public OllamaAiClient(String ollamaUrl, String ollamaApiKey) {

        this.ollamaUrl = ollamaUrl;
        this.ollamaApiKey = ollamaApiKey;
    }

    private OllamaAPI getClient() throws Exception {
        OllamaAPI api = new OllamaAPI(ollamaUrl);
        if (ollamaApiKey != null && !ollamaApiKey.trim().isEmpty()) {
            api.setBearerAuth(ollamaApiKey);
        }
        api.setRequestTimeoutSeconds(120);
        api.setVerbose(false);

        if (!api.ping()) {
            throw new Exception("Ollama not reachable");
        }

        return api;

    }

    @Override
    public String processImage(String model, String prompt, File f) throws Exception {
        var api = getClient();
        OllamaResult result = api.generateWithImageFiles(model, prompt, List.of(f), new OptionsBuilder().build());
        return result.getResponse();
    }

    @Override
    public <T> List<T> generateFormatted(String model, String prompt, Class<T> format) throws Exception {
        var api = getClient();

        if (OllamaResponse.class.isAssignableFrom(format)) {
            var ollamaFormat = ((OllamaResponse) format.getDeclaredConstructor().newInstance()).toOllamaFormat();

            var result = api.generate(model, prompt, ollamaFormat);

            return List.of(new ObjectMapper().readValue(result.getResponse(), format));
        } else {
            throw new Exception("format does not have ollama format");
        }
    }
}
