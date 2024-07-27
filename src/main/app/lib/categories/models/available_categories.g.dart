// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailableCategoriesImpl _$$AvailableCategoriesImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailableCategoriesImpl(
      shopping: (json['shopping'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      transports: (json['transports'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      brands: (json['brands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hobbies: (json['hobbies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      health: (json['health'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      housing: (json['housing'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tech:
          (json['tech'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AvailableCategoriesImplToJson(
        _$AvailableCategoriesImpl instance) =>
    <String, dynamic>{
      'shopping': instance.shopping,
      'transports': instance.transports,
      'brands': instance.brands,
      'hobbies': instance.hobbies,
      'health': instance.health,
      'education': instance.education,
      'housing': instance.housing,
      'tech': instance.tech,
      'documents': instance.documents,
    };
