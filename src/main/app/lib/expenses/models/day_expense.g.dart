// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayExpenseImpl _$$DayExpenseImplFromJson(Map<String, dynamic> json) =>
    _$DayExpenseImpl(
      date: json['date'] as String,
      total: (json['total'] as num).toDouble(),
      expenses: (json['expenses'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DayExpenseImplToJson(_$DayExpenseImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total': instance.total,
      'expenses': instance.expenses,
    };
