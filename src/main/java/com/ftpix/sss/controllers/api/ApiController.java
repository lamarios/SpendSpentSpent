package com.ftpix.sss.controllers.api;


import com.ftpix.sparknnotation.annotations.SparkAfter;
import com.ftpix.sparknnotation.annotations.SparkBefore;
import com.ftpix.sparknnotation.annotations.SparkController;
import com.ftpix.sss.Constants;
import spark.Request;
import spark.Response;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@SparkController
public class ApiController {
    private final Logger logger = LogManager.getLogger();

    @SparkAfter("/API/*")
    public void after(Request req, Response res){
        res.header("Content-type", Constants.JSON);
    }

    @SparkBefore("/*")
    public void before(Request req, Response res){
        logger.info("{} - {}", req.requestMethod(), req.url());

    }
}
