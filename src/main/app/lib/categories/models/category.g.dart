// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  icon: json['icon'] as String?,
  categoryOrder: (json['categoryOrder'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  percentageOfMonthly: (json['percentageOfMonthly'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'icon': instance.icon,
  'categoryOrder': instance.categoryOrder,
  'id': instance.id,
  'percentageOfMonthly': instance.percentageOfMonthly,
};
