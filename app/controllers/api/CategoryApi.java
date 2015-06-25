package controllers.api;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import models.Category;
import models.CategoryIcons;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class CategoryApi extends Controller {
	public static final String FIELD_COLOR = "color", FIELD_ICON = "icon", FIELD_ORDER = "order";
	private  final Gson gson = new GsonBuilder().setDateFormat("yy-MM-dd").excludeFieldsWithoutExposeAnnotation().create();


	public Result create() {
		Logger.info("CategoryApi.create()");
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		Category category = new Category();
		
		if(!CategoryIcons.ALL.contains(params.get(FIELD_ICON)[0])){
			return internalServerError("Icon doesn't exist");
		}
		
		category.setIcon(params.get(FIELD_ICON)[0]);
		category.setCategoryOrder(Integer.parseInt(params.get(FIELD_ORDER)[0]));
		category.save();

		return ok(gson.toJson(category)).as("application/json");
	}

	public Result get() {
		Logger.info("CategoryApi.get()");
		return ok(gson.toJson(Category.find.all())).as("application/json");
	}

	public Result getId(long id) {
		Logger.info("CategoryApi.get({})", id);
		return ok(gson.toJson(Category.find.byId(id))).as("application/json");
	}
	
	public Result getAvailable(){
		Logger.info("CategoryApi.getAvailable()");
		List<String> icons = new ArrayList<>(CategoryIcons.ALL);
		
		for(Category category: Category.find.all()){
			icons.remove(category.getIcon());
		}
		
		return ok(gson.toJson(icons)).as("application/json");
	}

	public Result delete(long id) {
		Logger.info("CategoryApi.delete({})", id);
		Category.find.deleteById(id);
		return ok(gson.toJson(true)).as("application/json");
	}

	public Result update(long id) {
		Logger.info("CategoryApi.id()");
		Map<String, String[]> params = request().body().asFormUrlEncoded();
		Category category = Category.find.byId(id);
		if (category != null) {
			category.setId(id);
			category.setIcon(params.get(FIELD_ICON)[0]);
			category.setCategoryOrder(Integer.parseInt(params.get(FIELD_ORDER)[0]));
			category.save();
			return ok(gson.toJson(true)).as("application/json");
		} else {
			return ok(gson.toJson(false)).as("application/json");
		}

	}

}
