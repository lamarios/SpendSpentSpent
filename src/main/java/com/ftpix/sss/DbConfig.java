package com.ftpix.sss;


import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.flywaydb.core.Flyway;
import org.jooq.SQLDialect;
import org.jooq.impl.DSL;
import org.jooq.impl.DefaultDSLContext;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;

import javax.sql.DataSource;

@Configuration
public class DbConfig {
    protected final Log logger = LogFactory.getLog(this.getClass());
    @Value("${spring.datasource.url}")
    private String dbPath;
    @Value("${spring.datasource.username}")
    private String dbUsername;
    @Value("${spring.datasource.password}")
    private String dbPassword;
    @Value("${spring.datasource.driver-class-name}")
    private String driverClass;

    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbPath);
        config.setUsername(dbUsername);
        config.setPassword(dbPassword);
        config.setDriverClassName(driverClass);
        config.setMaximumPoolSize(30);
        config.setMinimumIdle(5);
        config.setIdleTimeout(30000);
        config.setMaxLifetime(1800000);

        return new HikariDataSource(config);
    }

    @Bean(name = "flyway")
    public Flyway flyway(
            DataSource dataSource,
            @Value("${spring.flyway.locations}") String locations,
            @Value("${spring.flyway.baseline-on-migrate:false}") boolean baselineOnMigrate
    ) {
        Flyway flyway = Flyway.configure()
                .dataSource(dataSource)
                .locations(locations)
                .baselineOnMigrate(baselineOnMigrate)
                .load();

        flyway.migrate(); // Force migration to run
        return flyway;
    }

/*
    @Bean
    public String jdbcUrl() {
        if (!dbPath.startsWith("jdbc:")) {
            return "jdbc:h2:" + dbPath;
        } else {
            return dbPath;
        }
    }
*/

    @Bean
    @DependsOn("flyway")
    public DefaultDSLContext dslContext(DataSource dataSource) {
        DefaultDSLContext using = (DefaultDSLContext) DSL.using(dataSource, SQLDialect.POSTGRES);
        using.settings().setRenderSchema(false);
        return using;
    }
}
