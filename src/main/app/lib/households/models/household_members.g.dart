// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_members.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HouseholdMembers _$HouseholdMembersFromJson(Map<String, dynamic> json) => _HouseholdMembers(
  id: json['id'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  invitedBy: json['invitedBy'] == null ? null : User.fromJson(json['invitedBy'] as Map<String, dynamic>),
  status: $enumDecode(_$HouseholdInviteStatusEnumMap, json['status']),
  color: $enumDecode(_$HouseholdColorEnumMap, json['color']),
  admin: json['admin'] as bool? ?? false,
);

Map<String, dynamic> _$HouseholdMembersToJson(_HouseholdMembers instance) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'invitedBy': instance.invitedBy,
  'status': _$HouseholdInviteStatusEnumMap[instance.status]!,
  'color': _$HouseholdColorEnumMap[instance.color]!,
  'admin': instance.admin,
};

const _$HouseholdInviteStatusEnumMap = {
  HouseholdInviteStatus.accepted: 'accepted',
  HouseholdInviteStatus.pending: 'pending',
};

const _$HouseholdColorEnumMap = {
  HouseholdColor.green: 'green',
  HouseholdColor.red: 'red',
  HouseholdColor.orange: 'orange',
  HouseholdColor.yellow: 'yellow',
  HouseholdColor.purple: 'purple',
  HouseholdColor.pink: 'pink',
  HouseholdColor.brown: 'brown',
  HouseholdColor.cyan: 'cyan',
  HouseholdColor.teal: 'teal',
  HouseholdColor.lime: 'lime',
};
