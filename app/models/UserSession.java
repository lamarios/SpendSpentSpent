package models;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;

import com.avaje.ebean.Model;
import com.google.gson.annotations.Expose;

@Entity
public class UserSession extends Model{
	@Id
	@Expose
	private String token;
	
	@Expose
	private Date expiryDate;

	public static final Finder<String, UserSession> find = new Finder<>(UserSession.class);
	
	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	
}
