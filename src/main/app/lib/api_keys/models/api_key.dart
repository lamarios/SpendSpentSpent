import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_key.freezed.dart';
part 'api_key.g.dart';

@freezed
sealed class ApiKey with _$ApiKey {
  const factory ApiKey({
    required String id,
    required int timeCreated,
    required String keyName,
    int? lastUsed,
    int? expiryDate,
    String? apiKey,
  }) = _ApiKey;

  factory ApiKey.fromJson(Map<String, Object?> json) => _$ApiKeyFromJson(json);
}
