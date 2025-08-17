// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// Adds pattern-matching-related methods to [StatsListState].
extension StatsListStatePatterns on StatsListState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StatsListState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatsListState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StatsListState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatsListState():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StatsListState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatsListState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool loading, List<LeftColumnStats> stats, dynamic error,
            StackTrace? stackTrace)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatsListState() when $default != null:
        return $default(
            _that.loading, _that.stats, _that.error, _that.stackTrace);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool loading, List<LeftColumnStats> stats, dynamic error,
            StackTrace? stackTrace)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatsListState():
        return $default(
            _that.loading, _that.stats, _that.error, _that.stackTrace);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool loading, List<LeftColumnStats> stats, dynamic error,
            StackTrace? stackTrace)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatsListState() when $default != null:
        return $default(
            _that.loading, _that.stats, _that.error, _that.stackTrace);
      case _:
        return null;
    }
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
