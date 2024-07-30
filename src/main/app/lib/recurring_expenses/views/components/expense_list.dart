import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/add_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/expense.dart';
import 'package:spend_spent_spent/utils/extensions/list_insert_between.dart';

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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List<Widget> results = [];

    if (expenses.isNotEmpty) {
      double total = expenses
          .map((e) => e.amount)
          .reduce((value, element) => value + element);

      results.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          title,
        ),
        const Gap(5),
        const Icon(
          Icons.arrow_forward,
          size: 15,
        ),
        const Gap(5),
        Text(
          formatCurrency(total),
          style: textTheme.bodyLarge?.copyWith(color: colors.primary),
        )
      ]));

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
        child: Wrap(
            runSpacing: 10,
            spacing: 10,
            alignment: WrapAlignment.center,
            children: expensesWidget),
      ));
      return Column(children: results);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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

    children.addItemBetween(Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Container(
        height: 1,
        width: 50,
        color: colors.primaryContainer,
      ),
    ));

    return ListView(
      children: children,
    );
  }
}
