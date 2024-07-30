import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/views/components/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';

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
    final textTheme = Theme.of(context).textTheme;

    double total = expense.expenses
        .map((e) => e.amount)
        .reduce((value, element) => value + element);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${displayDate()}'),
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
          ],
        ),
        const Gap(10),
        Wrap(
            runSpacing: 10,
            spacing: 10,
            alignment: WrapAlignment.center,
            children: expense.expenses
                .map(
                  (e) => OneExpense(
                      key: Key(e.id.toString()),
                      expense: e,
                      showExpense: showExpense),
                )
                .toList()),
        const Gap(10),
/*
        Row(
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
        )
*/
      ]),
    );
  }
}
