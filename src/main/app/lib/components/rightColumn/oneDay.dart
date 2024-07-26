import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/components/rightColumn/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/dayExpense.dart';
import 'package:spend_spent_spent/models/expense.dart';

class OneDay extends StatelessWidget {
  final DayExpense expense;
  final Function(Expense expense) showExpense;
  final double total = 0;

  const OneDay({super.key, required this.expense, required this.showExpense});

  displayDate() {
    return DateFormat.yMMMMd('en_US')
        .format(DateFormat('yyyy-MM-dd').parse(expense.date));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    double total = expense.expenses
        .map((e) => e.amount)
        .reduce((value, element) => value + element);
    List<Widget> widgets = [
      Text(displayDate()),
    ];

    List<Widget> expenses = [];
    for (var e in expense.expenses) {
      expenses.add(OneExpense(
          key: Key(e.id.toString()), expense: e, showExpense: showExpense));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
          runSpacing: 10,
          spacing: 10,
          alignment: WrapAlignment.center,
          children: expenses),
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total: ',
          ),
          Text(
            formatCurrency(total),
            style: TextStyle(color: colors.primary),
          ),
        ],
      ),
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: widgets),
    );
  }
}
