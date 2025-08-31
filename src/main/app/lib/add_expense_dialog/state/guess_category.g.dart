// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guess_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuessCategoryState _$GuessCategoryStateFromJson(Map<String, dynamic> json) =>
    _GuessCategoryState(
      loading: json['loading'] as bool? ?? true,
      results: json['results'] == null
          ? null
          : CategoryGuessResult.fromJson(
              json['results'] as Map<String, dynamic>,
            ),
      selected: json['selected'] as String?,
    );

Map<String, dynamic> _$GuessCategoryStateToJson(_GuessCategoryState instance) =>
    <String, dynamic>{
      'loading': instance.loading,
      'results': instance.results,
      'selected': instance.selected,
    };
