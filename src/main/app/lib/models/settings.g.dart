// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      name: json['name'] as String,
      value: json['value'] as String,
      secret: json['secret'] as bool,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'secret': instance.secret,
    };
