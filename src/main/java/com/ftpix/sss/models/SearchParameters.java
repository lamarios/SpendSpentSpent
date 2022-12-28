package com.ftpix.sss.models;

import java.util.Date;
import java.util.List;

public record SearchParameters(List<Category> categories, int minAmount, int maxAmount, Date minDate, Date maxDate, String note){}
