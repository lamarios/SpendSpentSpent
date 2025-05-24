// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OidcState _$OidcStateFromJson(Map<String, dynamic> json) => _OidcState(
      token: json['token'] as String?,
      oidcConfig: json['oidcConfig'] == null
          ? null
          : OidcConfig.fromJson(json['oidcConfig'] as Map<String, dynamic>),
      clientId: json['clientId'] as String?,
    );

Map<String, dynamic> _$OidcStateToJson(_OidcState instance) =>
    <String, dynamic>{
      'token': instance.token,
      'oidcConfig': instance.oidcConfig,
      'clientId': instance.clientId,
    };
