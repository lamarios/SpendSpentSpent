import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/expenses/models/day_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/expenses/models/search_parameters.dart';
import 'package:spend_spent_spent/utils/models/with_error.dart';

part 'expense_list.freezed.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit(super.initialState) {
    getMonths();
  }

  void getMonths() async {
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

      getExpenses();
    }
  }

  void monthChanged(value) {
    if (!isClosed) {
      emit(state.copyWith(selected: value ?? ''));
      getExpenses();
    }
  }

  getExpenses() async {
    emit(state.copyWith(loading: true));

    try {
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
  }

  switchSearch() {
    emit(state.copyWith(searchMode: !state.searchMode));

    if (!state.searchMode) {
      getExpenses();
    } else {
      emit(state.copyWith(expenses: {}, total: 0));
/*
      setState(() {
        this.expenses = <String, DayExpense>{};
        this.total = 0;
        expensesWidget = getExpensesWidget();
      });
*/
    }
  }

  search(SearchParameters params) async {
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
  }
}

@freezed
class ExpenseListState with _$ExpenseListState implements WithError {
  @Implements<WithError>()
  const factory ExpenseListState(
      {@Default([]) List<String> months,
      @Default('') String selected,
      @Default(0) double total,
      @Default(false) bool loading,
      @Default(false) bool searchMode,
      @Default({}) Map<String, DayExpense> expenses,
      dynamic error,
      StackTrace? stackTrace}) = _ExpenseListState;
}
