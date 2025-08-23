import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/globals.dart';

part 'diff_with_previous_month_graph.freezed.dart';

final DateFormat _df = DateFormat("yyyy-MM");
final DateFormat _df2 = DateFormat("yyyy-MM-dd");

final _log = Logger('DiffWithPreviousMonthGraphCubit');

class DiffWithPreviousMonthGraphCubit
    extends Cubit<DiffWithPreviousMonthGraphState> {
  DiffWithPreviousMonthGraphCubit(super.initialState) {
    getChartData();
  }

  Future<void> getChartData() async {
    emit(state.copyWith(loading: true));
    final currentPeriodFuture = getPeriodData(state.currentPeriod);
    final previousPeriodFuture = getPeriodData(state.previousPeriod);

    if (!isClosed) {
      emit(
        state.copyWith(
          spots: [await currentPeriodFuture, await previousPeriodFuture],
          loading: false,
        ),
      );
    }
  }

  Future<List<FlSpot>> getPeriodData(DateTimeRange period) async {
    var expenses = await service.getMonthExpenses(_df.format(period.start));

    List<FlSpot> result = [];

    int currentDay = 0;
    double currentAmount = 0;
    while (currentDay < period.end.day) {
      var date = period.start.copyWith(day: period.start.day + currentDay);
      var format = _df2.format(date);
      final dayExpenses = expenses[format];

      var dayTotal = (dayExpenses?.expenses ?? [])
          .where((e) => state.includeRecurring ? true : e.type == 1)
          .fold<double>(
            0,
            (previousValue, element) => previousValue + element.amount,
          );
      currentAmount += dayTotal;

      result.add(FlSpot(date.day.toDouble(), currentAmount));

      _log.fine(
        'Total expense for date: ${format}: $dayTotal, accumulated: $currentAmount, include recurring ? ${state.includeRecurring}',
      );

      currentDay++;
    }

    return result;
  }
}

@freezed
sealed class DiffWithPreviousMonthGraphState
    with _$DiffWithPreviousMonthGraphState {
  const factory DiffWithPreviousMonthGraphState({
    @Default(true) bool loading,
    required bool includeRecurring,
    required DateTimeRange currentPeriod,
    @Default([]) List<List<FlSpot>> spots,
    required DateTimeRange previousPeriod,
  }) = _DiffWithPreviousMonthGraphState;
}
