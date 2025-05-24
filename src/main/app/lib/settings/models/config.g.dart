// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Config _$ConfigFromJson(Map<String, dynamic> json) => _Config(
      allowSignup: json['allowSignup'] as bool,
      canResetPassword: json['canResetPassword'] as bool,
      demoMode: json['demoMode'] as bool,
      hasSubscription: json['hasSubscription'] as bool,
      canConvertCurrency: json['canConvertCurrency'] as bool,
      announcement: json['announcement'] as String,
      convertCurrencyQuota: json['convertCurrencyQuota'] as String,
      minAppVersion: json['minAppVersion'] as String?,
      backendVersion: (json['backendVersion'] as num).toInt(),
      oidc: json['oidc'] == null
          ? null
          : OidcConfig.fromJson(json['oidc'] as Map<String, dynamic>),
      oidcClientId: json['oidcClientId'] as String?,
      oidcEmailClaim: json['oidcEmailClaim'] as String?,
    );

Map<String, dynamic> _$ConfigToJson(_Config instance) => <String, dynamic>{
      'allowSignup': instance.allowSignup,
      'canResetPassword': instance.canResetPassword,
      'demoMode': instance.demoMode,
      'hasSubscription': instance.hasSubscription,
      'canConvertCurrency': instance.canConvertCurrency,
      'announcement': instance.announcement,
      'convertCurrencyQuota': instance.convertCurrencyQuota,
      'minAppVersion': instance.minAppVersion,
      'backendVersion': instance.backendVersion,
      'oidc': instance.oidc,
      'oidcClientId': instance.oidcClientId,
      'oidcEmailClaim': instance.oidcEmailClaim,
    };
