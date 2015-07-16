package models;

import javax.persistence.Entity;
import javax.persistence.Id;

import play.Logger;

import com.avaje.ebean.Model;
import com.google.gson.annotations.Expose;

@Entity
public class Setting extends Model {
	public static final String PASSWORD = "password", USERNAME = "username", PUSHBULLET="pushbullet", PUSHBULLET_API="pushbulletapi", AUTHENTICATION="authentication", PUSHALOT="pushalot", PUSHALOTAPI="pushalotApi", WINDOWS_TILE = "windowsTile", PUSHOVER="pushover", PUSHOVER_APP_TOKEN="pushoverAppToken", PUSHOVER_USER_TOKEN="pushoverUserToken";
	@Id
	@Expose
	private String name;
	
	@Expose
	private String value;

	public static final Finder<String, Setting> find = new Finder<>(Setting.class);
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	public static String get(String key) {
		Logger.info("Getting setting for key[{}]", key);
		Setting setting = find.byId(key);
		if (setting != null) {
			Logger.info("Value: [{}]", setting.getValue());
			return setting.getValue();
		} else {
			return "";
		}
	}
}
