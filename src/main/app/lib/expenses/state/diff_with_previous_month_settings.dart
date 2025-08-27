import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'diff_with_previous_month_settings.freezed.dart';

class DiffWithPreviousMonthSettingsCubit
    extends Cubit<DiffWithPreviousMonthSettingsState> {
  DiffWithPreviousMonthSettingsCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(INCLUDE_RECURRING_IN_DIFF);
    emit(state.copyWith(includeRecurringExpenses: enabled ?? true));
  }

  Future<void> setIncludeRecurringExpenses(bool include) async {
    emit(state.copyWith(includeRecurringExpenses: include));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(INCLUDE_RECURRING_IN_DIFF, include);
  }
}

@freezed
sealed class DiffWithPreviousMonthSettingsState
    with _$DiffWithPreviousMonthSettingsState
    implements WithError {
  @Implements<WithError>()
  const factory DiffWithPreviousMonthSettingsState({
    @Default(true) bool includeRecurringExpenses,
    dynamic error,
    StackTrace? stackTrace,
  }) = _DiffWithPreviousMonthSettingsState;
}
