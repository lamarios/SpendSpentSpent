package com.ftpix.sss.services;

import com.ftpix.sss.models.NewCategoryIcon;
import io.github.ollama4j.OllamaAPI;
import io.github.ollama4j.models.response.OllamaResult;
import io.github.ollama4j.utils.OptionsBuilder;
import io.github.ollama4j.utils.PromptBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.swing.*;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


@Service
public class AiFileProcessingService {
    private final static Logger log = LogManager.getLogger();

    private final static List<String> junk = List.of("0.00", "price", "seller");

    @Value("${OLLAMA_API_URL:}")
    private String ollamaUrl;

    @Value("${OLLAMA_API_KEY:}")
    private String ollamaApiKey;

    @Value("${OLLAMA_VISION_MODEL:qwen2.5vl:7b}")
    private String ocrModel;


    public boolean isAiEnabled() {
        return ollamaUrl != null && !ollamaUrl.trim().isEmpty();
    }


    public List<NewCategoryIcon> findBestCategory(File f, List<NewCategoryIcon> availableCategories) throws Exception {
        log.info("Finding best categories for the file {}", f.getAbsolutePath());

        var api = getClient();

        List<String> availableSearchTerms = availableCategories.stream()
                .map(NewCategoryIcon::getSearchTerms)
                .flatMap(Arrays::stream)
                .distinct()
                .collect(Collectors.toList());

        String findCategoryPrompt = """
                Analyse this picture and sort the comma separated workds below based on what would match the picture the most:
                --------------------------------------------------
                %s
                --------------------------------------------------
                Your answer will only contain the list above sorted from most relevant to least relevant. Follow this instruction very strictly
                """;

        var prompt = findCategoryPrompt.formatted(String.join(",", availableSearchTerms));

        OllamaResult result = api.generateWithImageFiles(ocrModel, prompt, List.of(f), new OptionsBuilder().build());

        log.info("Processing finished, response: {}", result.getResponse());

        return new ArrayList<>();
    }

    public List<String> getTagsForFile(File f) throws Exception {
        log.info("Processing file {}", f.getAbsolutePath());

        var api = getClient();


        String prompt = """
                Analyze this picture and generate search tags for an expense tracking application based on what you see,
                Your tags should focus on describing the items, the price and who is selling it. If you see a price, format it so it can be parsed as double in java.
                
                You answer will only contain the tags, separated by commas. You should give at most 5 tags. Follow this instruction very strictly
                """;
        OllamaResult result = api.generateWithImageFiles(ocrModel, prompt, List.of(f), new OptionsBuilder().build());

        log.info("Processing finished, response: {}", result.getResponse());

        return Arrays.stream(result.getResponse().split(",")).map(String::trim)
                // filtering junk
                .filter(s -> !junk.contains(s)).toList();
    }


    private OllamaAPI getClient() throws Exception {
        OllamaAPI api = new OllamaAPI(ollamaUrl);
        api.setRequestTimeoutSeconds(3600);
        api.setVerbose(false);

        if (!api.ping()) {
            throw new Exception("Ollama not reachable");
        }

        return api;

    }

}
