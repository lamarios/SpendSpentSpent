import 'dart:core';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'expense_list.freezed.dart';

final _log = Logger('ExpenseListCubit');

class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit(super.initialState) {
    getMonths(true);
  }

  void getMonths(bool loading) async {
    emit(state.copyWith(loading: loading));
    List<String> months = await service.getExpensesMonths();
    String now = DateFormat("yyyy-MM").format(DateTime.now());
    int nowIndex = months.indexWhere((element) => element == now);
    if (!isClosed) {
      String selected = state.selected;
      if (months.isNotEmpty && selected == '' && nowIndex != -1) {
        selected = months[nowIndex];
      } else if (months.isNotEmpty && selected == '') {
        selected = months[months.length - 1];
      }

      emit(state.copyWith(months: months, selected: selected));

      if (!state.searchMode) {
        getExpenses(loading);
        getDiff();
      }
    }
  }

  void monthChanged(value) {
    if (!isClosed) {
      emit(state.copyWith(selected: value ?? ''));
      getExpenses(true);
      getDiff();
    }
  }

  Future<void> getDiff() async {
    var now = DateTime.now();
    var yyyyMMddFormat = DateFormat('yyyy-MM-dd');
    var yyyyMMFormat = DateFormat('yyyy-MM');
    var compareTo = yyyyMMFormat.format(now).compareTo(state.selected);
    late String compareDate;
    if (compareTo > 0) {
      _log.fine('selected before now: $compareTo');
      // we go to 31, so we always compare full month regardless if the month is 31 days or less
      compareDate = '${state.selected}-31';
    } else if (compareTo < 0) {
      _log.fine('we are in the future, skipping');
      emit(state.copyWith(diffWithPreviousPeriod: null));
      return;
    } else {
      compareDate = yyyyMMddFormat.format(now);
      _log.fine('selected is now: $compareTo');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final includeRecurring = prefs.getBool(INCLUDE_RECURRING_IN_DIFF);
    var diff = await service.getDiffWithPreviousPeriod(
      compareDate,
      includeRecurring: includeRecurring ?? true,
    );
    _log.fine('Comparing data up until $compareDate, diff: $diff');
    emit(state.copyWith(diffWithPreviousPeriod: diff));
  }

  Future<void> getExpenses(bool loading) async {
    EasyDebounce.debounce('expenses', Duration(milliseconds: 500), () async {
      try {
        emit(state.copyWith(loading: loading));
        var expenses = await service.getMonthExpenses(state.selected);
        var total = expenses.values
            .map((e) => e.total)
            .reduce((value, element) => value + element);
        if (!isClosed) {
          emit(state.copyWith(expenses: expenses, total: total));
        }
      } catch (e, s) {
        emit(state.copyWith(error: e, stackTrace: s));
      } finally {
        emit(state.copyWith(loading: false));
      }
    });
  }

  void switchSearch() {
    emit(state.copyWith(searchMode: !state.searchMode));

    if (!state.searchMode) {
      emit(
        state.copyWith(
          expenses: {},
          total: 0,
          diffWithPreviousPeriod: null,
          loading: true,
        ),
      );
      getExpenses(true);
      getDiff();
    } else {
      emit(
        state.copyWith(
          expenses: {},
          total: 0,
          diffWithPreviousPeriod: null,
          loading: true,
        ),
      );
    }
  }

  Future<void> search(SearchParameters params) async {
    EasyDebounce.debounce('expenses', Duration(milliseconds: 500), () async {
      try {
        emit(state.copyWith(loading: true));
        var expenses = await service.search(params);
        double total = expenses.values.isNotEmpty
            ? expenses.values
                  .map((e) => e.total)
                  .reduce((value, element) => value + element)
            : 0;
        if (!isClosed) {
          emit(state.copyWith(expenses: expenses, total: total));
        }
      } catch (e, s) {
        emit(state.copyWith(error: e, stackTrace: s));
      } finally {
        emit(state.copyWith(loading: false));
      }
    });
  }
}

@freezed
sealed class ExpenseListState with _$ExpenseListState implements WithError {
  @Implements<WithError>()
  const factory ExpenseListState({
    @Default([]) List<String> months,
    @Default('') String selected,
    @Default(0) double total,
    @Default(false) bool loading,
    @Default(false) bool searchMode,
    double? diffWithPreviousPeriod,
    @Default({}) Map<String, DayExpense> expenses,
    dynamic error,
    StackTrace? stackTrace,
  }) = _ExpenseListState;
}
