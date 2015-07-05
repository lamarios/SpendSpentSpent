package notifications;

import java.util.Map;

public interface Notification {
	public void sendNotification(String title, String content) throws Exception;
	public boolean setSettings(Map<String, String> settings);
}
