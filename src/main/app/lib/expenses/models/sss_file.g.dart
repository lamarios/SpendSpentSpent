// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sss_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SssFile _$SssFileFromJson(Map<String, dynamic> json) => _SssFile(
  id: json['id'] as String,
  userId: json['userId'] as String,
  expenseId: (json['expenseId'] as num?)?.toInt(),
  status: $enumDecode(_$AiProcessingStatusEnumMap, json['status']),
  aiTags:
      (json['aiTags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  amounts:
      (json['amounts'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [],
  fileName: json['fileName'] as String,
  timeCreated: (json['timeCreated'] as num).toInt(),
  timeUpdated: (json['timeUpdated'] as num).toInt(),
);

Map<String, dynamic> _$SssFileToJson(_SssFile instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'expenseId': instance.expenseId,
  'status': _$AiProcessingStatusEnumMap[instance.status]!,
  'aiTags': instance.aiTags,
  'amounts': instance.amounts,
  'fileName': instance.fileName,
  'timeCreated': instance.timeCreated,
  'timeUpdated': instance.timeUpdated,
};

const _$AiProcessingStatusEnumMap = {
  AiProcessingStatus.NO_PROCESSING: 'NO_PROCESSING',
  AiProcessingStatus.PENDING: 'PENDING',
  AiProcessingStatus.PROCESSING: 'PROCESSING',
  AiProcessingStatus.DONE: 'DONE',
  AiProcessingStatus.ERROR: 'ERROR',
};
