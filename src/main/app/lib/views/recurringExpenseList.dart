import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/components/recurringExpenses/expenseList.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RecurringExpenseList extends StatefulWidget {
  @override
  RecurringExpenseListState createState() => RecurringExpenseListState();
}

class RecurringExpenseListState extends State<RecurringExpenseList> with AfterLayoutMixin<RecurringExpenseList> {
  List<RecurringExpense>? expenses;

  getRecurringExpenses() {
    service.getRecurringExpenses().then((value) {
      print(value);
      if(this.mounted) {
        setState(() {
          this.expenses = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(child: ExpenseList(expenses: expenses ?? [], refreshExpenses: getRecurringExpenses,))),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getRecurringExpenses();
  }
}
