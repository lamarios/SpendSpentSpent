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
  int _shownRequest = 0;

  /// With [showLoading] false, the list is refreshed in the background: the current one stays shown and a failure is
  /// only logged.
  ///
  /// An answer is dropped once the answer to a newer request is shown, it could bring back an expense deleted in the
  /// meantime. A failed request doesn't drop an older answer, the first load would be lost otherwise. Only a failure of
  /// the latest request is shown.
  Future<void> getRecurringExpenses({bool showLoading = true}) async {
    final request = ++_latestRequest;
    bool isNewest() => !isClosed && request > _shownRequest;
    bool isLatest() => !isClosed && request == _latestRequest;

    if (showLoading) {
      emit(state.copyWith(loading: true));
    }
    try {
      final expenses = await service.getRecurringExpenses();
      if (isNewest()) {
        _shownRequest = request;
        emit(state.copyWith(expenses: expenses, loading: false));
      }
    } catch (e, s) {
      if (!showLoading || !isLatest()) {
        _log.warning('Could not refresh the recurring expenses', e, s);
        return;
      }
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    } finally {
      // after a failure, the loading indicator stays until the latest request is answered
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
