// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'left_column_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeftColumnStats _$LeftColumnStatsFromJson(Map<String, dynamic> json) =>
    _LeftColumnStats(
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      total: (json['total'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$LeftColumnStatsToJson(_LeftColumnStats instance) =>
    <String, dynamic>{
      'category': instance.category,
      'total': instance.total,
      'amount': instance.amount,
    };
