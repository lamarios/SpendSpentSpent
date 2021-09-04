// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leftColumnStats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeftColumnStats _$LeftColumnStatsFromJson(Map<String, dynamic> json) {
  return LeftColumnStats(
    category: Category.fromJson(json['category'] as Map<String, dynamic>),
    total: (json['total'] as num).toDouble(),
    amount: (json['amount'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LeftColumnStatsToJson(LeftColumnStats instance) =>
    <String, dynamic>{
      'category': instance.category,
      'total': instance.total,
      'amount': instance.amount,
    };
