package com.ftpix.sss.utils;

import java.util.Map;

public record TemplatedEmailData(String email, String title, String template, Map<String, Object> data, String processedTemplate) {

}
