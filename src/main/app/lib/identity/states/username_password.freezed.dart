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
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token);

  @override
  String toString() {
    return 'UsernamePasswordState(token: $token)';
  }
}

/// @nodoc
abstract mixin class $UsernamePasswordStateCopyWith<$Res> {
  factory $UsernamePasswordStateCopyWith(UsernamePasswordState value,
          $Res Function(UsernamePasswordState) _then) =
      _$UsernamePasswordStateCopyWithImpl;
  @useResult
  $Res call({String? token});
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
  }) {
    return _then(_self.copyWith(
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _UsernamePasswordState implements UsernamePasswordState {
  const _UsernamePasswordState({this.token});

  @override
  final String? token;

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
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token);

  @override
  String toString() {
    return 'UsernamePasswordState(token: $token)';
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
  $Res call({String? token});
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
  }) {
    return _then(_UsernamePasswordState(
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
