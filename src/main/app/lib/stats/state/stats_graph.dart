import 'dart:core';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/stats/views/components/stats_graph.dart';
import 'package:spend_spent_spent/stats/models/graph_data_point.dart';

import '../../globals.dart';

part 'stats_graph.freezed.dart';

class StatsGraphCubit extends Cubit<StatsGraphState> {
  final bool monthly;
  final int categoryId;

  StatsGraphCubit(
    super.initialState, {
    required this.monthly,
    required this.categoryId,
  }) {
    emit(state.copyWith(loading: true));
    getGraphData();
  }

  changeCount(int count) {
    emit(state.copyWith(count: max(count, MIN_PERIOD)));
    EasyDebounce.debounce(
      'get-graph-data-$categoryId',
      const Duration(milliseconds: 500),
      getGraphData,
    );
  }

  Future<void> getLimits() async {
    final expenseLimits = await service.getExpenseLimits();

    final periodMax = max(
      state.periodMax,
      monthly ? expenseLimits.months + 3 : expenseLimits.years + 3,
    );
    emit(state.copyWith(periodMax: periodMax));
  }

  Future<void> getGraphData() async {
    try {
      await getLimits();
      List<GraphDataPoint> data = [];
      if (monthly) {
        data = await service.getMonthlyData(categoryId, state.count);
      } else {
        data = await service.getYearlyData(categoryId, state.count);
      }
      data = data.reversed.toList();

      List<FlSpot> graphPoints = [];
      double total = 0;
      double minValue = 99999999999;
      double maxValue = 0;
      for (int i = 0; i < data.length; i++) {
        GraphDataPoint e = data[i];
        minValue = min(minValue, e.amount);
        maxValue = max(maxValue, e.amount);
        total += e.amount;
        graphPoints.add(FlSpot(i.toDouble(), e.amount));
      }

      double average = total / data.length;

      List<FlSpot> avgData = [];
      for (int i = 0; i < data.length; i++) {
        avgData.add(FlSpot(i.toDouble(), average));
      }

      if (!isClosed) {
        emit(
          state.copyWith(
            loading: false,
            graphData: graphPoints,
            graphDataPoints: data,
            avgData: avgData,
            minValue: minValue * 0.7,
            maxValue: maxValue * 1.3,
          ),
        );
      }
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  setLiveCount(double count) {
    if (count >= MIN_PERIOD) {
      emit(state.copyWith(count: count.toInt()));
    }
  }
}

@freezed
sealed class StatsGraphState with _$StatsGraphState {
  const factory StatsGraphState({
    @Default(10) int periodMax,
    @Default(true) bool loading,
    @Default(5) int count,
    @Default(0) double minValue,
    @Default(0) double maxValue,
    @Default([
      FlSpot(0, 0),
      FlSpot(1, 0),
      FlSpot(2, 0),
      FlSpot(3, 0),
      FlSpot(4, 0),
    ])
    List<FlSpot> graphData,
    @Default([
      FlSpot(0, 0),
      FlSpot(1, 0),
      FlSpot(2, 0),
      FlSpot(3, 0),
      FlSpot(4, 0),
    ])
    List<FlSpot> avgData,
    @Default([
      GraphDataPoint(date: '2021', amount: 0),
      GraphDataPoint(date: '2020', amount: 0),
      GraphDataPoint(date: '2019', amount: 0),
      GraphDataPoint(date: '2018', amount: 0),
      GraphDataPoint(date: '2017', amount: 0),
    ])
    List<GraphDataPoint> graphDataPoints,
  }) = _StatsGraphState;
}
