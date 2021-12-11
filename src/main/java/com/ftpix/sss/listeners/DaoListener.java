package com.ftpix.sss.listeners;

import com.ftpix.sss.models.User;

public interface DaoListener<T> {
    void afterInsert(T newRecord);

    void afterDelete(T deleted);
}
