package com.ftpix.sss.models;

import java.util.List;

public record SearchParameters(List<Category> categories, int minAmount, int maxAmount, Long minDate, Long maxDate, String searchQuery){}
