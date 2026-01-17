package com.ftpix.sss;


import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication()
@EnableScheduling
@Import({Config.class, DbConfig.class})
@OpenAPIDefinition(info = @Info(title = "SpendSpentSpent API", version = "1.0", description = "SpendSpentSpent API"))
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}
