package com.ftpix.sss.services.aiClients;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.models.ai_responses.OllamaResponse;
import io.github.ollama4j.Ollama;
import io.github.ollama4j.models.generate.OllamaGenerateRequest;
import io.github.ollama4j.models.response.OllamaResult;

import java.io.File;
import java.util.List;

public class OllamaAiClient implements AiClient {

    private final String ollamaUrl, ollamaApiKey;

    public OllamaAiClient(String ollamaUrl, String ollamaApiKey) {

        this.ollamaUrl = ollamaUrl;
        this.ollamaApiKey = ollamaApiKey;
    }

    private Ollama getClient() throws Exception {
        Ollama api = new Ollama(ollamaUrl);
        if (ollamaApiKey != null && !ollamaApiKey.trim().isEmpty()) {
            api.setBearerAuth(ollamaApiKey);
        }
        api.setRequestTimeoutSeconds(120);

        if (!api.ping()) {
            throw new Exception("Ollama not reachable");
        }

        return api;

    }

    @Override
    public String processImage(String model, String prompt, File f) throws Exception {
        var api = getClient();
        OllamaGenerateRequest request = OllamaGenerateRequest
                .builder()
                .withModel(model)
                .withPrompt(prompt)
                .withImages(List.of(f))
                .build();

        OllamaResult result = api.generate(request.build(), null);
        return result.getResponse();
    }

    @Override
    public <T> List<T> generateFormatted(String model, String prompt, Class<T> format) throws Exception {
        var api = getClient();

        if (OllamaResponse.class.isAssignableFrom(format)) {
            var ollamaFormat = ((OllamaResponse) format.getDeclaredConstructor().newInstance()).toOllamaFormat();

            OllamaGenerateRequest request = OllamaGenerateRequest
                    .builder()
                    .withModel(model)
                    .withPrompt(prompt)
                    .withFormat(ollamaFormat)
                    .build();

            var result = api.generate(request, null);

            return List.of(new ObjectMapper().readValue(result.getResponse(), format));
        } else {
            throw new Exception("format does not have ollama format");
        }
    }
}
