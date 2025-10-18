package com.ftpix.sss.utils;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.services.Encryption;

import java.io.IOException;
import java.util.Optional;

public class SettingsDeserializer extends JsonDeserializer<Settings> {

    @Override
    public Settings deserialize(JsonParser p, DeserializationContext ctxt)
            throws IOException, JsonProcessingException {

        JsonNode node = p.getCodec().readTree(p);
        Settings settings = new Settings();

        Optional.ofNullable(node.get("name"))
                .map(JsonNode::asText)
                .ifPresent(settings::setName);

        Optional.ofNullable(node.get("value"))
                .map(JsonNode::asText)
                .ifPresent(settings::setValue);

        Optional.ofNullable(node.get("secret"))
                .map(JsonNode::asBoolean)
                .ifPresent(settings::setSecret);

        if (settings.isSecret()) {
            try {
                settings.setValue(Encryption.encrypt(settings.getValue()));
            } catch (Exception e) {
                throw new RuntimeException("Failed to encrypt secret value", e);
            }
        }

        return settings;
    }
}
