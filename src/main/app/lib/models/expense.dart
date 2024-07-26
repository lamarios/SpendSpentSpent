import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  String date;
  double amount;
  double? latitude, longitude;
  String? note;
  int? type = 1, timestamp;
  bool income = false;
  Category category;
  int? id;

  Expense(
      {required this.amount,
      this.id,
      required this.date,
      this.note,
      required this.category,
      this.type,
      this.latitude,
      this.longitude,
      this.timestamp});

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}
