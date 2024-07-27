import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';

part 'recurring_expense.freezed.dart';

part 'recurring_expense.g.dart';

@freezed
class RecurringExpense with _$RecurringExpense {
  const factory RecurringExpense({
    String? nextOccurrence,
    String? lastOccurrence,
    required double amount,
    @Default(1) int type,
    @Default(false) bool income,
    required Category category,
    required int typeParam,
    int? id,
    required String name,
  }) = _RecurringExpense;

  factory RecurringExpense.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseFromJson(json);
}

/*


@JsonSerializable()
class RecurringExpense {

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

  factory RecurringExpense.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecurringExpenseToJson(this);
}
*/
