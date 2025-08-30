import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';

part 'expense.freezed.dart';

part 'expense.g.dart';

@freezed
sealed class Expense with _$Expense {
  const factory Expense({
    required String date,
    required double amount,
    double? latitude,
    double? longitude,
    String? note,
    @Default(1) int type,
    int? timestamp,
    @Default(false) bool income,
    required Category category,
    int? id,
    @Default([]) List<SssFile> files,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
