import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spend_spent_spent/settings/models/oidc_config.dart';

part 'config.g.dart';

part 'config.freezed.dart';

@freezed
sealed class Config with _$Config {
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
    OidcConfig? oidc,
    String? oidcClientId,
    String? oidcEmailClaim,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
