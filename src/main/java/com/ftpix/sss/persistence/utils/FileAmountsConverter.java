package com.ftpix.sss.persistence.utils;

import jakarta.persistence.AttributeConverter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FileAmountsConverter implements AttributeConverter<List<Double>, String> {
    private final static Logger log = LogManager.getLogger();

    private static final String DELIMITER = ",";

    @Override
    public String convertToDatabaseColumn(List<Double> list) {
        return (list != null && !list.isEmpty()) ? String.join(DELIMITER, list.stream().map(d -> Double.toString(d)).toList()) : null;
    }

    @Override
    public List<Double> convertToEntityAttribute(String dbValue) {
        if (dbValue == null || dbValue.trim().isEmpty()) return new ArrayList<>();
        return new ArrayList<>(Arrays.asList(dbValue.split(DELIMITER))).stream().filter(s -> !s.isBlank()).map(s -> {
            try {
                return Double.parseDouble(s);
            } catch (NumberFormatException e) {
                log.info("Couldn't parse double {}", s);
                return null;
            }
        }).toList();
    }
}
