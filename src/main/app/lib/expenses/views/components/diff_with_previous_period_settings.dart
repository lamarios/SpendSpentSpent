import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/state/diff_with_previous_month_settings.dart';
import 'package:spend_spent_spent/expenses/views/components/diff_wiht_previous_period_graph.dart';

final DateFormat _df = DateFormat("yyyy-MM");
final DateFormat _df2 = DateFormat.yMMMd();

class DiffWithPreviousPeriodSettings extends StatelessWidget {
  final String month;

  const DiffWithPreviousPeriodSettings({super.key, required this.month});

  bool _isSamePeriod(DateTime period1, DateTime period2) {
    return period1.year == period2.year && period1.month == period2.month;
  }

  static Future<void> showModalSheet(
    BuildContext context, {
    required String month,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          SafeArea(
            bottom: true,
            child: DiffWithPreviousPeriodSettings(month: month),
          ),
        ],
      ),
    );
  }

  DateTimeRange _getCurrentPeriod() {
    final now = DateTime.now();
    final currentPeriod = _df.parse(month);

    var start = DateTime(
      currentPeriod.year,
      currentPeriod.month,
      currentPeriod.day,
    );
    if (_isSamePeriod(currentPeriod, now)) {
      return DateTimeRange(start: start, end: now);
    } else {
      return DateTimeRange(
        start: start,
        end: start.copyWith(month: start.month + 1, day: 0),
      );
    }
  }

  DateTimeRange _getPreviousPeriod(DateTimeRange currentPeriod) {
    final now = DateTime.now();
    final start = _getPreviousMonth(currentPeriod.start).copyWith(day: 1);
    if (_isSamePeriod(currentPeriod.start, now)) {
      return DateTimeRange(
        start: start,
        end: start.copyWith(day: currentPeriod.end.day),
      );
    } else {
      return DateTimeRange(
        start: start,
        end: start.copyWith(month: start.month + 1, day: 0),
      );
    }
  }

  DateTime _getPreviousMonth(DateTime date) {
    int year = date.year;
    int month = date.month - 1;

    // Handle going from January to December of the previous year
    if (month == 0) {
      month = 12;
      year--;
    }

    // Clamp the day to avoid invalid dates (e.g., 31st in February)
    int day = date.day;
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => DiffWithPreviousMonthSettingsCubit(
        DiffWithPreviousMonthSettingsState(),
      ),
      child: BlocBuilder<DiffWithPreviousMonthSettingsCubit,
          DiffWithPreviousMonthSettingsState>(
        builder: (context, state) {
          final currentPeriod = _getCurrentPeriod();
          final previousPeriod = _getPreviousPeriod(currentPeriod);

          var cubit = context.read<DiffWithPreviousMonthSettingsCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            child: Column(
              children: [
                Text(
                  'This shows the difference between  ${_df2.format(currentPeriod.start)} to ${_df2.format(currentPeriod.end)} and ${_df2.format(previousPeriod.start)} to ${_df2.format(previousPeriod.end)}',
                  style: textTheme.labelMedium,
                ),
                Gap(16),
                SwitchListTile(
                  value: state.includeRecurringExpenses,
                  title: Text('Include recurring expenses in comparison'),
                  onChanged: (value) =>
                      cubit.setIncludeRecurringExpenses(value),
                ),
                Gap(16),
                DiffWithPreviousPeriodGraph(
                  key: ValueKey(state.includeRecurringExpenses),
                  currentPeriod: currentPeriod,
                  previousPeriod: previousPeriod,
                  includeRecurring: state.includeRecurringExpenses,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
