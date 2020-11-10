package com.ftpix.sss.controllers;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletResponse;

@ControllerAdvice
public class ExceptionController {
    protected final Log logger = LogFactory.getLog(this.getClass());
    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<String> exception(Exception exception, HttpServletResponse response) {
        logger.error("Error while processing request", exception);
        response.addHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE);
        return new ResponseEntity<>(exception.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
