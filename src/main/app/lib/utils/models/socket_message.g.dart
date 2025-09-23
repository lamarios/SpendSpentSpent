// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SssSocketMessage _$SssSocketMessageFromJson(Map<String, dynamic> json) =>
    _SssSocketMessage(
      message: json['message'] as Map<String, dynamic>,
      type: $enumDecode(_$SssSocketMessageTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$SssSocketMessageToJson(_SssSocketMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'type': _$SssSocketMessageTypeEnumMap[instance.type]!,
    };

const _$SssSocketMessageTypeEnumMap = {
  SssSocketMessageType.sssFile: 'sssFile',
  SssSocketMessageType.householdUpdate: 'householdUpdate',
};
