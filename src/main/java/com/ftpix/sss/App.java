package com.ftpix.sss;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.r2dbc.R2dbcAutoConfiguration;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(exclude = { R2dbcAutoConfiguration.class })
@EnableScheduling
@Import({Config.class, DbConfig.class})
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }


}
