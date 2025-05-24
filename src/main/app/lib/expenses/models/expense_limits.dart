import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_limits.g.dart';
part 'expense_limits.freezed.dart';

@freezed
sealed class ExpenseLimits with _$ExpenseLimits {
  const factory ExpenseLimits({required int years, required int months}) =
      _ExpenseLimits;

  factory ExpenseLimits.fromJson(Map<String, dynamic> json) =>
      _$ExpenseLimitsFromJson(json);
}
