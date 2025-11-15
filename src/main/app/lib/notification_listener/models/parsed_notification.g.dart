// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parsed_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParsedNotification _$ParsedNotificationFromJson(Map<String, dynamic> json) => _ParsedNotification(
  package: json['package'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  time: (json['time'] as num).toInt(),
  amountFound: (json['amountFound'] as num).toDouble(),
);

Map<String, dynamic> _$ParsedNotificationToJson(_ParsedNotification instance) => <String, dynamic>{
  'package': instance.package,
  'title': instance.title,
  'content': instance.content,
  'time': instance.time,
  'amountFound': instance.amountFound,
};
