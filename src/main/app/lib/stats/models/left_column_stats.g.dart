// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'left_column_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeftColumnStatsImpl _$$LeftColumnStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$LeftColumnStatsImpl(
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      total: (json['total'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$LeftColumnStatsImplToJson(
        _$LeftColumnStatsImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'total': instance.total,
      'amount': instance.amount,
    };
