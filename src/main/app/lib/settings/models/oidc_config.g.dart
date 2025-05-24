// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OidcConfig _$OidcConfigFromJson(Map<String, dynamic> json) => _OidcConfig(
      authorizationEndpoint: json['authorization_endpoint'] as String,
      jwksUri: json['jwks_uri'] as String,
      issuer: json['issuer'] as String,
      tokenUrl: json['token_endpoint'] as String,
    );

Map<String, dynamic> _$OidcConfigToJson(_OidcConfig instance) =>
    <String, dynamic>{
      'authorization_endpoint': instance.authorizationEndpoint,
      'jwks_uri': instance.jwksUri,
      'issuer': instance.issuer,
      'token_endpoint': instance.tokenUrl,
    };
