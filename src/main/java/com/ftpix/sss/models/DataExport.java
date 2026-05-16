package com.ftpix.sss.models;

import java.util.List;

public class DataExport {
    private List<Settings> settings;
    private List<User> users;

    public List<Settings> getSettings() {
        return settings;
    }

    public void setSettings(List<Settings> settings) {
        this.settings = settings;
    }

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }
}
