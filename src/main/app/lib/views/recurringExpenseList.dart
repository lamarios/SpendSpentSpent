import 'package:after_layout/after_layout.dart';
import 'package:app/components/recurringExpenses/expenseList.dart';
import 'package:app/globals.dart';
import 'package:app/models/recurringExpense.dart';
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
      setState(() {
        this.expenses = value;
      });
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
