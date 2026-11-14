package com.ftpix.sss.utils;

import com.ftpix.sss.services.EmailService;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import java.io.IOException;
import java.io.StringWriter;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;
import org.springframework.beans.factory.annotation.Autowired;

public class MockEmailService implements EmailService {

  private final Queue<TemplatedEmailData> emails = new LinkedList<>();

  private final Configuration templateEngine;

  private Runnable onSend;

  @Autowired
  public MockEmailService(Configuration templateEngine) {
    this.templateEngine = templateEngine;
  }

  @Override
  public void sendHtml(String to, String subject, String message) {}

  @Override
  public boolean isEnabled() {
    return true;
  }

  @Override
  public void sendTemplate(String to, String subject, String template, Map<String, Object> data)
      throws IOException, TemplateException {
    if (onSend != null) {
      onSend.run();
    }
    String rootUrl = "http://test.com";
    data.put("footerUrl", rootUrl);
    final String s = processTemplate(template, data);
    emails.add(new TemplatedEmailData(to, subject, template, data, s));
  }

  @Override
  public String processTemplate(String templateName, Map<String, Object> data)
      throws IOException, TemplateException {
    try (StringWriter templateStr = new StringWriter()) {
      final Template template = templateEngine.getTemplate(templateName);
      template.process(data, templateStr);

      return templateStr.toString();
    }
  }

  /**
   * @param onSend runs whenever a templated email is sent, null to remove it
   */
  public void setOnSend(Runnable onSend) {
    this.onSend = onSend;
  }

  public Queue<TemplatedEmailData> getEmails() {
    return emails;
  }
}
