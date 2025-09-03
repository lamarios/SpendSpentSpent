import 'package:flutter/material.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';

const double START_BORDER = 30;

class CategoryGridItem extends StatelessWidget {
  final Category category;

  const CategoryGridItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => AddExpense.showDialog(context, category: category),
      child: AnimatedContainer(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: defaultBorder,
          color: colors.primaryContainer,
        ),
        duration: panelTransition,
        curve: Curves.easeInOutQuart,
        child: getIcon(
          category.icon!,
          size: 40,
          color: colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
