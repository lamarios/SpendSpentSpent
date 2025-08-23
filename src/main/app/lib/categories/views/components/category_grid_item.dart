import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';

const double START_BORDER = 30;

class CategoryGridItem extends StatelessWidget {
  final Category category;

  const CategoryGridItem({super.key, required this.category});

  showDialog(BuildContext context) {
    if (foundation.kIsWeb) {
      showModal(
        context: context,
        builder: (context) => Card(
          color: Colors.white.withValues(alpha: 0),
          margin: EdgeInsets.zero,
          child: AddExpense(category: category),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Wrap(
          children: [
            SafeArea(bottom: true, child: AddExpense(category: category)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => showDialog(context),
      child: AnimatedContainer(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: defaultBorder,
          color: colors.primaryContainer,
        ),
        duration: panelTransition,
        curve: Curves.easeInOutQuart,
        child: Hero(
          tag: category.icon!,
          child: getIcon(
            category.icon!,
            size: 40,
            color: colors.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
