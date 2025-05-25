import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'available_categories.g.dart';
part 'available_categories.freezed.dart';

@freezed
sealed class AvailableCategories with _$AvailableCategories {
  const factory AvailableCategories({
    @Default([]) List<String>? shopping,
    @Default([]) List<String>? transports,
    @Default([]) List<String>? brands,
    @Default([]) List<String>? hobbies,
    @Default([]) List<String>? health,
    @Default([]) List<String>? education,
    @Default([]) List<String>? housing,
    @Default([]) List<String>? tech,
    @Default([]) List<String>? documents,
  }) = _AvailableCategories;

  factory AvailableCategories.fromJson(Map<String, dynamic> json) =>
      _$AvailableCategoriesFromJson(json);
}

/*
@JsonSerializable()
class AvailableCategories {
  List<String>? shopping = [],
      transports = [],
      brands = [],
      hobbies = [],
      health = [],
      education = [],
      housing = [],
      tech = [],
      documents = [];

  AvailableCategories(
      {this.shopping,
      this.transports,
      this.brands,
      this.health,
      this.documents,
      this.education,
      this.hobbies,
      this.housing,
      this.tech});


  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AvailableCategoriesToJson(this);
}
*/
