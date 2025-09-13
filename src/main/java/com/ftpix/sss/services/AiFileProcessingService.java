package com.ftpix.sss.services;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.CategorySuggestionResponse;
import com.ftpix.sss.models.NewCategoryIcon;
import com.ftpix.sss.models.SSSFile;
import com.ftpix.sss.models.ai_responses.CategoryMatchResponse;
import com.ftpix.sss.models.ai_responses.ImageTagsResponse;
import com.ftpix.sss.services.aiClients.AiClient;
import com.ftpix.sss.services.aiClients.OllamaAiClient;
import com.ftpix.sss.services.aiClients.SssOpenAiClient;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;

import java.io.File;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;


@Service
public class AiFileProcessingService {
    private final static Logger log = LogManager.getLogger();


    @Value("${AI_VISION_MODEL:${OLLAMA_VISION_MODEL:qwen2.5vl:7b}}")
    private String visionModel;

    @Value("${AI_TEXT_MODEL:${OLLAMA_TEXT_MODEL:qwen3:8b}}")
    private String textModel;

    private AiClient aiClient;

    public final static ExecutorService exec = Executors.newSingleThreadExecutor();

    @Autowired
    public AiFileProcessingService(@Value("${OLLAMA_API_URL:}") String ollamaUrl, @Value("${OLLAMA_API_KEY:}") String ollamaApiKey, @Value("${OPENAI_API_URL:}") String openAiUrl, @Value("${OPENAI_API_KEY:no-key}") String openAiApiKey
    ) {
        if (ollamaUrl != null && !ollamaUrl.trim().isBlank()) {
            aiClient = new OllamaAiClient(ollamaUrl.trim(), ollamaApiKey.trim());
        } else if (openAiUrl != null && !openAiUrl.trim().isBlank()) {
            aiClient = new SssOpenAiClient(openAiUrl.trim(), openAiApiKey.trim());
        }
    }

    public boolean isAiEnabled() {
        return aiClient != null;
    }

    public CategorySuggestionResponse findBestCategory(File f, List<NewCategoryIcon> availableCategories) throws Exception {
        StopWatch watch = new StopWatch();
        log.info("Finding best categories for the file {}", f.getAbsolutePath());
        watch.start("Analyzing image");

        var tags = getTagsForFile(f);

        log.info("Got tags");


        List<String> availableSearchTerms = availableCategories.stream()
                .map(NewCategoryIcon::getSearchTerms)
                .flatMap(Arrays::stream)
                .distinct()
                .collect(Collectors.toList());


        String join = String.join(",", availableSearchTerms);

        watch.stop();
        watch.start("Finding best category");

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


        var prompt = findCategoryPrompt.formatted(String.join(",", tags.tags()), join);


        var response = aiClient.generateFormatted(textModel, prompt, CategoryMatchResponse.class).get(0);

        log.info("Processing finished, response: {}", response);

        var sorted = availableCategories.stream()
                .sorted((o1, o2) ->
                        Long.compare(countMatches(o2, response.categories()), countMatches(o1, response.categories())))
                .toList();

        SSSFile file = new SSSFile();
        file.setAiTags(tags.tags());
        file.setAmounts(tags.amounts());

        watch.stop();

        log.info("finished finding best category \n{}", watch.prettyPrint(TimeUnit.SECONDS));

        return new CategorySuggestionResponse(sorted, file);
    }

    private long countMatches(NewCategoryIcon icon, List<String> terms) {
        return Arrays.stream(icon.getSearchTerms()).filter(terms::contains).count();
    }

    public ImageTagsResponse getTagsForFile(File f) throws Exception {

        StopWatch watch = new StopWatch();
        watch.start("Vision analyzsis");
        log.info("Processing file {}", f.getAbsolutePath());

        String imagePrompt = """
                You are an AI system that analyze images to find what it is. \s
                
                Your task: \s
                - Describe the image focusing on items, and their descriptions. if a price is written you may add it. \s
                - Find a total price if it is written, do not do esimations \s
                - Find any information about a seller
                """;

        var result = aiClient.processImage(visionModel, imagePrompt, f);

        log.info("Image analysis finished, response: {}", result);
        log.info("Getting tags");

        watch.stop();
        watch.start("Getting tags");

        String tagPrompt = """
                You are an AI that categorizes image descriptions for an expense tracker application.
                You will be given one input:
                
                - An image description
                
                Your task:
                - Find tags that can help categorisation of an expense
                - Your tags can include the seller information if you find any
                - Find any amount and format it into a java parseable format
                - Do not include price information in the tags
                - Do not include location information in the tags
                - You will include up to 7 tags
                - The tags will be sorted in order of relevance
                - The tags will be in proper english, no special characters
                
                
                
                The description:
                %s
                
                """;

        var taggingResponse = aiClient.generateFormatted(textModel, tagPrompt.formatted(result), ImageTagsResponse.class)
                .get(0);

        log.info("Processing finished, response: {}", taggingResponse);

        taggingResponse.amounts().sort((o1, o2) -> Double.compare(o2, o1));

        watch.stop();

        log.info("finished analysing image \n{}", watch.prettyPrint(TimeUnit.SECONDS));

        return taggingResponse;
    }
}
