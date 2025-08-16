package com.ftpix.sss;


import com.ftpix.sss.models.Settings;
import com.ftpix.sss.models.User;
import com.ftpix.sss.utils.*;
import com.google.gson.*;
import freemarker.template.TemplateExceptionHandler;
import org.hazlewood.connor.bottema.emailaddress.EmailAddressCriteria;
import org.simplejavamail.api.mailer.Mailer;
import org.simplejavamail.api.mailer.config.TransportStrategy;
import org.simplejavamail.mailer.MailerBuilder;
import org.simplejavamail.mailer.internal.MailerRegularBuilderImpl;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.info.BuildProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.*;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.json.Json;
import springfox.documentation.spring.web.plugins.Docket;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Configuration
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

        mailer = mailer.clearEmailAddressCriteria()
                .async()
                .withEmailAddressCriteria(EmailAddressCriteria.RFC_COMPLIANT);
        return mailer.buildMailer();
    }

    @Bean
    public Gson gson() {
        GsonBuilder builder = new GsonBuilder();
        builder.serializeSpecialFloatingPointValues();
        builder.registerTypeAdapter(LocalDate.class, new LocalDateGsonAdapter());

        builder.registerTypeAdapter(User.class, new UserSerializer());
        builder.registerTypeAdapter(Settings.class, new SettingsDeserializer());
        builder.registerTypeAdapter(Settings.class, new SettingsSerializer());
        builder.registerTypeAdapter(Json.class, new SpringfoxJsonToGsonAdapter());

        return builder
                .setExclusionStrategies(new JsonIgnoreStrategy())
                .create();
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
    public Docket api(BuildProperties buildProperties) {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.ant("/API/**").or(PathSelectors.ant("/Login")))
                .build()
                .apiInfo(getApiInfo(buildProperties))
                .securitySchemes(Arrays.asList(apiKey()))
                .securityContexts(Arrays.asList(securityContext()));

    }

    private ApiInfo getApiInfo(BuildProperties buildProperties) {
        return new ApiInfo(
                buildProperties.getName(),
                "Easy to use expense tracker",
                buildProperties.getVersion(),
                "",
                new Contact("Paul fauchon", "https://lamarios.github.io/SpendSpentSpent/", "EMAIL"),
                "GNU Affero General Public License v3.0",
                "https://raw.githubusercontent.com/lamarios/SpendSpentSpent/master/LICENSE",
                Collections.emptyList()
        );
    }

    private ApiKey apiKey() {
        return new ApiKey("apiKey", "Authorization", "header");
    }

    private SecurityContext securityContext() {
        return SecurityContext.builder().securityReferences(defaultAuth())
                .forPaths(PathSelectors.ant("/API/**")).build();
    }

    private List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope(
                "global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return Arrays.asList(new SecurityReference("apiKey",
                authorizationScopes));
    }
}
