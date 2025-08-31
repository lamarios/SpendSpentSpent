package com.ftpix.sss.services;

import com.ftpix.sss.models.CategorySuggestionResponse;
import com.ftpix.sss.models.NewCategoryIcon;
import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.models.ai_responses.CategoryMatchResponse;
import com.ftpix.sss.models.ai_responses.ImageTagsResponse;
import com.google.gson.Gson;
import io.github.ollama4j.OllamaAPI;
import io.github.ollama4j.models.response.OllamaResult;
import io.github.ollama4j.utils.OptionsBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

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
    private String visionModel;

    @Value("${OLLAMA_TEXT_MODEL:qwen3:8b}")
    private String textModel;

    private final Gson gson;

    @Autowired
    public AiFileProcessingService(Gson gson) {
        this.gson = gson;
    }


    public boolean isAiEnabled() {
        return ollamaUrl != null && !ollamaUrl.trim().isEmpty();
    }


    public CategorySuggestionResponse findBestCategory(File f, List<NewCategoryIcon> availableCategories) throws Exception {
        log.info("Finding best categories for the file {}", f.getAbsolutePath());

        var tags = getTagsForFile(f);

        var tagsForPrompt = tags.stream().filter(s -> {
            try {
                var parsed = Double.parseDouble(s);
                // if we can parse it, it's a value and not useful for categorisation
                return false;
            } catch (Exception e) {
                return true;
            }
        }).toList();

        var api = getClient();

        List<String> availableSearchTerms = availableCategories.stream()
                .map(NewCategoryIcon::getSearchTerms)
                .flatMap(Arrays::stream)
                .distinct()
                .collect(Collectors.toList());


        String join = String.join(",", availableSearchTerms);

        String findCategoryPrompt = """
                You are an AI system that classifies items into the most relevant categories. \s
                You will be given two inputs: \s
                
                1. A list of tags generated from an image. \s
                2. A list of possible categories (CSV format). \s
                
                Your task: \s
                - Select the categories that are most relevant to the tags. \s
                - Do not invent new categories. \s
                - Only return categories from the provided list. \s
                - If multiple categories apply, return them all. \s
                - Format your output as a CSV list of category names.
                
                Tags:
                %s
                
                Categories:
                %s
                """;


        var prompt = findCategoryPrompt.formatted(String.join(",", tagsForPrompt), join);


        OllamaResult result = api.generate(textModel, prompt, CategoryMatchResponse.toOllamaFormat());

        log.info("Processing finished, response: {}", result.getResponse());


        var response = gson.fromJson(result.getResponse(), CategoryMatchResponse.class);

        var sorted = availableCategories.stream()
                .sorted((o1, o2) ->
                        Long.compare(countMatches(o2, response.categories()), countMatches(o1, response.categories())))
                .toList();

        SSSFile file = new SSSFile();
        file.setAiTags(tags);

        return new CategorySuggestionResponse(sorted, file);
    }

    private long countMatches(NewCategoryIcon icon, List<String> terms) {
        return Arrays.stream(icon.getSearchTerms()).filter(terms::contains).count();
    }

    public List<String> getTagsForFile(File f) throws Exception {
        log.info("Processing file {}", f.getAbsolutePath());

        var api = getClient();

        String prompt = """
                Analyze this picture and generate search tags for an expense tracking application based on what you see,
                Your tags should focus on describing the items, the price and who is selling it. If you see a price, format it so it can be parsed as double in java.
                
                You answer will only contain the tags, separated by commas. You should give at most 5 tags. Follow this instruction very strictly
                """;
        OllamaResult result = api.generateWithImageFiles(visionModel, prompt, List.of(f), new OptionsBuilder().build());

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
