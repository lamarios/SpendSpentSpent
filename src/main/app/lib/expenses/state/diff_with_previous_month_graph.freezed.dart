// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diff_with_previous_month_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiffWithPreviousMonthGraphState {
  bool get loading;
  bool get includeRecurring;
  DateTimeRange get currentPeriod;
  List<List<FlSpot>> get spots;
  DateTimeRange get previousPeriod;

  /// Create a copy of DiffWithPreviousMonthGraphState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DiffWithPreviousMonthGraphStateCopyWith<DiffWithPreviousMonthGraphState>
      get copyWith => _$DiffWithPreviousMonthGraphStateCopyWithImpl<
              DiffWithPreviousMonthGraphState>(
          this as DiffWithPreviousMonthGraphState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DiffWithPreviousMonthGraphState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.includeRecurring, includeRecurring) ||
                other.includeRecurring == includeRecurring) &&
            (identical(other.currentPeriod, currentPeriod) ||
                other.currentPeriod == currentPeriod) &&
            const DeepCollectionEquality().equals(other.spots, spots) &&
            (identical(other.previousPeriod, previousPeriod) ||
                other.previousPeriod == previousPeriod));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      includeRecurring,
      currentPeriod,
      const DeepCollectionEquality().hash(spots),
      previousPeriod);

  @override
  String toString() {
    return 'DiffWithPreviousMonthGraphState(loading: $loading, includeRecurring: $includeRecurring, currentPeriod: $currentPeriod, spots: $spots, previousPeriod: $previousPeriod)';
  }
}

/// @nodoc
abstract mixin class $DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  factory $DiffWithPreviousMonthGraphStateCopyWith(
          DiffWithPreviousMonthGraphState value,
          $Res Function(DiffWithPreviousMonthGraphState) _then) =
      _$DiffWithPreviousMonthGraphStateCopyWithImpl;
  @useResult
  $Res call(
      {bool loading,
      bool includeRecurring,
      DateTimeRange currentPeriod,
      List<List<FlSpot>> spots,
      DateTimeRange previousPeriod});
}

/// @nodoc
class _$DiffWithPreviousMonthGraphStateCopyWithImpl<$Res>
    implements $DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  _$DiffWithPreviousMonthGraphStateCopyWithImpl(this._self, this._then);

  final DiffWithPreviousMonthGraphState _self;
  final $Res Function(DiffWithPreviousMonthGraphState) _then;

  /// Create a copy of DiffWithPreviousMonthGraphState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? includeRecurring = null,
    Object? currentPeriod = null,
    Object? spots = null,
    Object? previousPeriod = null,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      includeRecurring: null == includeRecurring
          ? _self.includeRecurring
          : includeRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPeriod: null == currentPeriod
          ? _self.currentPeriod
          : currentPeriod // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
      spots: null == spots
          ? _self.spots
          : spots // ignore: cast_nullable_to_non_nullable
              as List<List<FlSpot>>,
      previousPeriod: null == previousPeriod
          ? _self.previousPeriod
          : previousPeriod // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
    ));
  }
}

/// @nodoc

class _DiffWithPreviousMonthGraphState
    implements DiffWithPreviousMonthGraphState {
  const _DiffWithPreviousMonthGraphState(
      {this.loading = true,
      required this.includeRecurring,
      required this.currentPeriod,
      final List<List<FlSpot>> spots = const [],
      required this.previousPeriod})
      : _spots = spots;

  @override
  @JsonKey()
  final bool loading;
  @override
  final bool includeRecurring;
  @override
  final DateTimeRange currentPeriod;
  final List<List<FlSpot>> _spots;
  @override
  @JsonKey()
  List<List<FlSpot>> get spots {
    if (_spots is EqualUnmodifiableListView) return _spots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spots);
  }

  @override
  final DateTimeRange previousPeriod;

  /// Create a copy of DiffWithPreviousMonthGraphState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DiffWithPreviousMonthGraphStateCopyWith<_DiffWithPreviousMonthGraphState>
      get copyWith => __$DiffWithPreviousMonthGraphStateCopyWithImpl<
          _DiffWithPreviousMonthGraphState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiffWithPreviousMonthGraphState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.includeRecurring, includeRecurring) ||
                other.includeRecurring == includeRecurring) &&
            (identical(other.currentPeriod, currentPeriod) ||
                other.currentPeriod == currentPeriod) &&
            const DeepCollectionEquality().equals(other._spots, _spots) &&
            (identical(other.previousPeriod, previousPeriod) ||
                other.previousPeriod == previousPeriod));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      includeRecurring,
      currentPeriod,
      const DeepCollectionEquality().hash(_spots),
      previousPeriod);

  @override
  String toString() {
    return 'DiffWithPreviousMonthGraphState(loading: $loading, includeRecurring: $includeRecurring, currentPeriod: $currentPeriod, spots: $spots, previousPeriod: $previousPeriod)';
  }
}

/// @nodoc
abstract mixin class _$DiffWithPreviousMonthGraphStateCopyWith<$Res>
    implements $DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  factory _$DiffWithPreviousMonthGraphStateCopyWith(
          _DiffWithPreviousMonthGraphState value,
          $Res Function(_DiffWithPreviousMonthGraphState) _then) =
      __$DiffWithPreviousMonthGraphStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool includeRecurring,
      DateTimeRange currentPeriod,
      List<List<FlSpot>> spots,
      DateTimeRange previousPeriod});
}

/// @nodoc
class __$DiffWithPreviousMonthGraphStateCopyWithImpl<$Res>
    implements _$DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  __$DiffWithPreviousMonthGraphStateCopyWithImpl(this._self, this._then);

  final _DiffWithPreviousMonthGraphState _self;
  final $Res Function(_DiffWithPreviousMonthGraphState) _then;

  /// Create a copy of DiffWithPreviousMonthGraphState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? includeRecurring = null,
    Object? currentPeriod = null,
    Object? spots = null,
    Object? previousPeriod = null,
  }) {
    return _then(_DiffWithPreviousMonthGraphState(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      includeRecurring: null == includeRecurring
          ? _self.includeRecurring
          : includeRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPeriod: null == currentPeriod
          ? _self.currentPeriod
          : currentPeriod // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
      spots: null == spots
          ? _self._spots
          : spots // ignore: cast_nullable_to_non_nullable
              as List<List<FlSpot>>,
      previousPeriod: null == previousPeriod
          ? _self.previousPeriod
          : previousPeriod // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
    ));
  }
}

// dart format on
