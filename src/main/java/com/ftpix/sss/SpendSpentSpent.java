package com.ftpix.sss;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sss.controllers.BackgroundJob;
import com.ftpix.sss.utils.JsonIgnoreStrategy;
import com.google.gson.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import spark.HaltException;
import spark.Spark;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SpendSpentSpent {
    public final static Gson GSON;
    public static Logger logger = LogManager.getLogger();

    static {
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

        GSON = builder
                .setExclusionStrategies(new JsonIgnoreStrategy())
                .create();
    }

    public SpendSpentSpent() throws IOException {
        Spark.port(Constants.HTTP_PORT);

        if (Constants.DEV_MODE) {
            logger.info("DEV MODE");
            Path resources = Paths.get(".").toAbsolutePath().resolve("src/main/resources/web/public");
            Spark.externalStaticFileLocation(resources.toString().replace("./", ""));

        } else {
            Spark.staticFiles.location("/web/public");
        }

        Spark.exception(Exception.class, (e, req, res) -> {
            if (e instanceof InvocationTargetException) {
                InvocationTargetException target = (InvocationTargetException) e;
                if (target.getTargetException() instanceof HaltException) {
                    HaltException halt = (HaltException) target.getTargetException();
                    res.body(halt.body());
                    res.status(halt.statusCode());
                } else {
                    e.printStackTrace();
                }
            } else {
                e.printStackTrace();
            }
        });

        Sparknotation.init(GSON::fromJson);


    }

    public static void main(String[] args) throws SQLException, IOException {

        Constants.DEV_MODE = args.length > 0 && args[0].equalsIgnoreCase("dev");

        new SpendSpentSpent();

        new BackgroundJob();
    }
}
