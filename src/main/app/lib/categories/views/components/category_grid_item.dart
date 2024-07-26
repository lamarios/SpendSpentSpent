import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/addExpense.dart';

const double START_BORDER = 30;

class CategoryGridItem extends StatelessWidget {
  final Category category;

  const CategoryGridItem({super.key, required this.category});

  showDialog(BuildContext context) {
    showModal(
        context: context,
        builder: (context) => Card(
            color: Colors.white.withOpacity(0),
            margin: EdgeInsets.zero,
            child: AddExpense(category: category)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => showDialog(context),
      child: AnimatedContainer(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: defaultBorder, color: colors.primaryContainer),
        duration: panelTransition,
        curve: Curves.easeInOutQuart,
        child: Hero(
            tag: category.icon!,
            child: getIcon(category.icon!,
                size: 40, color: colors.onPrimaryContainer)),
      ),
    );
  }
}
