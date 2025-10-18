package com.ftpix.sss.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class OIDCConfig {
    @JsonProperty("authorization_endpoint")
    private String authorizationEndpoint;
    @JsonProperty("jwks_uri")
    private String jwksUri;
    private String issuer;
    @JsonProperty("id_token_signing_alg_values_supported")
    private List<String> supportedAlgorithm;
    @JsonProperty("userinfo_endpoint")
    private String userInfoUrl;
    private String discoveryUrl;
    private String clientId;
    private String emailClaim;
    private String name;


    @JsonProperty("token_endpoint")
    private String tokenUrl;


    public String getAuthorizationEndpoint() {
        return authorizationEndpoint;
    }

    public void setAuthorizationEndpoint(String authorizationEndpoint) {
        this.authorizationEndpoint = authorizationEndpoint;
    }

    public String getJwksUri() {
        return jwksUri;
    }

    public void setJwksUri(String jwksUri) {
        this.jwksUri = jwksUri;
    }

    public String getIssuer() {
        return issuer;
    }

    public void setIssuer(String issuer) {
        this.issuer = issuer;
    }

    public String getTokenUrl() {
        return tokenUrl;
    }

    public void setTokenUrl(String tokenUrl) {
        this.tokenUrl = tokenUrl;
    }

    public List<String> getSupportedAlgorithm() {
        return supportedAlgorithm;
    }

    public void setSupportedAlgorithm(List<String> supportedAlgorithm) {
        this.supportedAlgorithm = supportedAlgorithm;
    }

    public String getUserInfoUrl() {
        return userInfoUrl;
    }

    public void setUserInfoUrl(String userInfoUrl) {
        this.userInfoUrl = userInfoUrl;
    }

    public String getDiscoveryUrl() {
        return discoveryUrl;
    }

    public void setDiscoveryUrl(String discoveryUrl) {
        this.discoveryUrl = discoveryUrl;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getEmailClaim() {
        return emailClaim;
    }

    public void setEmailClaim(String emailClaim) {
        this.emailClaim = emailClaim;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
