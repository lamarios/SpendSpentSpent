import 'package:freezed_annotation/freezed_annotation.dart';

part 'oidc_config.freezed.dart';

part 'oidc_config.g.dart';

@freezed
sealed class OidcConfig with _$OidcConfig {
  const factory OidcConfig(
      {@JsonKey(name: "authorization_endpoint")
      required String authorizationEndpoint,
      @JsonKey(name: "jwks_uri") required String jwksUri,
      required String issuer,
      @JsonKey(name: "token_endpoint") required String tokenUrl}) = _OidcConfig;

  factory OidcConfig.fromJson(Map<String, Object?> json) =>
      _$OidcConfigFromJson(json);
}
