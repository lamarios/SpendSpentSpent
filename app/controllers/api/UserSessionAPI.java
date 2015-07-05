package controllers.api;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import models.Setting;
import models.UserSession;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;

public class UserSessionAPI extends Controller{
	private final String FIELD_USERNAME="username", FIELD_PASSWORD="password";
	private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").excludeFieldsWithoutExposeAnnotation().create();

	public Result logIn(){
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		String username = params.get(FIELD_USERNAME)[0].trim();
		String password = params.get(FIELD_PASSWORD)[0].trim();
		
		try {
			if(username.equalsIgnoreCase(Setting.get(Setting.USERNAME)) && SettingApi.hashString(password).equalsIgnoreCase(Setting.get(Setting.PASSWORD))){
				Calendar today = new GregorianCalendar();
				String token = SettingApi.hashString(username+password+today.getTime());
				today.add(Calendar.MONTH, 3);
				
				UserSession session = new UserSession();
				session.setToken(token);
				session.setExpiryDate(today.getTime());
				session.save();
				Logger.info("New Session token[{}] expiryDay [{}]", session.getToken(), session.getExpiryDate());
				return ok(gson.toJson(session)).as("application/json");
			}else{
				return unauthorized();
			}
		} catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
			return internalServerError();
		}
		
	}
}
