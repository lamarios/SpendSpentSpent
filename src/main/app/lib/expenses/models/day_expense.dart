import 'expense.dart';

import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_expense.g.dart';
part 'day_expense.freezed.dart';

@freezed
class DayExpense with _$DayExpense {
  const factory DayExpense(
      {required String date,
      required double total,
      @Default([]) List<Expense> expenses}) = _DayExpense;

  factory DayExpense.fromJson(Map<String, dynamic> json) =>
      _$DayExpenseFromJson(json);
}
