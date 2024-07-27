// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchCategoriesImpl _$$SearchCategoriesImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchCategoriesImpl(
      results:
          AvailableCategories.fromJson(json['results'] as Map<String, dynamic>),
      query: json['query'] as String,
    );

Map<String, dynamic> _$$SearchCategoriesImplToJson(
        _$SearchCategoriesImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'query': instance.query,
    };
