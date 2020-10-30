package com.ftpix.sss;


import com.ftpix.sss.models.User;
import com.ftpix.sss.utils.JsonIgnoreStrategy;
import com.ftpix.sss.utils.UserSerializer;
import com.google.gson.*;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.lang.reflect.Type;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@SpringBootApplication
@EnableScheduling
@Import({Config.class, DbConfig.class})
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }


}
