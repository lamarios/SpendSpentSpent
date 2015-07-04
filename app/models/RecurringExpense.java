package models;

import java.util.Calendar;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;

import com.avaje.ebean.Model;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;

@Entity
public class RecurringExpense extends Model {

	public static final int TYPE_DAILY = 0, TYPE_WEEKLY = 1, TYPE_MONTHLY = 2, TYPE_YEARLY = 3;

	public static final Finder<Long, RecurringExpense> find = new Finder<>(RecurringExpense.class);

	@Id
	@Expose
	@SequenceGenerator(name = "gen", sequenceName = "recurring_sequence", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "gen")
	private long id;

	@Expose
	private String name;

	@OneToOne
	@JoinColumn(name = "category_id")
	@Expose
	private Category category;

	@Expose
	private int type;

	@Expose
	private int typeParam;
	@Expose
	private Date lastOccurrence, nextOccurrence;
	@Expose
	private double amount;

	@Expose
	private boolean income = false;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getTypeParam() {
		return typeParam;
	}

	public void setTypeParam(int typeParam) {
		this.typeParam = typeParam;
	}

	public Date getLastOccurrence() {
		return lastOccurrence;
	}

	public void setLastOccurrence(Date lastOccurrence) {
		this.lastOccurrence = lastOccurrence;
	}

	public Date getNextOccurrence() {
		return nextOccurrence;
	}

	public void setNextOccurrence(Date nextOccurrence) {
		this.nextOccurrence = nextOccurrence;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public boolean isIncome() {
		return income;
	}

	public void setIncome(boolean income) {
		this.income = income;
	}

}
