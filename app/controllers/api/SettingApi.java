package controllers.api;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import notifications.Notifications;
import models.Setting;
import models.UserSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import play.Logger;
import play.Play;
import play.mvc.Controller;
import play.mvc.Result;

public class SettingApi extends Controller {
	private final Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
	private final String FIELD_VALUE = "value";

	public Result getAll() {
		Logger.info("SettingApi.getAll()");
			return ok(gson.toJson(Setting.find.findMap())).as("application/json");
	}

	public Result update(String name) {
		Logger.info("SettingApi.update({})", name);
		Map<String, String[]> params = request().body().asFormUrlEncoded();

		Setting setting = Setting.find.byId(name);

		if (setting == null) {
			setting = new Setting();
			setting.setName(name);
		}

		String value = params.get(FIELD_VALUE)[0].trim();

		switch (setting.getName()) {
		case Setting.PASSWORD:
			try {
				if (!value.equalsIgnoreCase("")) {
					setting.setValue(hashString(value));
					Logger.info("Clearing all sessions");
					UserSession.find.all().forEach((session) ->{
						session.delete();
					});
				} else {
					return ok(gson.toJson(true));
				}
			} catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
				return internalServerError();
			}
			break;
		default:
			setting.setValue(value);
		}

		setting.save();

		return ok(gson.toJson(true));
	}

	public static String hashString(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		MessageDigest md5;
		md5 = MessageDigest.getInstance("MD5");
		str += Play.application().configuration().getString("play.crypto.secret");

		md5.update(str.getBytes());

		byte[] byteData = md5.digest();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < byteData.length; i++) {
			sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
		}

		return sb.toString();
	}
}
