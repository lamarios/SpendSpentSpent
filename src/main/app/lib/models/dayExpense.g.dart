// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dayExpense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayExpense _$DayExpenseFromJson(Map<String, dynamic> json) => DayExpense(
      expenses: (json['expenses'] as List<dynamic>)
          .map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String,
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$DayExpenseToJson(DayExpense instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total': instance.total,
      'expenses': instance.expenses,
    };
