// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'single_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SingleStatsState {
  bool get open;
  bool get showGraph;

  /// Create a copy of SingleStatsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SingleStatsStateCopyWith<SingleStatsState> get copyWith =>
      _$SingleStatsStateCopyWithImpl<SingleStatsState>(
          this as SingleStatsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SingleStatsState &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.showGraph, showGraph) ||
                other.showGraph == showGraph));
  }

  @override
  int get hashCode => Object.hash(runtimeType, open, showGraph);

  @override
  String toString() {
    return 'SingleStatsState(open: $open, showGraph: $showGraph)';
  }
}

/// @nodoc
abstract mixin class $SingleStatsStateCopyWith<$Res> {
  factory $SingleStatsStateCopyWith(
          SingleStatsState value, $Res Function(SingleStatsState) _then) =
      _$SingleStatsStateCopyWithImpl;
  @useResult
  $Res call({bool open, bool showGraph});
}

/// @nodoc
class _$SingleStatsStateCopyWithImpl<$Res>
    implements $SingleStatsStateCopyWith<$Res> {
  _$SingleStatsStateCopyWithImpl(this._self, this._then);

  final SingleStatsState _self;
  final $Res Function(SingleStatsState) _then;

  /// Create a copy of SingleStatsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? showGraph = null,
  }) {
    return _then(_self.copyWith(
      open: null == open
          ? _self.open
          : open // ignore: cast_nullable_to_non_nullable
              as bool,
      showGraph: null == showGraph
          ? _self.showGraph
          : showGraph // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _SingleStatsState implements SingleStatsState {
  const _SingleStatsState({this.open = false, this.showGraph = false});

  @override
  @JsonKey()
  final bool open;
  @override
  @JsonKey()
  final bool showGraph;

  /// Create a copy of SingleStatsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SingleStatsStateCopyWith<_SingleStatsState> get copyWith =>
      __$SingleStatsStateCopyWithImpl<_SingleStatsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SingleStatsState &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.showGraph, showGraph) ||
                other.showGraph == showGraph));
  }

  @override
  int get hashCode => Object.hash(runtimeType, open, showGraph);

  @override
  String toString() {
    return 'SingleStatsState(open: $open, showGraph: $showGraph)';
  }
}

/// @nodoc
abstract mixin class _$SingleStatsStateCopyWith<$Res>
    implements $SingleStatsStateCopyWith<$Res> {
  factory _$SingleStatsStateCopyWith(
          _SingleStatsState value, $Res Function(_SingleStatsState) _then) =
      __$SingleStatsStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool open, bool showGraph});
}

/// @nodoc
class __$SingleStatsStateCopyWithImpl<$Res>
    implements _$SingleStatsStateCopyWith<$Res> {
  __$SingleStatsStateCopyWithImpl(this._self, this._then);

  final _SingleStatsState _self;
  final $Res Function(_SingleStatsState) _then;

  /// Create a copy of SingleStatsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? open = null,
    Object? showGraph = null,
  }) {
    return _then(_SingleStatsState(
      open: null == open
          ? _self.open
          : open // ignore: cast_nullable_to_non_nullable
              as bool,
      showGraph: null == showGraph
          ? _self.showGraph
          : showGraph // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
