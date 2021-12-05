package com.ftpix.sss.listeners;

import com.ftpix.sss.models.User;

public interface DaoListener<T> {
    void afterInsert(User user, T newRecord);

    void afterDelete(User user, T deleted);
}
