import '../../categories/models/category.dart';

import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_parameters.g.dart';

part 'search_parameters.freezed.dart';

@freezed
sealed class SearchParameters with _$SearchParameters {
  const factory SearchParameters({
    @Default([]) List<Category> categories,
    required int minAmount,
    required int maxAmount,
    @Default('') String searchQuery,
    int? minDate,
    int? maxDate,
  }) = _SearchParameters;

  factory SearchParameters.fromJson(Map<String, dynamic> json) =>
      _$SearchParametersFromJson(json);
}
