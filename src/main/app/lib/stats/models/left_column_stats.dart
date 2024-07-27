import 'package:spend_spent_spent/categories/models/category.dart';

import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'left_column_stats.g.dart';

part 'left_column_stats.freezed.dart';

@freezed
class LeftColumnStats with _$LeftColumnStats {
  const factory LeftColumnStats(
      {required Category category,
      required double total,
      required double amount}) = _LeftColumnStats;

  factory LeftColumnStats.fromJson(Map<String, dynamic> json) =>
      _$LeftColumnStatsFromJson(json);
}
