// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurringExpense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) =>
    RecurringExpense(
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      type: json['type'] as int?,
      amount: (json['amount'] as num).toDouble(),
      id: json['id'] as int?,
      income: json['income'] as bool,
      lastOccurrence: json['lastOccurrence'] as String?,
      name: json['name'] as String,
      nextOccurrence: json['nextOccurrence'] as String?,
      typeParam: json['typeParam'] as int,
    );

Map<String, dynamic> _$RecurringExpenseToJson(RecurringExpense instance) =>
    <String, dynamic>{
      'nextOccurrence': instance.nextOccurrence,
      'lastOccurrence': instance.lastOccurrence,
      'amount': instance.amount,
      'type': instance.type,
      'income': instance.income,
      'category': instance.category,
      'typeParam': instance.typeParam,
      'id': instance.id,
      'name': instance.name,
    };
