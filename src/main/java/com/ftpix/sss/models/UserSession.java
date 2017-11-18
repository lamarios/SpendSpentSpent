package com.ftpix.sss.models;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

@DatabaseTable(tableName = "USER_SESSION")
public class UserSession {
    @DatabaseField(columnName = "TOKEN", id = true)
    private String token;

    @DatabaseField(columnName = "EXPIRY_DATE", dataType = DataType.DATE_STRING, format = "yyyy-MM-dd")
    private Date expiryDate;


    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }


}
