package com.ftpix.sss.listeners;

public interface DaoListener<T> {
  void afterInsert(T newRecord);

  void afterDelete(T deleted);
}
