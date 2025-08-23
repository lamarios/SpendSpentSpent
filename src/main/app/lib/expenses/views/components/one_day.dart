import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/views/components/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/utils/views/components/expense_separator.dart';

class OneDay extends StatelessWidget {
  final DayExpense expense;
  final Function(Expense expense) showExpense;
  final double total = 0;

  const OneDay({super.key, required this.expense, required this.showExpense});

  displayDate() {
    return DateFormat.yMMMMd(
      'en_US',
    ).format(DateFormat('yyyy-MM-dd').parse(expense.date));
  }

  @override
  Widget build(BuildContext context) {
    double total = expense.expenses
        .map((e) => e.amount)
        .reduce((value, element) => value + element);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          ExpenseSeparator(texts: [displayDate(), formatCurrency(total)]),
          const Gap(10),
          Column(
            spacing: 10,
            children: expense.expenses
                .map(
                  (e) => OneExpense(
                    key: Key(e.id.toString()),
                    expense: e,
                    showExpense: showExpense,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
