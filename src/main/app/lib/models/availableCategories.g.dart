// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availableCategories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableCategories _$AvailableCategoriesFromJson(Map<String, dynamic> json) {
  return AvailableCategories(
    shopping:
        (json['shopping'] as List<dynamic>?)?.map((e) => e as String).toList(),
    transports: (json['transports'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    brands:
        (json['brands'] as List<dynamic>?)?.map((e) => e as String).toList(),
    health:
        (json['health'] as List<dynamic>?)?.map((e) => e as String).toList(),
    documents:
        (json['documents'] as List<dynamic>?)?.map((e) => e as String).toList(),
    education:
        (json['education'] as List<dynamic>?)?.map((e) => e as String).toList(),
    hobbies:
        (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
    housing:
        (json['housing'] as List<dynamic>?)?.map((e) => e as String).toList(),
    tech: (json['tech'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AvailableCategoriesToJson(
        AvailableCategories instance) =>
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
