// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      icon: json['icon'] as String?,
      categoryOrder: (json['categoryOrder'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      percentageOfMonthly: (json['percentageOfMonthly'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'categoryOrder': instance.categoryOrder,
      'id': instance.id,
      'percentageOfMonthly': instance.percentageOfMonthly,
    };
