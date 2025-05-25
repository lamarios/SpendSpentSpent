// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettingsState {
  bool get materialYou;
  bool get blackBackground;

  /// Create a copy of AppSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppSettingsStateCopyWith<AppSettingsState> get copyWith =>
      _$AppSettingsStateCopyWithImpl<AppSettingsState>(
          this as AppSettingsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppSettingsState &&
            (identical(other.materialYou, materialYou) ||
                other.materialYou == materialYou) &&
            (identical(other.blackBackground, blackBackground) ||
                other.blackBackground == blackBackground));
  }

  @override
  int get hashCode => Object.hash(runtimeType, materialYou, blackBackground);

  @override
  String toString() {
    return 'AppSettingsState(materialYou: $materialYou, blackBackground: $blackBackground)';
  }
}

/// @nodoc
abstract mixin class $AppSettingsStateCopyWith<$Res> {
  factory $AppSettingsStateCopyWith(
          AppSettingsState value, $Res Function(AppSettingsState) _then) =
      _$AppSettingsStateCopyWithImpl;
  @useResult
  $Res call({bool materialYou, bool blackBackground});
}

/// @nodoc
class _$AppSettingsStateCopyWithImpl<$Res>
    implements $AppSettingsStateCopyWith<$Res> {
  _$AppSettingsStateCopyWithImpl(this._self, this._then);

  final AppSettingsState _self;
  final $Res Function(AppSettingsState) _then;

  /// Create a copy of AppSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? materialYou = null,
    Object? blackBackground = null,
  }) {
    return _then(_self.copyWith(
      materialYou: null == materialYou
          ? _self.materialYou
          : materialYou // ignore: cast_nullable_to_non_nullable
              as bool,
      blackBackground: null == blackBackground
          ? _self.blackBackground
          : blackBackground // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _AppSettingsState implements AppSettingsState {
  const _AppSettingsState(
      {this.materialYou = false, this.blackBackground = false});

  @override
  @JsonKey()
  final bool materialYou;
  @override
  @JsonKey()
  final bool blackBackground;

  /// Create a copy of AppSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppSettingsStateCopyWith<_AppSettingsState> get copyWith =>
      __$AppSettingsStateCopyWithImpl<_AppSettingsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppSettingsState &&
            (identical(other.materialYou, materialYou) ||
                other.materialYou == materialYou) &&
            (identical(other.blackBackground, blackBackground) ||
                other.blackBackground == blackBackground));
  }

  @override
  int get hashCode => Object.hash(runtimeType, materialYou, blackBackground);

  @override
  String toString() {
    return 'AppSettingsState(materialYou: $materialYou, blackBackground: $blackBackground)';
  }
}

/// @nodoc
abstract mixin class _$AppSettingsStateCopyWith<$Res>
    implements $AppSettingsStateCopyWith<$Res> {
  factory _$AppSettingsStateCopyWith(
          _AppSettingsState value, $Res Function(_AppSettingsState) _then) =
      __$AppSettingsStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool materialYou, bool blackBackground});
}

/// @nodoc
class __$AppSettingsStateCopyWithImpl<$Res>
    implements _$AppSettingsStateCopyWith<$Res> {
  __$AppSettingsStateCopyWithImpl(this._self, this._then);

  final _AppSettingsState _self;
  final $Res Function(_AppSettingsState) _then;

  /// Create a copy of AppSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? materialYou = null,
    Object? blackBackground = null,
  }) {
    return _then(_AppSettingsState(
      materialYou: null == materialYou
          ? _self.materialYou
          : materialYou // ignore: cast_nullable_to_non_nullable
              as bool,
      blackBackground: null == blackBackground
          ? _self.blackBackground
          : blackBackground // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
