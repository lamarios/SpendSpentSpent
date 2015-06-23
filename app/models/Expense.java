package models;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import com.avaje.ebean.Model;
import com.google.gson.annotations.Expose;

@Entity
public class Expense extends Model {

	public static final int TYPE_NORMAL = 1, TYPE_RECURRENT = 2;

	@Transient
	public static final Finder<Long, Expense> find = new Finder<>(Expense.class);

	@Id
	@Expose
	private long id;
	@Expose
	private double amount;

	@OneToOne
	@JoinColumn(name = "category_id")
	@Expose
	private Category category;
	@Expose
	private Date date;
	@Expose
	private int type = 1;
	@Expose
	private boolean income = false;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public boolean isIncome() {
		return income;
	}

	public void setIncome(boolean income) {
		this.income = income;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}
}
