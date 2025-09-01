package com.ftpix.sss.models;

import java.util.List;

public record SearchParameters(List<Category> categories, int minAmount, int maxAmount, java.time.LocalDate minDate, java.time.LocalDate maxDate, String searchQuery){}
