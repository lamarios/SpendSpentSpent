package com.ftpix.sss;


import com.ftpix.sss.models.User;
import com.ftpix.sss.utils.JsonIgnoreStrategy;
import com.ftpix.sss.utils.UserSerializer;
import com.google.gson.*;
import freemarker.template.TemplateExceptionHandler;
import org.simplejavamail.api.mailer.Mailer;
import org.simplejavamail.api.mailer.config.TransportStrategy;
import org.simplejavamail.mailer.MailerBuilder;
import org.simplejavamail.mailer.internal.MailerRegularBuilderImpl;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.lang.reflect.Type;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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


    @Bean
    public Mailer mailer() {
        MailerRegularBuilderImpl mailer;
        if (smtpHost == null || smtpPort == 0 || smtpHost.trim().length() == 0) {
            return null;
        }

        if (smtpUsername != null && smtpUsername.length() > 0) {
            if (smtpPassword == null || smtpPassword.trim().length() == 0) {
                mailer = MailerBuilder.withSMTPServer(smtpHost, smtpPort, smtpUsername);
            } else {
                mailer = MailerBuilder.withSMTPServer(smtpHost, smtpPort, smtpUsername, smtpPassword);
            }
        } else {
            mailer = MailerBuilder.withSMTPServer(smtpHost, smtpPort);
        }

        mailer = mailer.withTransportStrategy(transportStrategy);

        return mailer.clearEmailAddressCriteria() // turns off email validation
//                .withDebugLogging(true)
                .async()
                // not enough? what about this:
                .buildMailer();
    }

    @Bean
    public Gson gson() {
        GsonBuilder builder = new GsonBuilder();
        builder.registerTypeAdapter(Date.class, new JsonDeserializer<Date>() {
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

            @Override
            public Date deserialize(final JsonElement json, final Type typeOfT, final JsonDeserializationContext context)
                    throws JsonParseException {
                try {
                    return df.parse(json.getAsString());
                } catch (ParseException e) {
                    return null;
                }
            }
        });

        builder.registerTypeAdapter(User.class, new UserSerializer());

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

}
