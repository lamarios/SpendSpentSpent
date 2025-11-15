import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';

part 'single_stats.freezed.dart';

class SingleStatsCubit extends Cubit<SingleStatsState> {
  SingleStatsCubit(super.initialState);

  void closeContainer() {
    emit(state.copyWith(open: false, showGraph: false));
  }

  void openContainer() {
    final newState = !state.open;
    emit(state.copyWith(open: newState));
    Future.delayed(panelTransition, () {
      emit(state.copyWith(showGraph: newState));
    });
  }
}

@freezed
sealed class SingleStatsState with _$SingleStatsState {
  const factory SingleStatsState({@Default(false) bool open, @Default(false) bool showGraph}) = _SingleStatsState;
}
