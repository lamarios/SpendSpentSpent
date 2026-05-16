package com.ftpix.sss.persistence.utils;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class BooleanToIntConverter implements AttributeConverter<Boolean, Integer> {

    @Override
    public Integer convertToDatabaseColumn(Boolean value) {
        return value != null && value ? 1 : 0;
    }

    @Override
    public Boolean convertToEntityAttribute(Integer value) {
        return value != null && value == 1;
    }
}
