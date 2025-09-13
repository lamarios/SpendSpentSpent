import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/categories/models/category.dart';

part 'category_prediction.freezed.dart';
part 'category_prediction.g.dart';

@freezed
sealed class CategoryPrediction with _$CategoryPrediction {
  const factory CategoryPrediction({
    required double probability,
    required Category category,
  }) = _CategoryPrediction;

  factory CategoryPrediction.fromJson(Map<String, Object?> json) =>
      _$CategoryPredictionFromJson(json);
}
