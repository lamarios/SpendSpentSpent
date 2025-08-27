import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_picker.freezed.dart';

class MonthPickerCubit extends Cubit<MonthPickerState> {
  MonthPickerCubit(super.initialState);

  void setMonth(DateTime month) {
    emit(state.copyWith(selected: month));
  }

  void setYear(int year) {
    emit(state.copyWith(selectedYear: year));
  }
}

@freezed
sealed class MonthPickerState with _$MonthPickerState {
  const factory MonthPickerState({
    required DateTime selected,
    required int selectedYear,
  }) = _MonthPickerState;
}
