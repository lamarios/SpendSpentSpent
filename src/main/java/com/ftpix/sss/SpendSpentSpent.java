package com.ftpix.sss;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sss.controllers.BackgroundJob;
import com.ftpix.sss.controllers.api.UpdateController;
import com.ftpix.sss.db.DB;
import com.google.gson.*;
import spark.HaltException;
import spark.Spark;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.stream.Stream;

public class SpendSpentSpent {

    public final static Gson GSON;

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

        GSON = builder.create();
    }

    public static void main(String[] args) throws SQLException, IOException {
        System.out.println("Args:"+args.length);

        Stream.of(args).forEach(System.out::println);

        if(args.length > 4 && args[0].equalsIgnoreCase("update")){
            new UpdateController().deployUpdate(args);
        }else {

            Constants.DEV_MODE = args.length > 0 && args[0].equalsIgnoreCase("dev");

            new SpendSpentSpent();

            new BackgroundJob();
        }
    }

    public SpendSpentSpent() throws IOException {
        Spark.port(Constants.HTTP_PORT);

        if (Constants.DEV_MODE) {
            System.out.println("DEV MODE");
            Spark.externalStaticFileLocation("/home/gz/IdeaProjects/SpendSpentSpent/src/main/resources/web/public");

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
}
