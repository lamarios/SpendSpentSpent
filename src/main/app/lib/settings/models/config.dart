import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.g.dart';

part 'config.freezed.dart';

@freezed
class Config with _$Config {
  const factory Config({
    required bool allowSignup,
    required bool canResetPassword,
    required bool demoMode,
    required bool hasSubscription,
    required bool canConvertCurrency,
    required String announcement,
    required String convertCurrencyQuota,
    String? minAppVersion,
    required int backendVersion,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
