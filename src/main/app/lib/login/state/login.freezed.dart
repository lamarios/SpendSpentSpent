// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginState implements DiagnosticableTreeMixin {
  Config? get config;
  String get loginError;
  LoginPage get page;
  dynamic get error;
  StackTrace? get stackTrace;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginStateCopyWith<LoginState> get copyWith =>
      _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LoginState'))
      ..add(DiagnosticsProperty('config', config))
      ..add(DiagnosticsProperty('loginError', loginError))
      ..add(DiagnosticsProperty('page', page))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('stackTrace', stackTrace));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginState &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.loginError, loginError) ||
                other.loginError == loginError) &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config, loginError, page,
      const DeepCollectionEquality().hash(error), stackTrace);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginState(config: $config, loginError: $loginError, page: $page, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
          LoginState value, $Res Function(LoginState) _then) =
      _$LoginStateCopyWithImpl;
  @useResult
  $Res call(
      {Config? config,
      String loginError,
      LoginPage page,
      dynamic error,
      StackTrace? stackTrace});

  $ConfigCopyWith<$Res>? get config;
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res> implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = freezed,
    Object? loginError = null,
    Object? page = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_self.copyWith(
      config: freezed == config
          ? _self.config
          : config // ignore: cast_nullable_to_non_nullable
              as Config?,
      loginError: null == loginError
          ? _self.loginError
          : loginError // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as LoginPage,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigCopyWith<$Res>? get config {
    if (_self.config == null) {
      return null;
    }

    return $ConfigCopyWith<$Res>(_self.config!, (value) {
      return _then(_self.copyWith(config: value));
    });
  }
}

/// @nodoc

class _LoginState
    with DiagnosticableTreeMixin
    implements LoginState, WithError {
  const _LoginState(
      {this.config,
      this.loginError = '',
      this.page = LoginPage.login,
      this.error,
      this.stackTrace});

  @override
  final Config? config;
  @override
  @JsonKey()
  final String loginError;
  @override
  @JsonKey()
  final LoginPage page;
  @override
  final dynamic error;
  @override
  final StackTrace? stackTrace;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginStateCopyWith<_LoginState> get copyWith =>
      __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LoginState'))
      ..add(DiagnosticsProperty('config', config))
      ..add(DiagnosticsProperty('loginError', loginError))
      ..add(DiagnosticsProperty('page', page))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('stackTrace', stackTrace));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginState &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.loginError, loginError) ||
                other.loginError == loginError) &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, config, loginError, page,
      const DeepCollectionEquality().hash(error), stackTrace);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginState(config: $config, loginError: $loginError, page: $page, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(
          _LoginState value, $Res Function(_LoginState) _then) =
      __$LoginStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Config? config,
      String loginError,
      LoginPage page,
      dynamic error,
      StackTrace? stackTrace});

  @override
  $ConfigCopyWith<$Res>? get config;
}

/// @nodoc
class __$LoginStateCopyWithImpl<$Res> implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? config = freezed,
    Object? loginError = null,
    Object? page = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_LoginState(
      config: freezed == config
          ? _self.config
          : config // ignore: cast_nullable_to_non_nullable
              as Config?,
      loginError: null == loginError
          ? _self.loginError
          : loginError // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as LoginPage,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigCopyWith<$Res>? get config {
    if (_self.config == null) {
      return null;
    }

    return $ConfigCopyWith<$Res>(_self.config!, (value) {
      return _then(_self.copyWith(config: value));
    });
  }
}

// dart format on
