// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    amount: (json['amount'] as num).toDouble(),
    id: json['id'] as int?,
    date: json['date'] as String,
    note: json['note'] as String?,
    category: Category.fromJson(json['category'] as Map<String, dynamic>),
    type: json['type'] as int?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    timestamp: json['timestamp'] as int?,
  )..income = json['income'] as bool;
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
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
