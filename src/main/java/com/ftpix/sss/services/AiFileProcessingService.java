package com.ftpix.sss.services;

import io.github.ollama4j.OllamaAPI;
import io.github.ollama4j.models.response.OllamaResult;
import io.github.ollama4j.utils.OptionsBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.Arrays;
import java.util.List;


@Service
public class AiFileProcessingService {
    private final static Logger log = LogManager.getLogger();

    @Value("${OLLAMA_API_URL}")
    private String ollamaUrl;

    @Value("${OLLAMA_API_KEY:}")
    private String ollamaApiKey;

    @Value("${OLLAMA_OCR_MODEL:qwen2.5vl:7b}")
    private String ocrModel;

    private final String prompt = """
            Analyze this picture and generate search tags for an expense tracking application based on what you see, 
            your tags should focus on describing the items, the price and who is selling it. If you see a price, format it so it can be parsed as double in java.
            
            You answer will only contain the tags, separated by commas. There might be a maximum of 5 tags.
            """;


    public List<String> getTagsForFile(File f) throws Exception {
        log.info("Processing file {}", f.getAbsolutePath());

        var api = getClient();


        OllamaResult result = api.generateWithImageFiles(ocrModel,
                prompt, List.of(f),
                new OptionsBuilder().build());

        log.info("Processing finished, response: {}", result.getResponse());

        return Arrays.stream(result.getResponse().split(",")).toList();
    }


    private OllamaAPI getClient() throws Exception {
        OllamaAPI api = new OllamaAPI(ollamaUrl);
        api.setRequestTimeoutSeconds(3600);

        if (!api.ping()) {
            throw new Exception("Ollama not reachable");
        }

        return api;

    }

}
