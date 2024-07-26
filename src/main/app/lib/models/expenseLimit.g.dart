// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenseLimit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseLimits _$ExpenseLimitsFromJson(Map<String, dynamic> json) =>
    ExpenseLimits(
      years: (json['years'] as num).toInt(),
      months: (json['months'] as num).toInt(),
    );

Map<String, dynamic> _$ExpenseLimitsToJson(ExpenseLimits instance) =>
    <String, dynamic>{
      'years': instance.years,
      'months': instance.months,
    };
