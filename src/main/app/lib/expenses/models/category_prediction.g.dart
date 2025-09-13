// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryPrediction _$CategoryPredictionFromJson(Map<String, dynamic> json) =>
    _CategoryPrediction(
      probability: (json['probability'] as num).toDouble(),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryPredictionToJson(_CategoryPrediction instance) =>
    <String, dynamic>{
      'probability': instance.probability,
      'category': instance.category,
    };
