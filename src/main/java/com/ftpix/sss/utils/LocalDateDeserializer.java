package com.ftpix.sss.utils;


import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class LocalDateDeserializer extends JsonDeserializer<LocalDate> {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public LocalDate deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String text = p.getText();
        return LocalDate.parse(text, FORMATTER);
    }
}
