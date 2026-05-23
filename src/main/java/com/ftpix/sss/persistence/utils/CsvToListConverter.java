package com.ftpix.sss.persistence.utils;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Converter
public class CsvToListConverter implements AttributeConverter<List<String>, String> {

    private static final String DELIMITER = ",";

    @Override
    public String convertToDatabaseColumn(List<String> list) {
        return (list != null && !list.isEmpty()) ? String.join(DELIMITER, list) : null;
    }

    @Override
    public List<String> convertToEntityAttribute(String dbValue) {
        if (dbValue == null || dbValue.trim().isEmpty()) return new ArrayList<>();
        return new ArrayList<>(Arrays.asList(dbValue.split(DELIMITER))).stream().filter(s -> !s.isBlank()).toList();
    }
}
