import 'package:json_annotation/json_annotation.dart';

import '../categories/models/category.dart';

part 'searchParameters.g.dart';

@JsonSerializable()
class SearchParameters {
  List<Category> categories;
  int minAmount, maxAmount;
  String note;

  SearchParameters(
      {required this.categories,
      required this.maxAmount,
      required this.minAmount,
      required this.note});

  factory SearchParameters.fromJson(Map<String, dynamic> json) =>
      _$SearchParametersFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SearchParametersToJson(this);
}
