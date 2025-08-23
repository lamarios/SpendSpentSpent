// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchCategories _$SearchCategoriesFromJson(Map<String, dynamic> json) =>
    _SearchCategories(
      results: AvailableCategories.fromJson(
        json['results'] as Map<String, dynamic>,
      ),
      query: json['query'] as String,
    );

Map<String, dynamic> _$SearchCategoriesToJson(_SearchCategories instance) =>
    <String, dynamic>{'results': instance.results, 'query': instance.query};
