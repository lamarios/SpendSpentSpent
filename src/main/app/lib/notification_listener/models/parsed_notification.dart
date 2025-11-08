import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'parsed_notification.freezed.dart';

part 'parsed_notification.g.dart';

@freezed
sealed class ParsedNotification with _$ParsedNotification {
  const factory ParsedNotification({
    String? package,
    String? title,
    String? content,
    required int time,
    required double amountFound,
    @JsonKey(includeFromJson: false, includeToJson: false) String? appName,
    @JsonKey(includeFromJson: false, includeToJson: false) Uint8List? icon,
  }) = _ParsedNotification;

  factory ParsedNotification.fromJson(Map<String, Object?> json) =>
      _$ParsedNotificationFromJson(json);
}
