package controllers.api;

import java.util.Calendar;
import java.util.Comparator;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import models.Category;
import models.Expense;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;

public class HistoryApi extends Controller {
	private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").excludeFieldsWithoutExposeAnnotation().create();

	public Result yearly(int count) {
		Logger.info("HistoryApi.yearly({})", count);

		Map<String, TreeMap<String, Double>> result = new HashMap<>();

		List<Category> categories = Category.find.all();
		
		TreeMap<String, Double> overall =  new TreeMap<String, Double>();

		
		for(Category category: categories){
			TreeMap<String, Double> tmp =  new TreeMap<String, Double>();
			Calendar cal = new GregorianCalendar();
			for(int i = count; i > 0; i--){
				String year = Integer.toString(cal.get(Calendar.YEAR));
				List<Expense> expenses = Expense.find.where().eq("income", 0).eq("category_id", category.getId()).like("date", year+"%").findList();
				double total = 0;
				for(Expense expense: expenses){
					total += expense.getAmount();
				}
				tmp.put(year, total);
				
				//adding to overall count
				if(!overall.containsKey(year)){
					overall.put(year, 0d);
				}
				overall.put(year, overall.get(year)+total);
				
				cal.add(Calendar.YEAR, -1);
			}
			
			result.put(category.getIcon(), tmp);
		}
		
		result.put("all", overall);

		
		ValueComparator comparator = new ValueComparator(result);
		Map<String, TreeMap<String, Double>> sortedMap = new TreeMap<String, TreeMap<String, Double>>(comparator);
		sortedMap.putAll(result);
		return ok(gson.toJson(sortedMap)).as("application/json");
	}
	
	
	public Result monthly(int count) {
		Logger.info("HistoryApi.monthly({})", count);
		
		Map<String, TreeMap<String, Double>> result = new HashMap<>();

		List<Category> categories = Category.find.all();
		
		TreeMap<String, Double> overall =  new TreeMap<String, Double>();

		
		for(Category category: categories){
			TreeMap<String, Double> tmp =  new TreeMap<String, Double>();
			Calendar cal = new GregorianCalendar();
			for(int i = count; i > 0; i--){
				String date = Integer.toString(cal.get(Calendar.YEAR))+"-"+String.format("%02d",cal.get(Calendar.MONTH)+1);

				List<Expense> expenses = Expense.find.where().eq("income", 0).eq("category_id", category.getId()).like("date", date+"%").findList();
				double total = 0;
				for(Expense expense: expenses){
					total += expense.getAmount();
				}
				tmp.put(date, total);
				
				//adding to overall count
				if(!overall.containsKey(date)){
					overall.put(date, 0d);
				}
				overall.put(date, overall.get(date)+total);
				
				cal.add(Calendar.MONTH, -1);
			}
			
			result.put(category.getIcon(), tmp);
		}
		
		result.put("all", overall);

		
		ValueComparator comparator = new ValueComparator(result);
		Map<String, TreeMap<String, Double>> sortedMap = new TreeMap<String, TreeMap<String, Double>>(comparator);
		sortedMap.putAll(result);
		return ok(gson.toJson(sortedMap)).as("application/json");
	}
	
	
	class ValueComparator implements Comparator<String> {

		Map<String, TreeMap<String, Double>> base;
	    public ValueComparator(Map<String, TreeMap<String, Double>> base) {
	        this.base = base;
	    }

	    // Note: this comparator imposes orderings that are inconsistent with equals.    
	    public int compare(String a, String b) {
	    	//getting last item from each map
	        if (getLast(base.get(a)) >= getLast(base.get(b))) {
	            return -1;
	        } else {
	            return 1;
	        } // returning 0 would merge keys
	    }
	    
	    private double getLast(TreeMap<String, Double> map){
	    	
	    	double last = 0;
	    		
	    	Set<String> keys = map.keySet();
	    	for(String key: keys){
	    		last = map.get(key);
	    	}
	    	
	    	return last;
	    }
	}

}
