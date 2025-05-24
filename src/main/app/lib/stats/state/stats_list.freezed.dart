// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatsListState {
  bool get loading;
  List<LeftColumnStats> get stats;
  dynamic get error;
  StackTrace? get stackTrace;

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatsListStateCopyWith<StatsListState> get copyWith =>
      _$StatsListStateCopyWithImpl<StatsListState>(
          this as StatsListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatsListState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.stats, stats) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(stats),
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'StatsListState(loading: $loading, stats: $stats, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $StatsListStateCopyWith<$Res> {
  factory $StatsListStateCopyWith(
          StatsListState value, $Res Function(StatsListState) _then) =
      _$StatsListStateCopyWithImpl;
  @useResult
  $Res call(
      {bool loading,
      List<LeftColumnStats> stats,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class _$StatsListStateCopyWithImpl<$Res>
    implements $StatsListStateCopyWith<$Res> {
  _$StatsListStateCopyWithImpl(this._self, this._then);

  final StatsListState _self;
  final $Res Function(StatsListState) _then;

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? stats = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      stats: null == stats
          ? _self.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<LeftColumnStats>,
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
}

/// @nodoc

class _StatsListState implements StatsListState, WithError {
  const _StatsListState(
      {this.loading = false,
      final List<LeftColumnStats> stats = const [],
      this.error,
      this.stackTrace})
      : _stats = stats;

  @override
  @JsonKey()
  final bool loading;
  final List<LeftColumnStats> _stats;
  @override
  @JsonKey()
  List<LeftColumnStats> get stats {
    if (_stats is EqualUnmodifiableListView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stats);
  }

  @override
  final dynamic error;
  @override
  final StackTrace? stackTrace;

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatsListStateCopyWith<_StatsListState> get copyWith =>
      __$StatsListStateCopyWithImpl<_StatsListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatsListState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._stats, _stats) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(_stats),
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'StatsListState(loading: $loading, stats: $stats, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$StatsListStateCopyWith<$Res>
    implements $StatsListStateCopyWith<$Res> {
  factory _$StatsListStateCopyWith(
          _StatsListState value, $Res Function(_StatsListState) _then) =
      __$StatsListStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool loading,
      List<LeftColumnStats> stats,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class __$StatsListStateCopyWithImpl<$Res>
    implements _$StatsListStateCopyWith<$Res> {
  __$StatsListStateCopyWithImpl(this._self, this._then);

  final _StatsListState _self;
  final $Res Function(_StatsListState) _then;

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? stats = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_StatsListState(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      stats: null == stats
          ? _self._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<LeftColumnStats>,
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
}

// dart format on
