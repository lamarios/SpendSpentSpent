import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/components/rightColumn/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/dayExpense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class OneDay extends StatelessWidget {
  DayExpense expense;
  Function showExpense;
  double total = 0;

  OneDay({required this.expense, required this.showExpense});

  displayDate() {
    return DateFormat.yMMMMd('en_US').format(DateFormat('yyyy-MM-dd').parse(expense.date));
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    double total = expense.expenses.map((e) => e.amount).reduce((value, element) => value + element);
    List<Widget> widgets = [
      Text(displayDate()),
    ];

    List<Widget> expenses = [];
    expense.expenses.forEach((e) => expenses.add(OneExpense(key: Key(e.id.toString()), expense: e, showExpense: showExpense)));

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(runSpacing: 10, spacing: 10, alignment: WrapAlignment.center, children: expenses),
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total: ',
            style: TextStyle(color: colors.text),
          ),
          Text(
            formatCurrency(total),
            style: TextStyle(color: colors.main),
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
