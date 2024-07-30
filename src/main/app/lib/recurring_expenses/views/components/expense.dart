import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_view.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class Expense extends StatelessWidget {
  final RecurringExpense expense;
  final Function() refreshExpenses;

  const Expense(
      {super.key, required this.expense, required this.refreshExpenses});

  getType(int type) {
    switch (type) {
      case 0:
        return 'Daily';
      case 1:
        return 'Weekly';
      case 2:
        return 'Monthly';
      case 3:
        return 'Yearly';
    }
  }

  openContainer(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showModal(
        context: context,
        builder: (context) => Card(
            color: colors.surface,
            margin: getInsetsForMaxSize(MediaQuery.of(context),
                maxWidth: 550, maxHeight: 950),
            child: RecurringExpenseView(
              expense,
              refreshExpenses: refreshExpenses,
            )));
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => openContainer(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: colors.primaryContainer),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: colors.primary),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        getIcon(expense.category.icon!,
                            size: 20, color: colors.onPrimary),
                        Visibility(
                          visible: expense.name.trim().isNotEmpty,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              expense.name.trim(),
                              style: TextStyle(color: colors.onPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    formatCurrency(expense.amount),
                    style: TextStyle(color: colors.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
