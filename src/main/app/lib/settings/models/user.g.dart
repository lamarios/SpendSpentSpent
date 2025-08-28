// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  id: json['id'] as String?,
  password: json['password'] as String?,
  isAdmin: json['isAdmin'] as bool,
  subscriptionExpiry: (json['subscriptionExpiry'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'id': instance.id,
  'password': instance.password,
  'isAdmin': instance.isAdmin,
  'subscriptionExpiry': instance.subscriptionExpiry,
};
