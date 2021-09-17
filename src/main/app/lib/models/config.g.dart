// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
    demoMode: json['demoMode'] as bool,
    allowSignup: json['allowSignup'] as bool,
    announcement: json['announcement'] as String,
    canResetPassword: json['canResetPassword'] as bool,
    hasSubscription: json['hasSubscription'] as bool,
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'allowSignup': instance.allowSignup,
      'canResetPassword': instance.canResetPassword,
      'demoMode': instance.demoMode,
      'hasSubscription': instance.hasSubscription,
      'announcement': instance.announcement,
    };
