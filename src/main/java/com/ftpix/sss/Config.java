package com.ftpix.sss;


import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.StreamReadFeature;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.ftpix.sss.mcp.MCPTools;
import com.ftpix.sss.models.Settings;
import com.ftpix.sss.utils.LocalDateDeserializer;
import com.ftpix.sss.utils.LocalDateSerializer;
import com.ftpix.sss.utils.SettingsDeserializer;
import com.ftpix.sss.utils.SettingsSerializer;
import freemarker.template.TemplateExceptionHandler;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.simplejavamail.api.mailer.Mailer;
import org.simplejavamail.api.mailer.config.TransportStrategy;
import org.simplejavamail.mailer.MailerBuilder;
import org.simplejavamail.mailer.internal.MailerRegularBuilderImpl;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;

@Configuration
@SecurityScheme(
        name = "bearerAuth",
        description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
        scheme = "bearer",
        type = SecuritySchemeType.HTTP,
        bearerFormat = "JWT",
        in = SecuritySchemeIn.HEADER
)
public class Config {

    @Value("${SMTP_USERNAME:}")
    private String smtpUsername;
    @Value("${SMTP_PASSWORD:}")
    private String smtpPassword;
    @Value("${SMTP_HOST:}")
    private String smtpHost;
    @Value("${SMTP_PORT:0}")
    private int smtpPort;
    @Value("${SMTP_TRANSPORT_STRATEGY:SMTP}")
    private TransportStrategy transportStrategy;

    @Value("${ROOT_URL:http://localhost:8080}")
    private String rootUrl;

    @Bean
    public String rootUrl() {
        return rootUrl;
    }


    @Bean
    @ConditionalOnMissingBean(ZoneId.class)
    public ZoneId zoneId(@Value("${TIMEZONE}") String timeZone) {
        return ZoneId.of(timeZone);
    }

    @Bean
    public Mailer mailer() {
        MailerRegularBuilderImpl mailer;
        if (smtpHost == null || smtpPort == 0 || smtpHost.trim().isEmpty()) {
            return null;
        }

        if (smtpUsername != null && !smtpUsername.isEmpty()) {
            if (smtpPassword == null || smtpPassword.trim().isEmpty()) {
                mailer = MailerBuilder.withSMTPServer(smtpHost, smtpPort, smtpUsername);
            } else {
                mailer = MailerBuilder.withSMTPServer(smtpHost, smtpPort, smtpUsername, smtpPassword);
            }
        } else {
            mailer = MailerBuilder.withSMTPServer(smtpHost, smtpPort);
        }


        mailer = mailer.withTransportStrategy(transportStrategy);

        return mailer.buildMailer();
    }

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**") // apply to all endpoints
                        .allowedOriginPatterns("*") // frontend URLs
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(true);
            }
        };
    }

    @Bean
    public freemarker.template.Configuration templateEngine() throws IOException {
        // Create your Configuration instance, and specify if up to what FreeMarker
        // version (here 2.3.29) do you want to apply the fixes that are not 100%
        // backward-compatible. See the Configuration JavaDoc for details.
        freemarker.template.Configuration cfg = new freemarker.template.Configuration(freemarker.template.Configuration.VERSION_2_3_29);

        // Specify the source where the template files come from. Here I set a
        // plain directory for it, but non-file-system sources are possible too:
        cfg.setClassForTemplateLoading(this.getClass(), "/templates/");

        // From here we will set the settings recommended for new projects. These
        // aren't the defaults for backward compatibilty.

        // Set the preferred charset template files are stored in. UTF-8 is
        // a good choice in most applications:
        cfg.setDefaultEncoding("UTF-8");

        // Sets how errors will appear.
        // During web page *development* TemplateExceptionHandler.HTML_DEBUG_HANDLER is better.
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

        // Don't log exceptions inside FreeMarker that it will thrown at you anyway:
        cfg.setLogTemplateExceptions(false);

        // Wrap unchecked exceptions thrown during template processing into TemplateException-s:
        cfg.setWrapUncheckedExceptions(true);

        // Do not fall back to higher scopes when reading a null loop variable:
        cfg.setFallbackOnNullLoopVariable(false);

        return cfg;
    }


    @Bean
    ToolCallbackProvider mcpToolCallbackProvider(MCPTools mcpTools) {
        return MethodToolCallbackProvider.builder().toolObjects(mcpTools)
                .build();
    }

    @Bean
    public ObjectMapper objectMapper() {

        JsonFactory factory = JsonFactory.builder()
                .enable(StreamReadFeature.INCLUDE_SOURCE_IN_LOCATION).build();

        ObjectMapper mapper = new ObjectMapper(factory);
        SimpleModule module = new SimpleModule();
        module.addSerializer(Settings.class, new SettingsSerializer());
        module.addDeserializer(Settings.class, new SettingsDeserializer());
        module.addSerializer(LocalDate.class, new LocalDateSerializer());
        module.addDeserializer(LocalDate.class, new LocalDateDeserializer());
        mapper.disable(DeserializationFeature.FAIL_ON_IGNORED_PROPERTIES, DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        mapper.registerModule(module);

        return mapper;
    }

}
