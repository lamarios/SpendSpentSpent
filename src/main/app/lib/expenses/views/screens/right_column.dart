import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/state/expense_list.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/expenses/views/components/below_date_widget.dart';
import 'package:spend_spent_spent/expenses/views/components/diff_with_previous_period.dart';
import 'package:spend_spent_spent/expenses/views/components/expense_menu.dart';
import 'package:spend_spent_spent/expenses/views/components/expenses_map.dart';
import 'package:spend_spent_spent/expenses/views/components/one_day.dart';
import 'package:spend_spent_spent/expenses/views/components/search.dart';
import 'package:spend_spent_spent/expenses/views/components/stylized_amount.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/views/components/data_change_monitor.dart';
import 'package:spend_spent_spent/utils/views/components/month_picker.dart';

@RoutePage()
class RightColumnTab extends StatelessWidget {
  const RightColumnTab({super.key});

  String convertDate(String date) {
    return monthFormatter.format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  Widget getExpensesWidget(BuildContext context, Map<String, DayExpense> expenses) {
    List<String> expensesKeys = expenses.keys.toList();
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == expenses.length - 1 ? bottomPadding : 0),
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
      initialDate = DateTime(int.parse(selectedSplit[0]), int.parse(selectedSplit[1]));
    }
    var firstDate = DateTime(int.parse(firstMonthSplit[0]), int.parse(firstMonthSplit[1]));
    var lastDate = DateTime(int.parse(lastMonthSplit[0]), int.parse(lastMonthSplit[1]));

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

  String dateToSSSMonth(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => ExpenseListCubit(const ExpenseListState()),
      child: DataChangeMonitor(
        onChange: (context) {
          if (context.read<UsernamePasswordCubit>().currentUser != null) {
            context.read<ExpenseListCubit>().getMonths(false);
          }
        },
        child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
          builder: (context, state) {
            final cubit = context.read<ExpenseListCubit>();
            context.select((LastExpenseCubit c) => c.state);

            return !state.loading && state.months.isEmpty
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
                              motion: MaterialSpringMotion.expressiveSpatialDefault(),
                              builder: (BuildContext context, double value, Widget? child) => Container(width: value),
                            ),
                            Gap(4),
                            Expanded(
                              child: SingleMotionBuilder(
                                motion: MaterialSpringMotion.expressiveSpatialDefault(),
                                builder: (context, value, child) => Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: .circular(bigItemBorderRadius),
                                      color: Color.lerp(colors.secondaryContainer, getLightBackground(context), value),
                                    ),

                                    child: SizedBox(
                                      width: lerpDouble(200, TABLET, value),
                                      height: lerpDouble(40, 250, value),
                                      child: child,
                                    ),
                                  ),
                                ),
                                value: state.searchMode ? 1 : 0,
                                from: 0,
                                child: AnimatedSwitcher(
                                  duration: animationDuration,
                                  child: state.searchMode
                                      ? Center(child: Search(search: cubit.search))
                                      : AnimatedSwitcher(
                                          duration: animationDuration,
                                          child: state.loading
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(child: LoadingIndicator()),
                                                )
                                              : InkWell(
                                                  onTap: () => selectMonth(context),
                                                  child: Padding(
                                                    padding: .symmetric(horizontal: 16, vertical: 8),
                                                    child: Row(
                                                      spacing: 8,
                                                      mainAxisAlignment: .center,
                                                      children: [
                                                        Icon(Icons.calendar_month),
                                                        Text(convertDate(state.selected)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ),
                                ),
                              ),
                            ),
                            Gap(4),
                            SizedBox(
                              width: 50,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Center(
                                    child: IconButton.filledTonal(
                                      onPressed: cubit.switchSearch,
                                      icon: Icon(state.searchMode ? Icons.clear : Icons.search),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: animationDuration,

                            child: !state.mapMode
                                ? Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Spacer(flex: 1),
                                          Expanded(
                                            flex: 4,
                                            child: SingleMotionBuilder(
                                              motion: MaterialSpringMotion.expressiveEffectsSlow(),
                                              value: !state.loading ? 1 : 0,
                                              builder: (context, value, child) => Opacity(
                                                opacity: value.clamp(0, 1),
                                                child: Transform.scale(
                                                  scaleY: value,
                                                  alignment: Alignment.bottomCenter,
                                                  child: child,
                                                ),
                                              ),
                                              child: Padding(
                                                key: ValueKey(state.selected),
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      if (!state.loading) StylizedAmount(amount: state.total, size: 50),
                                                      if (!state.searchMode && !state.loading) ...[
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
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: kIsWeb
                                                  ? const EdgeInsets.only(right: 6.0, top: 8)
                                                  : EdgeInsets.zero,
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: IconButton.filledTonal(
                                                  onPressed: () => cubit.toggleMap(),
                                                  icon: Icon(Icons.map_outlined),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                  )
                                : AnimatedSwitcher(
                                    duration: animationDuration,
                                    child: state.loading
                                        ? Center(child: LoadingIndicator())
                                        : ExpensesMap(
                                            key: ValueKey('${state.searchMode}-${state.expenses}'),
                                            expenses: state.expenses,
                                          ),
                                  ),
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
