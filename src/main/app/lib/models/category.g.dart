// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      icon: json['icon'] as String?,
      categoryOrder: json['categoryOrder'] as int?,
      id: json['id'] as int?,
      percentageOfMonthly: (json['percentageOfMonthly'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'icon': instance.icon,
      'categoryOrder': instance.categoryOrder,
      'id': instance.id,
      'percentageOfMonthly': instance.percentageOfMonthly,
    };
