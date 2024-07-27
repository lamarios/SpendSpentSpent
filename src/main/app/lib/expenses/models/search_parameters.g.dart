// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchParametersImpl _$$SearchParametersImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchParametersImpl(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      minAmount: (json['minAmount'] as num).toInt(),
      maxAmount: (json['maxAmount'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$$SearchParametersImplToJson(
        _$SearchParametersImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'note': instance.note,
    };
