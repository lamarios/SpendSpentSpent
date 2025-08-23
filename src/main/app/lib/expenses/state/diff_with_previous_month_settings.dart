import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/models/settings.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'diff_with_previous_month_settings.freezed.dart';

class DiffWithPreviousMonthSettingsCubit
    extends Cubit<DiffWithPreviousMonthSettingsState> {
  DiffWithPreviousMonthSettingsCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    var setting = (await service.getAllSettings())
        .where((s) => s.name == INCLUDE_RECURRING_IN_DIFF)
        .firstOrNull;
    emit(
      state.copyWith(includeRecurringExpenses: (setting?.value ?? "1") == "1"),
    );
  }

  Future<void> setIncludeRecurringExpenses(bool include) async {
    emit(state.copyWith(includeRecurringExpenses: include));
    service.setSettings(
      Settings(
        name: INCLUDE_RECURRING_IN_DIFF,
        value: include ? "1" : "0",
        secret: false,
      ),
    );
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
