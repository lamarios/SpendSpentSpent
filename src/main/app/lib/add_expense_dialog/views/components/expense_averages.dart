import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/expenses/views/components/stylized_amount.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/settings/state/app_settings.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class RecurringExpenseAverages extends StatelessWidget {
  final List<RecurringExpense> expenses;

  const RecurringExpenseAverages({super.key, required this.expenses});

  int _daysInYear() {
    int year = DateTime.now().year;
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return end.difference(start).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final openedBackgroundColor = getLightBackground(context);

    int daysInsYear = _daysInYear();

    double yearly = expenses.fold(0, (total, exp) {
      switch (exp.type) {
        case 0:
          // daily
          total += exp.amount * daysInsYear;
          break;
        case 1:
          // weekly
          total += exp.amount * 52;
          break;
        case 2:
          // monthly
          total += exp.amount * 12;
          break;
        case 3:
          // yearly
          total += exp.amount;
          break;
      }
      return total;
    });

    double monthly = yearly / 12;
    double weekly = yearly / 52;
    double daily = yearly / daysInsYear;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 0,
        color: openedBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 16),
                  Gap(8),
                  Text(
                    'Recurring cost breakdown',
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
              Gap(16),
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(label: 'Per Day', amount: daily),
                  ),
                  Gap(16),
                  Expanded(
                    child: _InfoTile(label: 'Per Month', amount: monthly),
                  ),
                ],
              ),
              Gap(16),
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(label: 'Per Week', amount: weekly),
                  ),
                  Gap(16),
                  Expanded(
                    child: _InfoTile(label: 'Per Year', amount: yearly),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final double amount;

  const _InfoTile({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelSmall),
          Gap(4),
          StylizedAmount(amount: amount, size: 32),
        ],
      ),
    );
  }
}
