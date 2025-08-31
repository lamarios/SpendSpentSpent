import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/add_expense_dialog.dart';
import 'package:spend_spent_spent/add_expense_dialog/state/guess_category.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/add_expense.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/utils/views/components/expense_image.dart';

class GuessCategoryDialog extends StatelessWidget {
  final SharedMediaFile file;

  const GuessCategoryDialog({super.key, required this.file});

  static Future<void> show(
    BuildContext context, {
    required SharedMediaFile file,
  }) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(children: [GuessCategoryDialog(file: file)]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => GuessCategoryCubit(GuessCategoryState(), file),

      child: BlocBuilder<GuessCategoryCubit, GuessCategoryState>(
        builder: (context, state) {
          if (state.loading) {
            return SizedBox(
              height: 300,
              child: Column(
                spacing: 24,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: LoadingIndicator()),
                  Text('Getting info...'),
                ],
              ),
            );
          }

          final cubit = context.read<GuessCategoryCubit>();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Center(
                  child: ExpenseImage(
                    file: state.results!.file,
                    width: 300,
                    height: 300,
                    showStatus: false,
                  ),
                ),
                if ((state.results?.file.aiTags ?? []).isNotEmpty) ...[
                  Gap(20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Icon(Icons.local_offer, color: colors.secondary),
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: (state.results?.file.aiTags ?? [])
                              .map((e) => Text(e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
                if ((state.results?.file.amounts ?? []).isNotEmpty) ...[
                  Gap(20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Icon(Icons.attach_money, color: colors.secondary),
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: (state.results?.file.amounts ?? [])
                              .map((e) => Text(formatCurrency(e)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
                Gap(20),
                Text('Select category'),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: (state.results?.categories ?? [])
                        .map(
                          (e) => GestureDetector(
                            onTap: () => cubit.setSelected(e),
                            child: AnimatedContainer(
                              key: ValueKey(e),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: state.selected == e
                                    ? colors.primaryContainer
                                    : Colors.transparent,
                              ),
                              duration: animationDuration,
                              curve: animationCurve,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Center(
                                child: getIcon(
                                  e,
                                  size: 30,
                                  color: state.selected == e
                                      ? colors.onPrimaryContainer
                                      : colors.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: state.selected == null
                      ? null
                      : () {
                          final cat = context
                              .read<CategoriesCubit>()
                              .findByName(state.selected!);

                          if (cat == null) {
                            return;
                          }

                          // we build an expense based on what we have
                          var results = state.results;
                          if (results == null) {
                            return;
                          }
                          final expense = Expense(
                            amount: results.file.amounts.firstOrNull ?? 0,
                            date: DateFormat(
                              expenseDateFormat,
                            ).format(DateTime.now()),
                            category: cat,
                            files: [results.file],
                            note: results.file.aiTags.firstOrNull,
                          );

                          Navigator.of(context).pop();
                          AddExpense.showDialog(context, expense: expense);
                        },
                  label: Text('Add expense'),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
