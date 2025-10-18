package com.ftpix.sss.utils;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftpix.sss.models.Settings;

import java.io.IOException;

public class SettingsSerializer extends JsonSerializer<Settings> {

    private static final String OBFUSCATED_PASSWORD = "********";

    @Override
    public void serialize(Settings settings, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        gen.writeStartObject();
        gen.writeStringField("name", settings.getName());
        gen.writeBooleanField("secret", settings.isSecret());

        if (settings.isSecret()) {
            gen.writeStringField("value", OBFUSCATED_PASSWORD);
        } else {
            gen.writeStringField("value", settings.getValue());
        }

        gen.writeEndObject();
    }


}
