// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  name: json['name'] as String,
  value: json['value'] as String,
  secret: json['secret'] as bool,
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'name': instance.name,
  'value': instance.value,
  'secret': instance.secret,
};
