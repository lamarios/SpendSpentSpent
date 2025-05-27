// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'username_password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsernamePasswordState {
  String? get token;
  OidcConfig? get oidcConfig;

  /// Create a copy of UsernamePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsernamePasswordStateCopyWith<UsernamePasswordState> get copyWith =>
      _$UsernamePasswordStateCopyWithImpl<UsernamePasswordState>(
          this as UsernamePasswordState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsernamePasswordState &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.oidcConfig, oidcConfig) ||
                other.oidcConfig == oidcConfig));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, oidcConfig);

  @override
  String toString() {
    return 'UsernamePasswordState(token: $token, oidcConfig: $oidcConfig)';
  }
}

/// @nodoc
abstract mixin class $UsernamePasswordStateCopyWith<$Res> {
  factory $UsernamePasswordStateCopyWith(UsernamePasswordState value,
          $Res Function(UsernamePasswordState) _then) =
      _$UsernamePasswordStateCopyWithImpl;
  @useResult
  $Res call({String? token, OidcConfig? oidcConfig});

  $OidcConfigCopyWith<$Res>? get oidcConfig;
}

/// @nodoc
class _$UsernamePasswordStateCopyWithImpl<$Res>
    implements $UsernamePasswordStateCopyWith<$Res> {
  _$UsernamePasswordStateCopyWithImpl(this._self, this._then);

  final UsernamePasswordState _self;
  final $Res Function(UsernamePasswordState) _then;

  /// Create a copy of UsernamePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? oidcConfig = freezed,
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
    ));
  }

  /// Create a copy of UsernamePasswordState
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

class _UsernamePasswordState implements UsernamePasswordState {
  const _UsernamePasswordState({this.token, this.oidcConfig});

  @override
  final String? token;
  @override
  final OidcConfig? oidcConfig;

  /// Create a copy of UsernamePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsernamePasswordStateCopyWith<_UsernamePasswordState> get copyWith =>
      __$UsernamePasswordStateCopyWithImpl<_UsernamePasswordState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsernamePasswordState &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.oidcConfig, oidcConfig) ||
                other.oidcConfig == oidcConfig));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, oidcConfig);

  @override
  String toString() {
    return 'UsernamePasswordState(token: $token, oidcConfig: $oidcConfig)';
  }
}

/// @nodoc
abstract mixin class _$UsernamePasswordStateCopyWith<$Res>
    implements $UsernamePasswordStateCopyWith<$Res> {
  factory _$UsernamePasswordStateCopyWith(_UsernamePasswordState value,
          $Res Function(_UsernamePasswordState) _then) =
      __$UsernamePasswordStateCopyWithImpl;
  @override
  @useResult
  $Res call({String? token, OidcConfig? oidcConfig});

  @override
  $OidcConfigCopyWith<$Res>? get oidcConfig;
}

/// @nodoc
class __$UsernamePasswordStateCopyWithImpl<$Res>
    implements _$UsernamePasswordStateCopyWith<$Res> {
  __$UsernamePasswordStateCopyWithImpl(this._self, this._then);

  final _UsernamePasswordState _self;
  final $Res Function(_UsernamePasswordState) _then;

  /// Create a copy of UsernamePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = freezed,
    Object? oidcConfig = freezed,
  }) {
    return _then(_UsernamePasswordState(
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      oidcConfig: freezed == oidcConfig
          ? _self.oidcConfig
          : oidcConfig // ignore: cast_nullable_to_non_nullable
              as OidcConfig?,
    ));
  }

  /// Create a copy of UsernamePasswordState
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
