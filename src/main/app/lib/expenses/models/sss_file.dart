import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/expenses/models/ai_processing_status.dart';

part 'sss_file.freezed.dart';

part 'sss_file.g.dart';

@freezed
sealed class SssFile with _$SssFile {
  const factory SssFile({
    required String id,
    required String userId,
    int? expenseId,
    required AiProcessingStatus status,
    @Default([]) List<String> aiTags,
    @Default([]) List<double> amounts,
    required String fileName,
    required int timeCreated,
    required int timeUpdated,
  }) = _SssFile;

  factory SssFile.fromJson(Map<String, Object?> json) =>
      _$SssFileFromJson(json);

  const SssFile._();
}
