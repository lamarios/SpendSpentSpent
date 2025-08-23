import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/recurring_expense_view.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

class Expense extends StatelessWidget {
  final RecurringExpense expense;
  final Function() refreshExpenses;

  const Expense({
    super.key,
    required this.expense,
    required this.refreshExpenses,
  });

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
        margin: getInsetsForMaxSize(
          MediaQuery.of(context),
          maxWidth: 550,
          maxHeight: 950,
        ),
        child: RecurringExpenseView(expense, refreshExpenses: refreshExpenses),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => openContainer(context),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: getIcon(
                expense.category.icon!,
                size: 20,
                color: colors.onPrimaryContainer,
              ),
            ),
          ),
          Gap(16),
          Expanded(
            child: Visibility(
              visible: expense.name.trim().isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 2,
                children: [
                  Text(expense.name.trim()),
                  Text(
                    'Next: ${expense.nextOccurrence ?? ''}',
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            formatCurrency(expense.amount),
            style: TextStyle(color: colors.onSurface),
          ),
        ],
      ),
    );
  }
}
