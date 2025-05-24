// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oidc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OidcState implements DiagnosticableTreeMixin {
  String? get token;
  OidcConfig? get oidcConfig;
  OidcUser? get user;

  /// Create a copy of OidcState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OidcStateCopyWith<OidcState> get copyWith =>
      _$OidcStateCopyWithImpl<OidcState>(this as OidcState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'OidcState'))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('oidcConfig', oidcConfig))
      ..add(DiagnosticsProperty('user', user));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OidcState &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.oidcConfig, oidcConfig) ||
                other.oidcConfig == oidcConfig) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, oidcConfig, user);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OidcState(token: $token, oidcConfig: $oidcConfig, user: $user)';
  }
}

/// @nodoc
abstract mixin class $OidcStateCopyWith<$Res> {
  factory $OidcStateCopyWith(OidcState value, $Res Function(OidcState) _then) =
      _$OidcStateCopyWithImpl;
  @useResult
  $Res call({String? token, OidcConfig? oidcConfig, OidcUser? user});

  $OidcConfigCopyWith<$Res>? get oidcConfig;
}

/// @nodoc
class _$OidcStateCopyWithImpl<$Res> implements $OidcStateCopyWith<$Res> {
  _$OidcStateCopyWithImpl(this._self, this._then);

  final OidcState _self;
  final $Res Function(OidcState) _then;

  /// Create a copy of OidcState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? oidcConfig = freezed,
    Object? user = freezed,
  }) {
    return _then(_self.copyWith(
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      oidcConfig: freezed == oidcConfig
          ? _self.oidcConfig
          : oidcConfig // ignore: cast_nullable_to_non_nullable
              as OidcConfig?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as OidcUser?,
    ));
  }

  /// Create a copy of OidcState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OidcConfigCopyWith<$Res>? get oidcConfig {
    if (_self.oidcConfig == null) {
      return null;
    }

    return $OidcConfigCopyWith<$Res>(_self.oidcConfig!, (value) {
      return _then(_self.copyWith(oidcConfig: value));
    });
  }
}

/// @nodoc

class _OidcState with DiagnosticableTreeMixin implements OidcState {
  const _OidcState({this.token, this.oidcConfig, this.user});

  @override
  final String? token;
  @override
  final OidcConfig? oidcConfig;
  @override
  final OidcUser? user;

  /// Create a copy of OidcState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OidcStateCopyWith<_OidcState> get copyWith =>
      __$OidcStateCopyWithImpl<_OidcState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'OidcState'))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('oidcConfig', oidcConfig))
      ..add(DiagnosticsProperty('user', user));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OidcState &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.oidcConfig, oidcConfig) ||
                other.oidcConfig == oidcConfig) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, oidcConfig, user);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OidcState(token: $token, oidcConfig: $oidcConfig, user: $user)';
  }
}

/// @nodoc
abstract mixin class _$OidcStateCopyWith<$Res>
    implements $OidcStateCopyWith<$Res> {
  factory _$OidcStateCopyWith(
          _OidcState value, $Res Function(_OidcState) _then) =
      __$OidcStateCopyWithImpl;
  @override
  @useResult
  $Res call({String? token, OidcConfig? oidcConfig, OidcUser? user});

  @override
  $OidcConfigCopyWith<$Res>? get oidcConfig;
}

/// @nodoc
class __$OidcStateCopyWithImpl<$Res> implements _$OidcStateCopyWith<$Res> {
  __$OidcStateCopyWithImpl(this._self, this._then);

  final _OidcState _self;
  final $Res Function(_OidcState) _then;

  /// Create a copy of OidcState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = freezed,
    Object? oidcConfig = freezed,
    Object? user = freezed,
  }) {
    return _then(_OidcState(
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      oidcConfig: freezed == oidcConfig
          ? _self.oidcConfig
          : oidcConfig // ignore: cast_nullable_to_non_nullable
              as OidcConfig?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as OidcUser?,
    ));
  }

  /// Create a copy of OidcState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OidcConfigCopyWith<$Res>? get oidcConfig {
    if (_self.oidcConfig == null) {
      return null;
    }

    return $OidcConfigCopyWith<$Res>(_self.oidcConfig!, (value) {
      return _then(_self.copyWith(oidcConfig: value));
    });
  }
}

// dart format on
