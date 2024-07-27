import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/models/expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/expenses/views/components/one_day.dart';
import 'package:spend_spent_spent/expenses/views/components/search.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

import '../../../utils/views/components/dummies/dummyExpenses.dart';
import '../components/expense_view.dart';

@RoutePage()
class RightColumnTab extends StatelessWidget {
  const RightColumnTab({super.key});

  void showExpense(BuildContext context, Expense expense) {
    final colors = Theme.of(context).colorScheme;
    showModal(
        context: context,
        builder: (context) => Card(
            color: colors.surface,
            margin: getInsetsForMaxSize(MediaQuery.of(context),
                maxWidth: 550, maxHeight: 950),
            child: ExpenseView(expense)));
  }

  String convertDate(String date) {
    return DateFormat('MMMM yyyy')
        .format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  Widget getExpensesWidget(Map<String, DayExpense> expenses) {
    List<String> expensesKeys = expenses.keys.toList();
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return OneDay(
            showExpense: (expense) => showExpense(context, expense),
            expense: expenses[expensesKeys[index]]!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => ExpenseListCubit(const ExpenseListState()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LastExpenseCubit, int>(
              listener: (context, state) =>
                  context.read<ExpenseListCubit>().getMonths()),
          BlocListener<CategoriesCubit, CategoriesState>(
              listener: (context, state) =>
                  context.read<ExpenseListCubit>().getMonths())
        ],
        child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
            builder: (context, state) {
          final cubit = context.read<ExpenseListCubit>();

          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                          height: 38,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                color: colors.secondaryContainer),
                            child: DropdownButton<String>(
                              value: state.selected,
                              items: state.months
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          convertDate(e),
                                          style: TextStyle(
                                              color:
                                                  colors.onSecondaryContainer),
                                        ),
                                      ))
                                  .toList(),
                              selectedItemBuilder: (context) => state.months
                                  .map(
                                    (e) => Center(child: Text(convertDate(e))),
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
                          ),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
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
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Total:'),
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                formatCurrency(state.total),
                                style: TextStyle(color: colors.primary),
                              ))),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                      duration: panelTransition,
                      child: state.loading
                          ? const DummyExpenses()
                          : getExpensesWidget(state.expenses)),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
