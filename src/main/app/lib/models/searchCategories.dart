import 'package:spend_spent_spent/models/availableCategories.dart';
import 'package:json_annotation/json_annotation.dart';

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
