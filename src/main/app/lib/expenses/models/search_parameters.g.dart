// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchParameters _$SearchParametersFromJson(Map<String, dynamic> json) =>
    _SearchParameters(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      minAmount: (json['minAmount'] as num).toInt(),
      maxAmount: (json['maxAmount'] as num).toInt(),
      searchQuery: json['searchQuery'] as String? ?? '',
    );

Map<String, dynamic> _$SearchParametersToJson(_SearchParameters instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'searchQuery': instance.searchQuery,
    };
