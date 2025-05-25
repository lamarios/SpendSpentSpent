import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/stats/models/left_column_stats.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'stats_list.freezed.dart';

class StatsListCubit extends Cubit<StatsListState> {
  final bool monthly;

  StatsListCubit(super.initialState, {required this.monthly}) {
    getStats();
  }

  Future<void> getStats() async {
    emit(state.copyWith(loading: true));
    try {
      List<LeftColumnStats> stats = [];
      if (monthly) {
        stats = await service.getMonthStats();
      } else {
        stats = await service.getYearStats();
      }

      if (!isClosed) {
        emit(state.copyWith(stats: stats));
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}

@freezed
sealed class StatsListState with _$StatsListState implements WithError {
  @Implements<WithError>()
  const factory StatsListState({
    @Default(false) bool loading,
    @Default([]) List<LeftColumnStats> stats,
    dynamic error,
    StackTrace? stackTrace,
  }) = _StatsListState;
}
