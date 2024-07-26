// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchParameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchParameters _$SearchParametersFromJson(Map<String, dynamic> json) =>
    SearchParameters(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxAmount: (json['maxAmount'] as num).toInt(),
      minAmount: (json['minAmount'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$SearchParametersToJson(SearchParameters instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'note': instance.note,
    };
