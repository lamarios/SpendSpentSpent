package com.ftpix.sss.listeners;

import com.ftpix.sss.models.User;

public interface DaoUserListener<T> {
    void afterInsert(User user, T newRecord);

    void afterDelete(User user, T deleted);
}
