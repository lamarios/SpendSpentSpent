package controllers;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import models.Expense;
import models.Setting;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;
import views.html.devices.*;

public class Windows extends Controller {
	private SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	public Result tile() {
		if(Setting.get(Setting.WINDOWS_TILE).equalsIgnoreCase("true")){
			String date = df.format(new Date());
			Logger.info("Getting total expense for today {}", date);
			List<Expense>expenses = Expense.find.where().eq("date", date ).findList();
			
			double total = 0;
			for(Expense expense: expenses){
				total += expense.getAmount();
			}
			
			return ok(windowsTile.render(String.format("%1$,.2f", total)));
		}else{
			return unauthorized("Windows tiles are not allowed");
		}
	}
}
