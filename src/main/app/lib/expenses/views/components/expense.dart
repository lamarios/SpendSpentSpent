import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';

const double MAP_HEIGHT = 200;
const double NOTE_HEIGHT = 30;

class OneExpense extends StatelessWidget {
  final Expense expense;
  final Function(Expense expense) showExpense;

  const OneExpense({
    super.key,
    required this.showExpense,
    required this.expense,
  });

  openContainer() {
    showExpense(expense);
  }

  bool hasNote() {
    return (expense.note?.length ?? 0) > 0;
  }

  bool hasLocation() {
    return expense.longitude != 0 && expense.latitude != 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: openContainer,
      child: Row(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 2,
            children: [
              Visibility(
                visible: hasNote(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(expense.note ?? ''),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: hasLocation(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.near_me,
                        color: colors.onSurface.withValues(alpha: 0.5),
                        size: 15,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: expense.type == 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.refresh,
                        color: colors.onSurface.withValues(alpha: 0.5),
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formatCurrency(expense.amount),
              style: TextStyle(color: colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
