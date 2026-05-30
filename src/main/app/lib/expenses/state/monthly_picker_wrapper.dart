import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

import '../services/history_service.dart';

part 'monthly_picker_wrapper.freezed.dart';

class MonthlyPickerWrapperCubit extends Cubit<MonthlyPickerWrapperState> {
  MonthlyPickerWrapperCubit(super.initialState);

  Future<void> onMonthPickerYearChange(int year) async {
    emit(state.copyWith(totals: {}, loading: true));
    EasyDebounce.debounce('monthly picker debounce', Duration(milliseconds: 250), () async {
      try {
        var totals = await service.getMonthTotalForYear(year);
        emit(state.copyWith(loading: false, totals: totals));
      } catch (e, s) {
        emit(state.copyWith(error: e, stackTrace: s, loading: false));
      }
    });
  }
}

@freezed
sealed class MonthlyPickerWrapperState with _$MonthlyPickerWrapperState implements WithError {
  @Implements<WithError>()
  const factory MonthlyPickerWrapperState({
    @Default({}) Map<int, double> totals,
    @Default(false) bool loading,
    dynamic error,
    StackTrace? stackTrace,
  }) = _MonthlyPickerWrapperState;
}
