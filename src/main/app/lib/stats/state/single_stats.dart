import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';

part 'single_stats.freezed.dart';

class SingleStatsCubit extends Cubit<SingleStatsState> {
  SingleStatsCubit(super.initialState);

  closeContainer() {
    emit(state.copyWith(open: false, showGraph: false));
  }

  openContainer() {
    emit(state.copyWith(open: true));
    Future.delayed(panelTransition, () {
      emit(state.copyWith(showGraph: true));
    });
  }
}

@freezed
sealed class SingleStatsState with _$SingleStatsState {
  const factory SingleStatsState({
    @Default(false) bool open,
    @Default(false) bool showGraph,
  }) = _SingleStatsState;
}
