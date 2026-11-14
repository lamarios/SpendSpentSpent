package com.ftpix.sss.filters;

import com.ftpix.sss.controllers.ApplicationController;
import com.ftpix.sss.utils.Version;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
@WebFilter("/*")
public class VersionFilter extends OncePerRequestFilter {

  public static final String VERSION_HEADER = "x-version";

  /**
   * Apps older than 2.14.0 send an integer build number and expect an integer back. If they get
   * anything else they assume the backend is too old. We send them a high integer instead so they
   * accept it and act on the 426 status, telling the user to update the app.
   */
  private static final String LEGACY_CLIENT_BACKEND_VERSION = "9999";

  protected final Log logger = LogFactory.getLog(this.getClass());
  private final BuildProperties buildProperties;

  @Autowired
  public VersionFilter(BuildProperties buildProperties) {
    this.buildProperties = buildProperties;
  }

  @Override
  protected void doFilterInternal(
      HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {

    String backendVersion = buildProperties.getVersion();

    // if the front end send us a version, we check for compatibility
    String clientVersionStr = request.getHeader(VERSION_HEADER);
    if (clientVersionStr != null) {
      Optional<Version> clientVersion = Version.parse(clientVersionStr);
      if (clientVersion.isEmpty()) {
        logger.info(
            "Client version ["
                + clientVersionStr
                + "] isn't an x.y.z version, assuming out of date");
        response.setStatus(426);
        backendVersion = LEGACY_CLIENT_BACKEND_VERSION;
      } else if (!clientVersion.get().isAtLeast(ApplicationController.MIN_APP_VERSION)) {
        logger.info(
            "Client version ["
                + clientVersionStr
                + "] is too old, required: "
                + ApplicationController.MIN_APP_VERSION);
        response.setStatus(426);
      }
    }

    // we tell the front end our version
    response.setHeader(VERSION_HEADER, backendVersion);
    filterChain.doFilter(request, response);
  }
}
