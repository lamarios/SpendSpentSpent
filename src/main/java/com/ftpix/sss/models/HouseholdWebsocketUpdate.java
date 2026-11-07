package com.ftpix.sss.models;

public class HouseholdWebsocketUpdate {

    // no data, all instances are the same message
    @Override
    public boolean equals(Object o) {
        return o != null && o.getClass() == getClass();
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
