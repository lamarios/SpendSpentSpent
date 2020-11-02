package com.ftpix.sss;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
@Import({Config.class, DbConfig.class})
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }


}
