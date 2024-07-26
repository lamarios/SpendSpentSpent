import 'package:spend_spent_spent/categories/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recurringExpense.g.dart';

@JsonSerializable()
class RecurringExpense {
  String? nextOccurrence;
  String? lastOccurrence;
  double amount;
  int? type = 1;
  bool income = false;
  Category category;
  int typeParam;
  int? id;
  String name;

  RecurringExpense(
      {required this.category,
      this.type,
      required this.amount,
      this.id,
      required this.income,
      this.lastOccurrence,
      required this.name,
      this.nextOccurrence,
      required this.typeParam});

  factory RecurringExpense.fromJson(Map<String, dynamic> json) => _$RecurringExpenseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecurringExpenseToJson(this);
}
