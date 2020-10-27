package com.ftpix.sss.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletResponse;

@ControllerAdvice
public class ExceptionController {
    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<String> exception(Exception exception, HttpServletResponse response) {
        response.addHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE);
        return new ResponseEntity<>(exception.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
