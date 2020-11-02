package com.ftpix.sss.models;


/**
 * Provides with the current version of the project and if it is possible to update via autoupdate
 */
public class UpdateInfo {
    private String currentVersion, latestVersion, message;
    private boolean canAutoUpdate = false;


    public String getCurrentVersion() {
        return currentVersion;
    }

    public void setCurrentVersion(String currentVersion) {
        this.currentVersion = currentVersion;
    }

    public String getLatestVersion() {
        return latestVersion;
    }

    public void setLatestVersion(String latestVersion) {
        this.latestVersion = latestVersion;
    }

    public boolean isCanAutoUpdate() {
        return canAutoUpdate;
    }

    public void setCanAutoUpdate(boolean canAutoUpdate) {
        this.canAutoUpdate = canAutoUpdate;
    }


    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
