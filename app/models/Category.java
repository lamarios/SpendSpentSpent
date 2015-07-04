package models;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Transient;

import com.avaje.ebean.Model;
import com.google.gson.annotations.Expose;

@Entity
public class Category extends Model {

	@Transient
	public static Finder<Long, Category> find = new Finder<>(Category.class);

	@Id
	@Expose
	@SequenceGenerator(name = "gen", sequenceName = "category_sequence", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "gen")
	private long id;
	@Expose
	private String icon;
	@Expose
	private int categoryOrder;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public int getCategoryOrder() {
		return categoryOrder;
	}

	public void setCategoryOrder(int order) {
		this.categoryOrder = order;
	}

}
