package com.ftpix.sss.notifications;

import java.util.Map;

public  interface Notification {
     void sendNotification(String title, String content) throws Exception;
     boolean setSettings(Map<String, String> settings);
}
