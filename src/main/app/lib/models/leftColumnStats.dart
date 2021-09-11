import 'package:spend_spent_spent/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leftColumnStats.g.dart';

@JsonSerializable()
class LeftColumnStats {
  Category category;
  double total, amount;

  LeftColumnStats({required this.category, required this.total, required this.amount});

  factory LeftColumnStats.fromJson(Map<String, dynamic> json) => _$LeftColumnStatsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LeftColumnStatsToJson(this);
}
