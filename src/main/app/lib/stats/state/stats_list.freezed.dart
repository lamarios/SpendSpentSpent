// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StatsListState {
  bool get loading => throw _privateConstructorUsedError;
  List<LeftColumnStats> get stats => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatsListStateCopyWith<StatsListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatsListStateCopyWith<$Res> {
  factory $StatsListStateCopyWith(
          StatsListState value, $Res Function(StatsListState) then) =
      _$StatsListStateCopyWithImpl<$Res, StatsListState>;
  @useResult
  $Res call(
      {bool loading,
      List<LeftColumnStats> stats,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class _$StatsListStateCopyWithImpl<$Res, $Val extends StatsListState>
    implements $StatsListStateCopyWith<$Res> {
  _$StatsListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<LeftColumnStats>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatsListStateImplCopyWith<$Res>
    implements $StatsListStateCopyWith<$Res> {
  factory _$$StatsListStateImplCopyWith(_$StatsListStateImpl value,
          $Res Function(_$StatsListStateImpl) then) =
      __$$StatsListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      List<LeftColumnStats> stats,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class __$$StatsListStateImplCopyWithImpl<$Res>
    extends _$StatsListStateCopyWithImpl<$Res, _$StatsListStateImpl>
    implements _$$StatsListStateImplCopyWith<$Res> {
  __$$StatsListStateImplCopyWithImpl(
      _$StatsListStateImpl _value, $Res Function(_$StatsListStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$StatsListStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      stats: null == stats
          ? _value._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as List<LeftColumnStats>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$StatsListStateImpl implements _StatsListState {
  const _$StatsListStateImpl(
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

  @override
  String toString() {
    return 'StatsListState(loading: $loading, stats: $stats, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatsListStateImpl &&
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

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatsListStateImplCopyWith<_$StatsListStateImpl> get copyWith =>
      __$$StatsListStateImplCopyWithImpl<_$StatsListStateImpl>(
          this, _$identity);
}

abstract class _StatsListState implements StatsListState, WithError {
  const factory _StatsListState(
      {final bool loading,
      final List<LeftColumnStats> stats,
      final dynamic error,
      final StackTrace? stackTrace}) = _$StatsListStateImpl;

  @override
  bool get loading;
  @override
  List<LeftColumnStats> get stats;
  @override
  dynamic get error;
  @override
  StackTrace? get stackTrace;

  /// Create a copy of StatsListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatsListStateImplCopyWith<_$StatsListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
