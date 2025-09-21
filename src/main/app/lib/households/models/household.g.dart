// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Household _$HouseholdFromJson(Map<String, dynamic> json) => _Household(
  id: json['id'] as String,
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => HouseholdMembers.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HouseholdToJson(_Household instance) =>
    <String, dynamic>{'id': instance.id, 'members': instance.members};
