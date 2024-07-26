import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/components/dummies/dummyExpenses.dart';
import 'package:spend_spent_spent/components/recurringExpenses/expenseList.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';

class RecurringExpenseList extends StatefulWidget {
  const RecurringExpenseList({super.key});

  @override
  RecurringExpenseListState createState() => RecurringExpenseListState();
}

class RecurringExpenseListState extends State<RecurringExpenseList>
    with AfterLayoutMixin<RecurringExpenseList> {
  List<RecurringExpense>? expenses;
  Widget expensesWidget = DummyExpenses();

  getRecurringExpenses() {
    service.getRecurringExpenses().then((value) {
      print(value);
      if (this.mounted) {
        setState(() {
          this.expenses = value;
          expensesWidget = ExpenseList(
            expenses: expenses ?? [],
            refreshExpenses: getRecurringExpenses,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
                child: AnimatedSwitcher(
                    duration: panelTransition, child: expensesWidget))),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getRecurringExpenses();
  }
}
