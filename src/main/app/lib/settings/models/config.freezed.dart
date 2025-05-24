// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Config {
  bool get allowSignup;
  bool get canResetPassword;
  bool get demoMode;
  bool get hasSubscription;
  bool get canConvertCurrency;
  String get announcement;
  String get convertCurrencyQuota;
  String? get minAppVersion;
  int get backendVersion;
  OidcConfig? get oidc;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfigCopyWith<Config> get copyWith =>
      _$ConfigCopyWithImpl<Config>(this as Config, _$identity);

  /// Serializes this Config to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Config &&
            (identical(other.allowSignup, allowSignup) ||
                other.allowSignup == allowSignup) &&
            (identical(other.canResetPassword, canResetPassword) ||
                other.canResetPassword == canResetPassword) &&
            (identical(other.demoMode, demoMode) ||
                other.demoMode == demoMode) &&
            (identical(other.hasSubscription, hasSubscription) ||
                other.hasSubscription == hasSubscription) &&
            (identical(other.canConvertCurrency, canConvertCurrency) ||
                other.canConvertCurrency == canConvertCurrency) &&
            (identical(other.announcement, announcement) ||
                other.announcement == announcement) &&
            (identical(other.convertCurrencyQuota, convertCurrencyQuota) ||
                other.convertCurrencyQuota == convertCurrencyQuota) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.backendVersion, backendVersion) ||
                other.backendVersion == backendVersion) &&
            (identical(other.oidc, oidc) || other.oidc == oidc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      allowSignup,
      canResetPassword,
      demoMode,
      hasSubscription,
      canConvertCurrency,
      announcement,
      convertCurrencyQuota,
      minAppVersion,
      backendVersion,
      oidc);

  @override
  String toString() {
    return 'Config(allowSignup: $allowSignup, canResetPassword: $canResetPassword, demoMode: $demoMode, hasSubscription: $hasSubscription, canConvertCurrency: $canConvertCurrency, announcement: $announcement, convertCurrencyQuota: $convertCurrencyQuota, minAppVersion: $minAppVersion, backendVersion: $backendVersion, oidc: $oidc)';
  }
}

/// @nodoc
abstract mixin class $ConfigCopyWith<$Res> {
  factory $ConfigCopyWith(Config value, $Res Function(Config) _then) =
      _$ConfigCopyWithImpl;
  @useResult
  $Res call(
      {bool allowSignup,
      bool canResetPassword,
      bool demoMode,
      bool hasSubscription,
      bool canConvertCurrency,
      String announcement,
      String convertCurrencyQuota,
      String? minAppVersion,
      int backendVersion,
      OidcConfig? oidc});

  $OidcConfigCopyWith<$Res>? get oidc;
}

/// @nodoc
class _$ConfigCopyWithImpl<$Res> implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._self, this._then);

  final Config _self;
  final $Res Function(Config) _then;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowSignup = null,
    Object? canResetPassword = null,
    Object? demoMode = null,
    Object? hasSubscription = null,
    Object? canConvertCurrency = null,
    Object? announcement = null,
    Object? convertCurrencyQuota = null,
    Object? minAppVersion = freezed,
    Object? backendVersion = null,
    Object? oidc = freezed,
  }) {
    return _then(_self.copyWith(
      allowSignup: null == allowSignup
          ? _self.allowSignup
          : allowSignup // ignore: cast_nullable_to_non_nullable
              as bool,
      canResetPassword: null == canResetPassword
          ? _self.canResetPassword
          : canResetPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      demoMode: null == demoMode
          ? _self.demoMode
          : demoMode // ignore: cast_nullable_to_non_nullable
              as bool,
      hasSubscription: null == hasSubscription
          ? _self.hasSubscription
          : hasSubscription // ignore: cast_nullable_to_non_nullable
              as bool,
      canConvertCurrency: null == canConvertCurrency
          ? _self.canConvertCurrency
          : canConvertCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      announcement: null == announcement
          ? _self.announcement
          : announcement // ignore: cast_nullable_to_non_nullable
              as String,
      convertCurrencyQuota: null == convertCurrencyQuota
          ? _self.convertCurrencyQuota
          : convertCurrencyQuota // ignore: cast_nullable_to_non_nullable
              as String,
      minAppVersion: freezed == minAppVersion
          ? _self.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      backendVersion: null == backendVersion
          ? _self.backendVersion
          : backendVersion // ignore: cast_nullable_to_non_nullable
              as int,
      oidc: freezed == oidc
          ? _self.oidc
          : oidc // ignore: cast_nullable_to_non_nullable
              as OidcConfig?,
    ));
  }

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OidcConfigCopyWith<$Res>? get oidc {
    if (_self.oidc == null) {
      return null;
    }

    return $OidcConfigCopyWith<$Res>(_self.oidc!, (value) {
      return _then(_self.copyWith(oidc: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Config implements Config {
  const _Config(
      {required this.allowSignup,
      required this.canResetPassword,
      required this.demoMode,
      required this.hasSubscription,
      required this.canConvertCurrency,
      required this.announcement,
      required this.convertCurrencyQuota,
      this.minAppVersion,
      required this.backendVersion,
      this.oidc});
  factory _Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  @override
  final bool allowSignup;
  @override
  final bool canResetPassword;
  @override
  final bool demoMode;
  @override
  final bool hasSubscription;
  @override
  final bool canConvertCurrency;
  @override
  final String announcement;
  @override
  final String convertCurrencyQuota;
  @override
  final String? minAppVersion;
  @override
  final int backendVersion;
  @override
  final OidcConfig? oidc;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfigCopyWith<_Config> get copyWith =>
      __$ConfigCopyWithImpl<_Config>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Config &&
            (identical(other.allowSignup, allowSignup) ||
                other.allowSignup == allowSignup) &&
            (identical(other.canResetPassword, canResetPassword) ||
                other.canResetPassword == canResetPassword) &&
            (identical(other.demoMode, demoMode) ||
                other.demoMode == demoMode) &&
            (identical(other.hasSubscription, hasSubscription) ||
                other.hasSubscription == hasSubscription) &&
            (identical(other.canConvertCurrency, canConvertCurrency) ||
                other.canConvertCurrency == canConvertCurrency) &&
            (identical(other.announcement, announcement) ||
                other.announcement == announcement) &&
            (identical(other.convertCurrencyQuota, convertCurrencyQuota) ||
                other.convertCurrencyQuota == convertCurrencyQuota) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.backendVersion, backendVersion) ||
                other.backendVersion == backendVersion) &&
            (identical(other.oidc, oidc) || other.oidc == oidc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      allowSignup,
      canResetPassword,
      demoMode,
      hasSubscription,
      canConvertCurrency,
      announcement,
      convertCurrencyQuota,
      minAppVersion,
      backendVersion,
      oidc);

  @override
  String toString() {
    return 'Config(allowSignup: $allowSignup, canResetPassword: $canResetPassword, demoMode: $demoMode, hasSubscription: $hasSubscription, canConvertCurrency: $canConvertCurrency, announcement: $announcement, convertCurrencyQuota: $convertCurrencyQuota, minAppVersion: $minAppVersion, backendVersion: $backendVersion, oidc: $oidc)';
  }
}

/// @nodoc
abstract mixin class _$ConfigCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$ConfigCopyWith(_Config value, $Res Function(_Config) _then) =
      __$ConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool allowSignup,
      bool canResetPassword,
      bool demoMode,
      bool hasSubscription,
      bool canConvertCurrency,
      String announcement,
      String convertCurrencyQuota,
      String? minAppVersion,
      int backendVersion,
      OidcConfig? oidc});

  @override
  $OidcConfigCopyWith<$Res>? get oidc;
}

/// @nodoc
class __$ConfigCopyWithImpl<$Res> implements _$ConfigCopyWith<$Res> {
  __$ConfigCopyWithImpl(this._self, this._then);

  final _Config _self;
  final $Res Function(_Config) _then;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? allowSignup = null,
    Object? canResetPassword = null,
    Object? demoMode = null,
    Object? hasSubscription = null,
    Object? canConvertCurrency = null,
    Object? announcement = null,
    Object? convertCurrencyQuota = null,
    Object? minAppVersion = freezed,
    Object? backendVersion = null,
    Object? oidc = freezed,
  }) {
    return _then(_Config(
      allowSignup: null == allowSignup
          ? _self.allowSignup
          : allowSignup // ignore: cast_nullable_to_non_nullable
              as bool,
      canResetPassword: null == canResetPassword
          ? _self.canResetPassword
          : canResetPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      demoMode: null == demoMode
          ? _self.demoMode
          : demoMode // ignore: cast_nullable_to_non_nullable
              as bool,
      hasSubscription: null == hasSubscription
          ? _self.hasSubscription
          : hasSubscription // ignore: cast_nullable_to_non_nullable
              as bool,
      canConvertCurrency: null == canConvertCurrency
          ? _self.canConvertCurrency
          : canConvertCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      announcement: null == announcement
          ? _self.announcement
          : announcement // ignore: cast_nullable_to_non_nullable
              as String,
      convertCurrencyQuota: null == convertCurrencyQuota
          ? _self.convertCurrencyQuota
          : convertCurrencyQuota // ignore: cast_nullable_to_non_nullable
              as String,
      minAppVersion: freezed == minAppVersion
          ? _self.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      backendVersion: null == backendVersion
          ? _self.backendVersion
          : backendVersion // ignore: cast_nullable_to_non_nullable
              as int,
      oidc: freezed == oidc
          ? _self.oidc
          : oidc // ignore: cast_nullable_to_non_nullable
              as OidcConfig?,
    ));
  }

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OidcConfigCopyWith<$Res>? get oidc {
    if (_self.oidc == null) {
      return null;
    }

    return $OidcConfigCopyWith<$Res>(_self.oidc!, (value) {
      return _then(_self.copyWith(oidc: value));
    });
  }
}

// dart format on
