package com.ftpix.sss.services.aiClients;

import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.core.JsonValue;
import com.openai.core.RequestOptions;
import com.openai.models.ChatModel;
import com.openai.models.chat.completions.*;
import com.openai.models.conversations.ConversationCreateParams;
import com.openai.models.responses.ResponseCreateParams;
import org.jooq.tools.json.JSONValue;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.Base64;
import java.util.List;
import java.util.stream.Collectors;

public class SssOpenAiClient implements AiClient {
    private final String url, apiKey;

    public SssOpenAiClient(String url, String apiKey) {
        this.url = url;
        this.apiKey = apiKey;
    }

    private OpenAIClient getClient() {
        var client = OpenAIOkHttpClient.builder().baseUrl(url)
                .checkJacksonVersionCompatibility(false);

        if (apiKey != null && !apiKey.trim().isBlank()) {
            client = client.apiKey(apiKey);

        }

        client.timeout(Duration.ofMinutes(2));

        return client.build();
    }

    @Override
    public String processImage(String model, String prompt, File f) throws Exception {
        var client = getClient();

        Path path = Path.of(f.getAbsolutePath());
        String mimeType = Files.probeContentType(path);

        byte[] imageBytes = Files.readAllBytes(path);
        String logoBase64Url = "data:" + mimeType + ";base64," + Base64.getEncoder().encodeToString(imageBytes);

        ChatCompletionContentPart imageContentPart =
                ChatCompletionContentPart.ofImageUrl(ChatCompletionContentPartImage.builder()
                        .imageUrl(ChatCompletionContentPartImage.ImageUrl.builder()
                                .url(logoBase64Url)
                                .build())
                        .build());

        ChatCompletionContentPart questionContentPart =
                ChatCompletionContentPart.ofText(ChatCompletionContentPartText.builder()
                        .text(prompt)
                        .build());

        ChatCompletionCreateParams createParams = ChatCompletionCreateParams.builder()
                .model(model)
                .addUserMessageOfArrayOfContentParts(List.of(questionContentPart, imageContentPart))
                .build();


        return client.chat().completions().create(createParams).choices().stream()
                .flatMap(choice -> choice.message().content().stream())
                .collect(Collectors.joining("\n"));
    }

    @Override
    public <T> List<T> generateFormatted(String model, String prompt, Class<T> format) throws Exception {
        var client = getClient();
        StructuredChatCompletionCreateParams<T> params = ChatCompletionCreateParams.builder()
                .addUserMessage(prompt)
                .model(model)
                .responseFormat(format)
                .build();


        return client.chat().completions().create(params).choices().stream()
                .flatMap(choice -> choice.message().content().stream())
                .toList();
    }
}
