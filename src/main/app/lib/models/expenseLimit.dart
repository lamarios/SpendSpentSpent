import 'package:json_annotation/json_annotation.dart';

part 'expenseLimit.g.dart';

@JsonSerializable()
class ExpenseLimits {
  int years, months;

  ExpenseLimits({required this.years, required this.months});

  factory ExpenseLimits.fromJson(Map<String, dynamic> json) =>
      _$ExpenseLimitsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ExpenseLimitsToJson(this);
}
