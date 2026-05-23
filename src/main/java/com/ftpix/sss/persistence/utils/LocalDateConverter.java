package com.ftpix.sss.persistence.utils;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Converter(autoApply = true)
public class LocalDateConverter implements AttributeConverter<LocalDate, String> {

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public String convertToDatabaseColumn(LocalDate date) {
        return date != null ? date.format(FORMATTER) : null;
    }

    @Override
    public LocalDate convertToEntityAttribute(String dbValue) {
        return dbValue != null ? LocalDate.parse(dbValue, FORMATTER) : null;
    }
}
