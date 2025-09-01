import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/expenses/models/sss_file.dart';

part 'category_guess_result.freezed.dart';
part 'category_guess_result.g.dart';

@freezed
sealed class CategoryGuessResult with _$CategoryGuessResult {
  const factory CategoryGuessResult({
    @Default([]) List<String> categories,
    required SssFile file,
  }) = _CategoryGuessResult;

  factory CategoryGuessResult.fromJson(Map<String, Object?> json) =>
      _$CategoryGuessResultFromJson(json);
}
