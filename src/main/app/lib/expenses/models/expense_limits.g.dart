// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_limits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseLimits _$ExpenseLimitsFromJson(Map<String, dynamic> json) =>
    _ExpenseLimits(
      years: (json['years'] as num).toInt(),
      months: (json['months'] as num).toInt(),
    );

Map<String, dynamic> _$ExpenseLimitsToJson(_ExpenseLimits instance) =>
    <String, dynamic>{
      'years': instance.years,
      'months': instance.months,
    };
