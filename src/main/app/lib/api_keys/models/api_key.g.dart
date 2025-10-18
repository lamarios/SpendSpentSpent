// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => _ApiKey(
  id: json['id'] as String,
  timeCreated: (json['timeCreated'] as num).toInt(),
  keyName: json['keyName'] as String,
  lastUsed: (json['lastUsed'] as num?)?.toInt(),
  expiryDate: (json['expiryDate'] as num?)?.toInt(),
  apiKey: json['apiKey'] as String?,
);

Map<String, dynamic> _$ApiKeyToJson(_ApiKey instance) => <String, dynamic>{
  'id': instance.id,
  'timeCreated': instance.timeCreated,
  'keyName': instance.keyName,
  'lastUsed': instance.lastUsed,
  'expiryDate': instance.expiryDate,
  'apiKey': instance.apiKey,
};
