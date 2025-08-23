import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/add_expense_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/expense_note_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/note_suggestion_pill.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/DummyFade.dart';

class ExpenseActions extends StatelessWidget {
  const ExpenseActions({super.key});

  Future<void> selectDate(BuildContext context) async {
    final cubit = context.read<AddExpenseDialogCubit>();

    var expendeDate = cubit.state.expenseDate;
    var date = await showDatePicker(
      context: context,
      initialDate: expendeDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    cubit.setDate(date ?? expendeDate);
  }

  void enableCurrencyConversion(BuildContext context) {
    final cubit = context.read<AddExpenseDialogCubit>();
    cubit.enableCurrencyConversion(!cubit.state.showCurrencyConversion);
  }

  void showNoteDialog(BuildContext context) async {
    final cubit = context.read<AddExpenseDialogCubit>();
    final note = await ExpenseNoteDialog.show(context, cubit.state.expenseNote);
    if (note != null) {
      cubit.setNote(note);
    }
  }

  void tapSuggestion(BuildContext context, String text) {
    final cubit = context.read<AddExpenseDialogCubit>();
    cubit.setNote(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // TODO: implement build
    return BlocBuilder<AddExpenseDialogCubit, AddExpenseDialogState>(
      builder: (context, state) {
        final cubit = context.read<AddExpenseDialogCubit>();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
              child: Row(
                children: [
                  TextButton(
                    // style: flatButtonStyle,
                    onPressed: () => selectDate(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 4,
                      ),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(state.expenseDate),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DummyFade(
                      running: state.gettingLocation,
                      child: IconButton(
                        onPressed: () {
                          cubit.setLocation(!state.useLocation);
                        },
                        icon: Icon(
                          Icons.near_me,
                          color: state.useLocation
                              ? colors.primary
                              : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: state.noteSuggestions.isEmpty
                            ? colors.surfaceContainer
                            : colors.surface,
                      ),
                      duration: Duration(
                        milliseconds: panelTransition.inMilliseconds ~/ 2,
                      ),
                      child: IconButton(
                        onPressed: () => showNoteDialog(context),
                        icon: Icon(
                          Icons.comment_rounded,
                          color: state.expenseNote.isNotEmpty
                              ? colors.primary
                              : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: service.config?.canConvertCurrency ?? false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 0),
                      child: IconButton(
                        onPressed: () => enableCurrencyConversion(context),
                        icon: Icon(
                          Icons.attach_money,
                          color: state.showCurrencyConversion
                              ? colors.primary
                              : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: defaultBorder,
                        color: colors.surface,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          controller: cubit.suggestionController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                [
                                      if (state.expenseNote.isNotEmpty)
                                        state.expenseNote,
                                      ...state.noteSuggestions.where(
                                        (e) => e != state.expenseNote,
                                      ),
                                    ]
                                    .map(
                                      (e) => NoteSuggestionPill(
                                        key: Key(e),
                                        text: e,
                                        current: state.expenseNote == e,
                                        tapSuggestion: (text) =>
                                            tapSuggestion(context, text),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
