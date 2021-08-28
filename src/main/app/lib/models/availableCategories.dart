import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'availableCategories.g.dart';

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

  factory AvailableCategories.fromJson(Map<String, dynamic> json) =>
      _$AvailableCategoriesFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AvailableCategoriesToJson(this);
}
