package com.ftpix.sss.models;

import com.ftpix.sss.services.Encryption;

public class Settings {
    public static final String CURRENCY_API_KEY = "currencyApiKey", ALLOW_SIGNUP = "allowSignUp", DEMO_MODE = "demoMode", MOTD = "motd";

    private String name;

    private String value;

    private boolean secret;

    public Settings(String name, String value) {
        this.name = name;
        this.value = value;
    }

    public Settings() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRealValue() {
        if (secret) {
            return Encryption.decrypt(value);
        } else {
            return value;
        }
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public boolean isSecret() {
        return secret;
    }

    public void setSecret(boolean secret) {
        this.secret = secret;
    }
}
