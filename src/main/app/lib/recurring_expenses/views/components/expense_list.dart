import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/add_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/expense.dart';
import 'package:spend_spent_spent/utils/extensions/list_insert_between.dart';
import 'package:spend_spent_spent/utils/views/components/expense_separator.dart';

class ExpenseList extends StatelessWidget {
  final List<RecurringExpense> expenses,
      daily = [],
      weekly = [],
      monthly = [],
      yearly = [];
  final Function() refreshExpenses;

  ExpenseList(
      {super.key, required this.expenses, required this.refreshExpenses}) {
    splitExpenses(expenses);
  }

  void splitExpenses(List<RecurringExpense> expenses) {
    for (var e in expenses) {
      switch (e.type) {
        case 0:
          daily.add(e);
          continue;
        case 1:
          weekly.add(e);
          continue;
        case 2:
          monthly.add(e);
          continue;
        case 3:
          yearly.add(e);
          continue;
      }
    }
/*
    print(
        ' total: ${expenses.length} daily: ${daily.length}, weekly: ${weekly.length}, monthly: ${monthly.length}, yearly: ${yearly.length}');
*/
  }

  Widget? expensesFromSplit(
      BuildContext context, List<RecurringExpense> expenses, String title) {
    List<Widget> results = [];

    if (expenses.isNotEmpty) {
      double total = expenses
          .map((e) => e.amount)
          .reduce((value, element) => value + element);

      results.add(ExpenseSeparator(texts: [title, formatCurrency(total)]));

      List<Widget> expensesWidget = [];
      for (var e in expenses) {
        expensesWidget.add(Expense(
          key: Key(e.id.toString()),
          expense: e,
          refreshExpenses: refreshExpenses,
        ));
      }

      results.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: expensesWidget),
      ));
      return Column(children: results);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    var daily = expensesFromSplit(context, this.daily, 'Daily');
    if (daily != null) {
      children.add(daily);
    }
    var weekly = expensesFromSplit(context, this.weekly, 'Weekly');
    if (weekly != null) {
      children.add(weekly);
    }
    var monthly = expensesFromSplit(context, this.monthly, 'Monthly');
    if (monthly != null) {
      children.add(monthly);
    }

    var yearly = expensesFromSplit(context, this.yearly, 'Yearly');
    if (yearly != null) {
      children.add(yearly);
    }

    children.add(AddExpense(
      refreshExpenses: refreshExpenses,
    ));

    children.addItemBetween(Gap(24));

    children.add(Gap(bottomPadding));

    return ListView(
      children: children,
    );
  }
}
