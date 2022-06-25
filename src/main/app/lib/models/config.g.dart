// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      demoMode: json['demoMode'] as bool,
      allowSignup: json['allowSignup'] as bool,
      announcement: json['announcement'] as String,
      canResetPassword: json['canResetPassword'] as bool,
      hasSubscription: json['hasSubscription'] as bool,
      minAppVersion: json['minAppVersion'] as String?,
      backendVersion: json['backendVersion'] as int,
      canConvertCurrency: json['canConvertCurrency'] as bool,
      convertCurrencyQuota: json['convertCurrencyQuota'] as String,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'allowSignup': instance.allowSignup,
      'canResetPassword': instance.canResetPassword,
      'demoMode': instance.demoMode,
      'hasSubscription': instance.hasSubscription,
      'canConvertCurrency': instance.canConvertCurrency,
      'announcement': instance.announcement,
      'convertCurrencyQuota': instance.convertCurrencyQuota,
      'minAppVersion': instance.minAppVersion,
      'backendVersion': instance.backendVersion,
    };
