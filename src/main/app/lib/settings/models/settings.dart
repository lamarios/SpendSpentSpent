import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.g.dart';

part 'settings.freezed.dart';

@freezed
sealed class Settings with _$Settings {
  const factory Settings({
    required String name,
    required String value,
    required bool secret,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
