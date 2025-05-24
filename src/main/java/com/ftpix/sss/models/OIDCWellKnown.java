package com.ftpix.sss.models;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class OIDCWellKnown {
    @SerializedName("authorization_endpoint")
    private String authorizationEndpoint;
    @SerializedName("jwks_uri")
    private String jwksUri;
    private String issuer;
    @SerializedName("id_token_signing_alg_values_supported")
    private List<String> supportedAlgorithm;
    @SerializedName("userinfo_endpoint")
    private String userInfoUrl;


    @SerializedName("token_endpoint")
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
}
