import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/state/add_recurring_expense.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';

import 'recurring_expense_dialog/step1.dart';
import 'recurring_expense_dialog/step2.dart';
import 'recurring_expense_dialog/step3.dart';

class AddRecurringExpenseDialog extends StatelessWidget {
  final Function refreshRecurringExpenses;

  const AddRecurringExpenseDialog({super.key, required this.refreshRecurringExpenses});

  Future<void> forward(BuildContext context) async {
    final cubit = context.read<AddRecurringExpenseCubit>();

    if (cubit.state.step == 2) {
      // add expense
      await cubit.addRecurringExpense();
      if (context.mounted) {
        Navigator.of(context).pop();
        refreshRecurringExpenses();
      }
    } else {
      cubit.setStep(cubit.state.step + 1);
    }
  }

  Widget getStepWidget(BuildContext context) {
    final cubit = context.read<AddRecurringExpenseCubit>();
    final state = cubit.state;
    switch (state.step) {
      case 0:
        return Step1(
          selected: state.category,
          setCategory: cubit.setCategory,
          setName: cubit.setName,
          name: state.name,
        );
      case 1:
        return Step2(
          type: state.type,
          typeParam: state.typeParam,
          setType: cubit.setType,
          setTypeParam: cubit.setTypeParam,
        );
      case 2:
        return Step3(amount: state.amount, setAmount: cubit.setAmount);
      default:
        return const SizedBox.shrink();
    }
  }

  void backward(BuildContext context) {
    final cubit = context.read<AddRecurringExpenseCubit>();

    if (cubit.state.step == 0) {
      Navigator.of(context).pop();
    } else {
      cubit.setStep(cubit.state.step - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => AddRecurringExpenseCubit(const AddRecurringExpenseState()),
      child: BlocBuilder<AddRecurringExpenseCubit, AddRecurringExpenseState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Switcher(
                  labels: const ['What ?', 'How often ?', 'How much ?'],
                  selected: state.step,
                  onSelect: (step) {},
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: panelTransition,
                      child: Padding(padding: const EdgeInsets.all(8.0), child: getStepWidget(context)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => backward(context),
                      child: Text(state.step == 0 ? 'Cancel' : 'Back', style: TextStyle(color: colors.secondary)),
                    ),
                    TextButton(
                      onPressed: state.stepValid ? () => forward(context) : null,
                      child: Text(state.step == 2 ? 'Add' : 'Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
