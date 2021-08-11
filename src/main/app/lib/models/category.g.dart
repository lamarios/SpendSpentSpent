// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    json['icon'] as String,
    json['categoryOrder'] as int,
    json['id'] as int,
    (json['percentageOfMonthly'] as num).toDouble(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'icon': instance.icon,
      'categoryOrder': instance.categoryOrder,
      'id': instance.id,
      'percentageOfMonthly': instance.percentageOfMonthly,
    };
