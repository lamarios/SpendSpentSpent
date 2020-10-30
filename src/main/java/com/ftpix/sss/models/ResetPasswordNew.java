package com.ftpix.sss.models;

import java.util.UUID;

public class ResetPasswordNew {
    private UUID resetId;
    private String newPassword;

    public UUID getResetId() {
        return resetId;
    }

    public void setResetId(UUID resetId) {
        this.resetId = resetId;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}
