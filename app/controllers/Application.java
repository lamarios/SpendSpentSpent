package controllers;

import models.Setting;
import play.*;
import play.mvc.*;
import views.html.*;

public class Application extends Controller {

    public Result index() {
    	String apiKey = "";
    	
    	Setting googleMapApi = Setting.find.byId(Setting.GOOGLE_MAP);
    	
    	if(googleMapApi != null){
    		apiKey = googleMapApi.getValue();
    	}
        return ok(index.render(apiKey));
    }

}
