import 'package:spend_spent_spent/components/rightColumn/oneDay.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/dayExpense.dart';
import 'package:flutter/cupertino.dart';

class ExpenseList extends StatefulWidget {
  String selectedMonth;

  ExpenseList({required this.selectedMonth});

  ExpenseListState createState() => ExpenseListState();
}

class ExpenseListState extends State<ExpenseList> {
  Map<String, DayExpense> expenses = {};

  @override
  void didUpdateWidget(covariant ExpenseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth) {
      getExpenses();
    }
  }

  getExpenses() async {
    var expenses = await service.getMonthExpenses(widget.selectedMonth);
    setState(() {
      this.expenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(child: Column(
          children: expenses.values.map((e) => OneDay(expense: e)).toList(),
        ),)
      ],
    );
  }
}
