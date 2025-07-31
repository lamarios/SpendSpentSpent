import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/views/components/diff_with_previous_period.dart';
import 'package:spend_spent_spent/expenses/views/components/expense_menu.dart';
import 'package:spend_spent_spent/expenses/views/components/one_day.dart';
import 'package:spend_spent_spent/expenses/views/components/search.dart';
import 'package:spend_spent_spent/expenses/views/components/stylized_amount.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/utils/views/components/data_change_monitor.dart';

import '../../../utils/views/components/dummies/dummyExpenses.dart';

@RoutePage()
class RightColumnTab extends StatelessWidget {
  const RightColumnTab({super.key});

  String convertDate(String date) {
    return DateFormat('MMMM yyyy')
        .format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  Widget getExpensesWidget(
      BuildContext context, Map<String, DayExpense> expenses) {
    List<String> expensesKeys = expenses.keys.toList();
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: index == expenses.length - 1 ? bottomPadding : 0),
          child: OneDay(
              showExpense: (expense) => ExpenseMenu.showSheet(context, expense),
              expense: expenses[expensesKeys[index]]!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => ExpenseListCubit(const ExpenseListState()),
      child: DataChangeMonitor(
        onChange: (context) => context.read<ExpenseListCubit>().getMonths(),
        child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
            builder: (context, state) {
          final cubit = context.read<ExpenseListCubit>();

          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2),
                      child: AnimatedCrossFade(
                        sizeCurve: Curves.easeInOutQuad,
                        crossFadeState: state.searchMode
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: panelTransition,
                        firstChild: Search(
                          search: cubit.search,
                        ),
                        secondChild: SizedBox(
                          height: 48,
                          child: Column(
                            children: [
                              DropdownButton<String>(
                                value: state.selected,
                                items: state.months
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            convertDate(e),
                                            style: TextStyle(
                                                color: colors
                                                    .onSecondaryContainer),
                                          ),
                                        ))
                                    .toList(),
                                selectedItemBuilder: (context) => state.months
                                    .map(
                                      (e) => Center(
                                          child: Text(
                                        convertDate(e),
                                        style: textTheme.bodyLarge,
                                      )),
                                    )
                                    .toList(),
                                style:
                                    TextStyle(color: colors.onPrimaryContainer),
                                isExpanded: true,
                                iconEnabledColor: colors.onPrimaryContainer,
                                underline: const SizedBox.shrink(),
                                dropdownColor: colors.secondaryContainer,
                                onChanged: cubit.monthChanged,
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 50,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8.0, top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.secondaryContainer),
                          child: IconButton(
                              onPressed: cubit.switchSearch,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              iconSize: 15,
                              splashRadius: 15,
                              icon: Icon(
                                  state.searchMode ? Icons.clear : Icons.search,
                                  color: colors.onPrimaryContainer)),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  key: ValueKey(state.selected),
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StylizedAmount(
                          amount: state.total,
                          size: 50,
                        ),
                        if (!state.searchMode) ...[
                          Gap(4),
                          DiffWithPreviousPeriod(
                              diff: state.diffWithPreviousPeriod)
                        ]
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                      duration: panelTransition,
                      child: state.loading
                          ? const DummyExpenses()
                          : getExpensesWidget(context, state.expenses)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
