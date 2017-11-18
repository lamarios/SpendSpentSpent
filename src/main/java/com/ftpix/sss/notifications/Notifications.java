package com.ftpix.sss.notifications;

import com.ftpix.sss.controllers.api.SettingsController;
import com.ftpix.sss.models.Setting;
import com.ftpix.sss.notifications.implementations.PushBullet;
import com.ftpix.sss.notifications.implementations.PushOver;
import com.ftpix.sss.notifications.implementations.Pushalot;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class Notifications {


    public static void send(String title, String body){
        send(title, body, false);
    }

    public static void send(String title, String body, boolean test){

        title = "SpendSpentSpent: "+title;

        if(test || SettingsController.get(Setting.PUSHBULLET).equalsIgnoreCase("true")){
            PushBullet pb = new PushBullet();
            Map<String, String> settings = new HashMap<String, String>();
            settings.put(PushBullet.API_KEY, SettingsController.get(Setting.PUSHBULLET_API));
            if(pb.setSettings(settings)){
                try {
                    pb.sendNotification(title, body);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        if(test || SettingsController.get(Setting.PUSHALOT).equalsIgnoreCase("true")){
            Pushalot pb = new Pushalot();
            Map<String, String> settings = new HashMap<String, String>();
            settings.put(Pushalot.API_KEY, SettingsController.get(Setting.PUSHALOTAPI));
            if(pb.setSettings(settings)){
                try {
                    pb.sendNotification(title, body);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        if(test || SettingsController.get(Setting.PUSHOVER).equalsIgnoreCase("true")){
            PushOver pb = new PushOver();
            Map<String, String> settings = new HashMap<String, String>();
            settings.put(PushOver.APPLICATION_TOKEN, SettingsController.get(Setting.PUSHOVER_APP_TOKEN));
            settings.put(PushOver.USER_TOKEN, SettingsController.get(Setting.PUSHOVER_USER_TOKEN));
            if(pb.setSettings(settings)){
                try {
                    pb.sendNotification(title, body);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
