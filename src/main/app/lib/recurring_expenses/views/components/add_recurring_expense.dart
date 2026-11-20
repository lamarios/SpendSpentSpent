import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/recurring_expenses/state/add_recurring_expense.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';

import 'recurring_expense_dialog/step1.dart';
import 'recurring_expense_dialog/step2.dart';
import 'recurring_expense_dialog/step3.dart';

/// Shows the dialog to add a recurring expense, or to edit the given one.
void showRecurringExpenseDialog(BuildContext context, {RecurringExpense? expense, required Function onSaved}) {
  showModal(
    context: context,
    // as tall as its content like the expense dialog, a fixed height cut the keypad off with larger fonts.
    // Full width on narrow screens, the step titles wrap otherwise
    builder: (context) => SafeArea(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Card(
            margin: EdgeInsets.zero,
            child: AddRecurringExpenseDialog(expense: expense, refreshRecurringExpenses: onSaved),
          ),
        ),
      ),
    ),
  );
}

class AddRecurringExpenseDialog extends StatelessWidget {
  final Function refreshRecurringExpenses;

  /// The recurring expense to edit, none to add one.
  final RecurringExpense? expense;

  const AddRecurringExpenseDialog({super.key, required this.refreshRecurringExpenses, this.expense});

  Future<void> forward(BuildContext context) async {
    final cubit = context.read<AddRecurringExpenseCubit>();

    if (cubit.state.step == 2) {
      await cubit.save();
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
          firstOccurrence: state.firstOccurrence,
          lastOccurrence: cubit.lastOccurrence,
          editing: expense != null,
          scheduleEditable: cubit.canEditSchedule,
          setType: cubit.setType,
          setTypeParam: cubit.setTypeParam,
          setFirstOccurrence: cubit.setFirstOccurrence,
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
      create: (context) => expense == null
          ? AddRecurringExpenseCubit(const AddRecurringExpenseState())
          : AddRecurringExpenseCubit(editRecurringExpenseState(expense!), editing: expense),
      child: BlocBuilder<AddRecurringExpenseCubit, AddRecurringExpenseState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switcher(
                  labels: const ['What ?', 'How often ?', 'How much ?'],
                  selected: state.step,
                  onSelect: (step) {},
                ),
                Flexible(
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
                      child: Text(state.step < 2 ? 'Next' : (expense == null ? 'Add' : 'Save')),
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
