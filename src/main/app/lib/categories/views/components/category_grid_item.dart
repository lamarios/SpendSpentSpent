import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

const double START_BORDER = 30;

class CategoryGridItem extends StatelessWidget {
  final Category category;

  const CategoryGridItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final brightness = MediaQuery.platformBrightnessOf(context);
    return SingleMotionBuilder(
      motion: MaterialSpringMotion.expressiveSpatialDefault(),
      value: context.read<CategoriesCubit>().getProbability(category),
      // value: 0,
      builder: (context, value, child) => GestureDetector(
        onTap: () => AddExpense.showDialog(context, category: category),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: defaultBorder,
            color: brightness == Brightness.dark
                ? brighten(
                    colors.primaryContainer,
                    lerpDouble(0, 0.3, value) ?? 0,
                  )
                : darken(
                    colors.primaryContainer,
                    lerpDouble(0, 0.2, value) ?? 0,
                  ),
          ),

          child: Transform.scale(
            scale: lerpDouble(1, 1.5, value),
            child: getIcon(
              category.icon!,
              size: 40,
              color: colors.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
