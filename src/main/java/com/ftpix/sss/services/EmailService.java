package com.ftpix.sss.services;

import freemarker.template.TemplateException;

import java.io.IOException;
import java.util.Map;

public interface EmailService {
    String processTemplate(String templateName, Map<String, Object> data) throws IOException, TemplateException;

    void sendHtml(String to, String subject, String message);

    boolean isEnabled();

    void sendTemplate(String to, String subject, String template, Map<String, Object> data) throws IOException, TemplateException;
}
