import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/views/components/below_date_widget.dart';
import 'package:spend_spent_spent/expenses/views/components/diff_with_previous_period.dart';
import 'package:spend_spent_spent/expenses/views/components/expense_menu.dart';
import 'package:spend_spent_spent/expenses/views/components/one_day.dart';
import 'package:spend_spent_spent/expenses/views/components/search.dart';
import 'package:spend_spent_spent/expenses/views/components/stylized_amount.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/utils/views/components/data_change_monitor.dart';
import 'package:spend_spent_spent/utils/views/components/month_picker.dart';

@RoutePage()
class RightColumnTab extends StatelessWidget {
  const RightColumnTab({super.key});

  String convertDate(String date) {
    return monthFormatter.format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  Widget getExpensesWidget(
    BuildContext context,
    Map<String, DayExpense> expenses,
  ) {
    List<String> expensesKeys = expenses.keys.toList();
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == expenses.length - 1 ? bottomPadding : 0,
          ),
          child: OneDay(
            showExpense: (expense) async {
              await ExpenseMenu.showSheet(context, expense);
            },
            expense: expenses[expensesKeys[index]]!,
          ),
        );
      },
    );
  }

  Future<void> selectMonth(BuildContext context) async {
    var state = context.read<ExpenseListCubit>().state;
    final months = state.months;
    if (months.isEmpty) {
      return;
    }
    var firstMonthSplit = months.first.split('-');
    var lastMonthSplit = months.last.split('-');
    late final DateTime initialDate;
    if (state.selected.isEmpty) {
      initialDate = DateTime.now();
    } else {
      final selectedSplit = state.selected.split('-');
      initialDate = DateTime(
        int.parse(selectedSplit[0]),
        int.parse(selectedSplit[1]),
      );
    }
    var firstDate = DateTime(
      int.parse(firstMonthSplit[0]),
      int.parse(firstMonthSplit[1]),
    );
    var lastDate = DateTime(
      int.parse(lastMonthSplit[0]),
      int.parse(lastMonthSplit[1]),
    );

    final selected = await MonthPicker.show(
      context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate,
      monthPredicate: (date) => months.contains(dateToSSSMonth(date)),
      belowDateWidget: (date) => BelowDateInCalendarWidget(month: date),
    );

    /*
    final selected = await showMonthPicker(
      context: context,
      lastDate: lastDate,
      firstDate: firstDate,
      initialDate: initialDate,
      selectableMonthPredicate: (date) => months.contains(dateToSSSMonth(date)),
    );
*/

    if (selected != null && context.mounted) {
      context.read<ExpenseListCubit>().monthChanged(dateToSSSMonth(selected));
    }
  }

  String dateToSSSMonth(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => ExpenseListCubit(const ExpenseListState()),
      child: DataChangeMonitor(
        onChange: (context) => context.read<ExpenseListCubit>().getMonths(),
        child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
          builder: (context, state) {
            final cubit = context.read<ExpenseListCubit>();

            return state.months.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: 100),
                          Gap(24),
                          Text(
                            'No expenses yet. Go back to the middle screen.',
                            textAlign: TextAlign.center,
                            style: textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleMotionBuilder(
                              value: state.searchMode ? 8 : 50,
                              motion:
                                  MaterialSpringMotion.expressiveSpatialDefault(),
                              builder:
                                  (
                                    BuildContext context,
                                    double value,
                                    Widget? child,
                                  ) => Container(width: value),
                            ),
                            Gap(4),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: panelTransition,
                                child: state.searchMode
                                    ? Search(search: cubit.search)
                                    : state.loading
                                    ? SizedBox.shrink()
                                    : Center(
                                        child: FilledButton.tonalIcon(
                                          onPressed: () => selectMonth(context),
                                          icon: Icon(Icons.calendar_month),
                                          label: Text(
                                            convertDate(state.selected),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Gap(4),
                            SizedBox(
                              width: 50,
                              child: Center(
                                child: IconButton.filledTonal(
                                  onPressed: cubit.switchSearch,
                                  icon: Icon(
                                    state.searchMode
                                        ? Icons.clear
                                        : Icons.search,
                                  ),
                                ),
                              ),
                            ),
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
                                StylizedAmount(amount: state.total, size: 50),
                                if (!state.searchMode) ...[
                                  Gap(4),
                                  DiffWithPreviousPeriod(
                                    diff: state.diffWithPreviousPeriod,
                                    currentMonth: state.selected,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: panelTransition,
                            child: state.loading
                                ? Center(child: LoadingIndicator())
                                : getExpensesWidget(context, state.expenses),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
