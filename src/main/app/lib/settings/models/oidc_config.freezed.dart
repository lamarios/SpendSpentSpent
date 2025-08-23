// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oidc_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OidcConfig {

@JsonKey(name: "authorization_endpoint") String get authorizationEndpoint;@JsonKey(name: "jwks_uri") String get jwksUri; String get issuer;@JsonKey(name: "token_endpoint") String get tokenUrl; String get clientId; String get discoveryUrl; String get name;
/// Create a copy of OidcConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OidcConfigCopyWith<OidcConfig> get copyWith => _$OidcConfigCopyWithImpl<OidcConfig>(this as OidcConfig, _$identity);

  /// Serializes this OidcConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OidcConfig&&(identical(other.authorizationEndpoint, authorizationEndpoint) || other.authorizationEndpoint == authorizationEndpoint)&&(identical(other.jwksUri, jwksUri) || other.jwksUri == jwksUri)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.tokenUrl, tokenUrl) || other.tokenUrl == tokenUrl)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.discoveryUrl, discoveryUrl) || other.discoveryUrl == discoveryUrl)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authorizationEndpoint,jwksUri,issuer,tokenUrl,clientId,discoveryUrl,name);

@override
String toString() {
  return 'OidcConfig(authorizationEndpoint: $authorizationEndpoint, jwksUri: $jwksUri, issuer: $issuer, tokenUrl: $tokenUrl, clientId: $clientId, discoveryUrl: $discoveryUrl, name: $name)';
}


}

/// @nodoc
abstract mixin class $OidcConfigCopyWith<$Res>  {
  factory $OidcConfigCopyWith(OidcConfig value, $Res Function(OidcConfig) _then) = _$OidcConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "authorization_endpoint") String authorizationEndpoint,@JsonKey(name: "jwks_uri") String jwksUri, String issuer,@JsonKey(name: "token_endpoint") String tokenUrl, String clientId, String discoveryUrl, String name
});




}
/// @nodoc
class _$OidcConfigCopyWithImpl<$Res>
    implements $OidcConfigCopyWith<$Res> {
  _$OidcConfigCopyWithImpl(this._self, this._then);

  final OidcConfig _self;
  final $Res Function(OidcConfig) _then;

/// Create a copy of OidcConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorizationEndpoint = null,Object? jwksUri = null,Object? issuer = null,Object? tokenUrl = null,Object? clientId = null,Object? discoveryUrl = null,Object? name = null,}) {
  return _then(_self.copyWith(
authorizationEndpoint: null == authorizationEndpoint ? _self.authorizationEndpoint : authorizationEndpoint // ignore: cast_nullable_to_non_nullable
as String,jwksUri: null == jwksUri ? _self.jwksUri : jwksUri // ignore: cast_nullable_to_non_nullable
as String,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String,tokenUrl: null == tokenUrl ? _self.tokenUrl : tokenUrl // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,discoveryUrl: null == discoveryUrl ? _self.discoveryUrl : discoveryUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OidcConfig].
extension OidcConfigPatterns on OidcConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OidcConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OidcConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OidcConfig value)  $default,){
final _that = this;
switch (_that) {
case _OidcConfig():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OidcConfig value)?  $default,){
final _that = this;
switch (_that) {
case _OidcConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "authorization_endpoint")  String authorizationEndpoint, @JsonKey(name: "jwks_uri")  String jwksUri,  String issuer, @JsonKey(name: "token_endpoint")  String tokenUrl,  String clientId,  String discoveryUrl,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OidcConfig() when $default != null:
return $default(_that.authorizationEndpoint,_that.jwksUri,_that.issuer,_that.tokenUrl,_that.clientId,_that.discoveryUrl,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "authorization_endpoint")  String authorizationEndpoint, @JsonKey(name: "jwks_uri")  String jwksUri,  String issuer, @JsonKey(name: "token_endpoint")  String tokenUrl,  String clientId,  String discoveryUrl,  String name)  $default,) {final _that = this;
switch (_that) {
case _OidcConfig():
return $default(_that.authorizationEndpoint,_that.jwksUri,_that.issuer,_that.tokenUrl,_that.clientId,_that.discoveryUrl,_that.name);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "authorization_endpoint")  String authorizationEndpoint, @JsonKey(name: "jwks_uri")  String jwksUri,  String issuer, @JsonKey(name: "token_endpoint")  String tokenUrl,  String clientId,  String discoveryUrl,  String name)?  $default,) {final _that = this;
switch (_that) {
case _OidcConfig() when $default != null:
return $default(_that.authorizationEndpoint,_that.jwksUri,_that.issuer,_that.tokenUrl,_that.clientId,_that.discoveryUrl,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OidcConfig implements OidcConfig {
  const _OidcConfig({@JsonKey(name: "authorization_endpoint") required this.authorizationEndpoint, @JsonKey(name: "jwks_uri") required this.jwksUri, required this.issuer, @JsonKey(name: "token_endpoint") required this.tokenUrl, required this.clientId, required this.discoveryUrl, required this.name});
  factory _OidcConfig.fromJson(Map<String, dynamic> json) => _$OidcConfigFromJson(json);

@override@JsonKey(name: "authorization_endpoint") final  String authorizationEndpoint;
@override@JsonKey(name: "jwks_uri") final  String jwksUri;
@override final  String issuer;
@override@JsonKey(name: "token_endpoint") final  String tokenUrl;
@override final  String clientId;
@override final  String discoveryUrl;
@override final  String name;

/// Create a copy of OidcConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OidcConfigCopyWith<_OidcConfig> get copyWith => __$OidcConfigCopyWithImpl<_OidcConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OidcConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OidcConfig&&(identical(other.authorizationEndpoint, authorizationEndpoint) || other.authorizationEndpoint == authorizationEndpoint)&&(identical(other.jwksUri, jwksUri) || other.jwksUri == jwksUri)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.tokenUrl, tokenUrl) || other.tokenUrl == tokenUrl)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.discoveryUrl, discoveryUrl) || other.discoveryUrl == discoveryUrl)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authorizationEndpoint,jwksUri,issuer,tokenUrl,clientId,discoveryUrl,name);

@override
String toString() {
  return 'OidcConfig(authorizationEndpoint: $authorizationEndpoint, jwksUri: $jwksUri, issuer: $issuer, tokenUrl: $tokenUrl, clientId: $clientId, discoveryUrl: $discoveryUrl, name: $name)';
}


}

/// @nodoc
abstract mixin class _$OidcConfigCopyWith<$Res> implements $OidcConfigCopyWith<$Res> {
  factory _$OidcConfigCopyWith(_OidcConfig value, $Res Function(_OidcConfig) _then) = __$OidcConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "authorization_endpoint") String authorizationEndpoint,@JsonKey(name: "jwks_uri") String jwksUri, String issuer,@JsonKey(name: "token_endpoint") String tokenUrl, String clientId, String discoveryUrl, String name
});




}
/// @nodoc
class __$OidcConfigCopyWithImpl<$Res>
    implements _$OidcConfigCopyWith<$Res> {
  __$OidcConfigCopyWithImpl(this._self, this._then);

  final _OidcConfig _self;
  final $Res Function(_OidcConfig) _then;

/// Create a copy of OidcConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorizationEndpoint = null,Object? jwksUri = null,Object? issuer = null,Object? tokenUrl = null,Object? clientId = null,Object? discoveryUrl = null,Object? name = null,}) {
  return _then(_OidcConfig(
authorizationEndpoint: null == authorizationEndpoint ? _self.authorizationEndpoint : authorizationEndpoint // ignore: cast_nullable_to_non_nullable
as String,jwksUri: null == jwksUri ? _self.jwksUri : jwksUri // ignore: cast_nullable_to_non_nullable
as String,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String,tokenUrl: null == tokenUrl ? _self.tokenUrl : tokenUrl // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,discoveryUrl: null == discoveryUrl ? _self.discoveryUrl : discoveryUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
