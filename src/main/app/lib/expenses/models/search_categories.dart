import 'package:spend_spent_spent/categories/models/available_categories.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_categories.g.dart';
part 'search_categories.freezed.dart';

@freezed
class SearchCategories with _$SearchCategories {
  const factory SearchCategories({
    required AvailableCategories results,
    required String query,
  }) = _SearchCategories;

  factory SearchCategories.fromJson(Map<String, dynamic> json) =>
      _$SearchCategoriesFromJson(json);
}

/*
part 'searchCategories.g.dart';

@JsonSerializable()
class SearchCategories {
  AvailableCategories results;
  String query;

  SearchCategories({required this.query, required this.results});

  factory SearchCategories.fromJson(Map<String, dynamic> json) =>
      _$SearchCategoriesFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SearchCategoriesToJson(this);
}
*/
