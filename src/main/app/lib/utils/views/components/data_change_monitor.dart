import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';

class DataChangeMonitor extends StatelessWidget {
  final Widget child;
  final Function(BuildContext context) onChange;
  final bool monitorExpenses;
  final bool monitorCategories;

  const DataChangeMonitor({
    super.key,
    required this.child,
    required this.onChange,
    this.monitorCategories = true,
    this.monitorExpenses = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        if (monitorExpenses)
          BlocListener<CategoriesCubit, CategoriesState>(listener: (context, state) => onChange(context)),
        if (monitorCategories) BlocListener<LastExpenseCubit, int>(listener: (context, state) => onChange(context)),
      ],
      child: child,
    );
  }
}
