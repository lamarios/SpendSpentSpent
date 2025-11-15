// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_guess_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryGuessResult _$CategoryGuessResultFromJson(Map<String, dynamic> json) => _CategoryGuessResult(
  categories: (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  file: SssFile.fromJson(json['file'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CategoryGuessResultToJson(_CategoryGuessResult instance) => <String, dynamic>{
  'categories': instance.categories,
  'file': instance.file,
};
