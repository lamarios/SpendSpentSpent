import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/recurring_expenses/views/components/expense_list.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/state/recurring_expenses.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

import '../../../utils/views/components/dummies/dummyExpenses.dart';

@RoutePage()
class RecurringExpenseListTab extends StatelessWidget {
  const RecurringExpenseListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecurringExpensesCubit(const RecurringExpensesState()),
      child: ErrorHandler<RecurringExpensesCubit, RecurringExpensesState>(
        child: BlocBuilder<RecurringExpensesCubit, RecurringExpensesState>(
            builder: (context, state) {
          final cubit = context.read<RecurringExpensesCubit>();

          return Column(
            children: [
              Expanded(
                  child: AnimatedSwitcher(
                      duration: panelTransition,
                      child: state.loading
                          ? const DummyExpenses()
                          : ExpenseList(
                              expenses: state.expenses,
                              refreshExpenses: cubit.getRecurringExpenses,
                            ))),
            ],
          );
        }),
      ),
    );
  }
}
