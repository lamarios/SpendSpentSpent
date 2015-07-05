package notifications;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import models.Setting;
import notifications.implementations.PushBullet;
import notifications.implementations.Pushalot;

public class Notifications {
	
	public static void send(String title, String body){
		send(title, body, false);
	}
	
	public static void send(String title, String body, boolean test){
		
		title = "SpendSpentSpent: "+title;
		
		if(test || Setting.get(Setting.PUSHBULLET).equalsIgnoreCase("true")){
			PushBullet pb = new PushBullet();
			Map<String, String> settings = new HashMap<String, String>();
			settings.put(PushBullet.API_KEY, Setting.get(Setting.PUSHBULLET_API));
			System.out.println(settings.get(PushBullet.API_KEY));
			if(pb.setSettings(settings)){
				try {
					pb.sendNotification(title, body);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		if(test || Setting.get(Setting.PUSHALOT).equalsIgnoreCase("true")){
			Pushalot pb = new Pushalot();
			Map<String, String> settings = new HashMap<String, String>();
			settings.put(Pushalot.API_KEY, Setting.get(Setting.PUSHALOTAPI));
			System.out.println(settings.get(Pushalot.API_KEY));
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
