package com.ftpix.sss;

import com.ftpix.sparknnotation.Sparknotation;
import com.ftpix.sss.db.DB;
import com.google.gson.*;
import spark.HaltException;
import spark.Spark;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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

    public static void main(String[] args) throws SQLException {
        System.out.println(DB.EXPENSE_DAO.queryForAll().size());

        Spark.port(Constants.HTTP_PORT);
        Spark.exception(Exception.class, (e, req, res) -> {
            e.printStackTrace();
            if (e instanceof InvocationTargetException) {
                InvocationTargetException target = (InvocationTargetException) e;
                if (target.getTargetException() instanceof HaltException) {
                    HaltException halt = (HaltException) target.getTargetException();
                    res.body(halt.body());
                    res.status(halt.statusCode());
                }
            }
        });

        Sparknotation.init(GSON::fromJson);
    }
}
