// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) =>
    _RecurringExpense(
      nextOccurrence: json['nextOccurrence'] as String?,
      lastOccurrence: json['lastOccurrence'] as String?,
      amount: (json['amount'] as num).toDouble(),
      type: (json['type'] as num?)?.toInt() ?? 1,
      income: json['income'] as bool? ?? false,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      typeParam: (json['typeParam'] as num).toInt(),
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RecurringExpenseToJson(_RecurringExpense instance) =>
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
