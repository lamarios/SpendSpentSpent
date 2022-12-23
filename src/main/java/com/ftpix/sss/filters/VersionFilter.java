package com.ftpix.sss.filters;

import com.ftpix.sss.controllers.ApplicationController;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
@WebFilter("/*")
public class VersionFilter extends OncePerRequestFilter {

    public static final String VERSION_HEADER = "x-version";
    protected final Log logger = LogFactory.getLog(this.getClass());
    private final BuildProperties buildProperties;

    @Autowired
    public VersionFilter(BuildProperties buildProperties) {
        this.buildProperties = buildProperties;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        // if the front end send us a version, we check for compatibility
        if (request.getHeader(VERSION_HEADER) != null) {
            try {
                String clientVersionStr = request.getHeader(VERSION_HEADER);
                int clientVersion = Integer.parseInt(clientVersionStr);
                if (clientVersion < ApplicationController.MIN_APP_VERSION) {
                    logger.info("Client version [" + clientVersion + "] is too old, required: " + ApplicationController.MIN_APP_VERSION);
                    response.setStatus(426);
                }
            } catch (Exception e) {
                logger.info("Error parsing client version:[" + request.getHeader(VERSION_HEADER) + "], assuming out of date");
                response.setStatus(426);
            }
        }


        // we tell the front end our version
        response.setHeader(VERSION_HEADER, buildProperties.getVersion());
        filterChain.doFilter(request, response);
    }
}
