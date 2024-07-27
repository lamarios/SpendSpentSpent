// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      note: json['note'] as String?,
      type: (json['type'] as num?)?.toInt() ?? 1,
      timestamp: json['timestamp'],
      income: json['income'] as bool? ?? false,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'note': instance.note,
      'type': instance.type,
      'timestamp': instance.timestamp,
      'income': instance.income,
      'category': instance.category,
      'id': instance.id,
    };
