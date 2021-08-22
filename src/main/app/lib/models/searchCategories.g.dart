// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchCategories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchCategories _$SearchCategoriesFromJson(Map<String, dynamic> json) {
  return SearchCategories(
    query: json['query'] as String,
    results:
        AvailableCategories.fromJson(json['results'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchCategoriesToJson(SearchCategories instance) =>
    <String, dynamic>{
      'results': instance.results,
      'query': instance.query,
    };
