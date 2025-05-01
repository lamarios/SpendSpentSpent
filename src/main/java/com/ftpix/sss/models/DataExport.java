package com.ftpix.sss.models;

import java.util.List;

public class DataExport {
 private List<Category> categories;
 private List<Expense> expenses;
 private List<MonthlyHistory> monthlyHistories;
 private List<RecurringExpense> recurringExpenses;
 private List<Settings> settings;
 private List<User> users;
 private List<YearlyHistory> yearlyHistories;

 public List<Category> getCategories() {
  return categories;
 }

 public void setCategories(List<Category> categories) {
  this.categories = categories;
 }

 public List<Expense> getExpenses() {
  return expenses;
 }

 public void setExpenses(List<Expense> expenses) {
  this.expenses = expenses;
 }

 public List<MonthlyHistory> getMonthlyHistories() {
  return monthlyHistories;
 }

 public void setMonthlyHistories(List<MonthlyHistory> monthlyHistories) {
  this.monthlyHistories = monthlyHistories;
 }

 public List<RecurringExpense> getRecurringExpenses() {
  return recurringExpenses;
 }

 public void setRecurringExpenses(List<RecurringExpense> recurringExpenses) {
  this.recurringExpenses = recurringExpenses;
 }

 public List<Settings> getSettings() {
  return settings;
 }

 public void setSettings(List<Settings> settings) {
  this.settings = settings;
 }

 public List<User> getUsers() {
  return users;
 }

 public void setUsers(List<User> users) {
  this.users = users;
 }

 public List<YearlyHistory> getYearlyHistories() {
  return yearlyHistories;
 }

 public void setYearlyHistories(List<YearlyHistory> yearlyHistories) {
  this.yearlyHistories = yearlyHistories;
 }
}
