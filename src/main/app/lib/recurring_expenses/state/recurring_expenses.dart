import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/recurring_expenses/models/recurring_expense.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'recurring_expenses.freezed.dart';

class RecurringExpensesCubit extends Cubit<RecurringExpensesState> {
  RecurringExpensesCubit(super.initialState) {
    getRecurringExpenses();
  }

  getRecurringExpenses() async {
    emit(state.copyWith(loading: true));
    try {
      final expenses = await service.getRecurringExpenses();
      if (!isClosed) {
        emit(state.copyWith(expenses: expenses));
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
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
