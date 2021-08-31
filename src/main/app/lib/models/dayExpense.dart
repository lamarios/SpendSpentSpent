import 'package:json_annotation/json_annotation.dart';

import 'expense.dart';

part 'dayExpense.g.dart';

@JsonSerializable()
class DayExpense{
  String date;
  double total;
  List<Expense> expenses;

  DayExpense({required this.expenses, required this.date, required this.total});


  factory DayExpense.fromJson(Map<String, dynamic> json) => _$DayExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$DayExpenseToJson(this);
}