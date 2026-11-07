import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'recurring_expenses.freezed.dart';

final _log = Logger('RecurringExpensesCubit');

class RecurringExpensesCubit extends Cubit<RecurringExpensesState> {
  RecurringExpensesCubit(super.initialState) {
    getRecurringExpenses();
  }

  int _latestRequest = 0;

  /// With [showLoading] false, the list is refreshed in the background: the current one stays shown and a failure is
  /// only logged.
  ///
  /// Only the answer to the latest request is kept, an older one could bring back an expense deleted in the meantime.
  Future<void> getRecurringExpenses({bool showLoading = true}) async {
    final request = ++_latestRequest;
    bool isLatest() => !isClosed && request == _latestRequest;

    if (showLoading) {
      emit(state.copyWith(loading: true));
    }
    try {
      final expenses = await service.getRecurringExpenses();
      if (isLatest()) {
        emit(state.copyWith(expenses: expenses));
      }
    } catch (e, s) {
      if (!showLoading || !isLatest()) {
        _log.warning('Could not refresh the recurring expenses', e, s);
        return;
      }
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    } finally {
      // the loading indicator stays until the latest request is answered
      if (isLatest() && state.loading) {
        emit(state.copyWith(loading: false));
      }
    }
  }
}

@freezed
sealed class RecurringExpensesState with _$RecurringExpensesState implements WithError {
  @Implements<WithError>()
  const factory RecurringExpensesState({
    @Default(false) bool loading,
    dynamic error,
    StackTrace? stackTrace,
    @Default([]) List<RecurringExpense> expenses,
  }) = _RecurringExpensesState;
}
