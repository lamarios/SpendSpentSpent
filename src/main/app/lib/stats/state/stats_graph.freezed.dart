// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatsGraphState {
  int get periodMax;
  bool get loading;
  int get count;
  double get minValue;
  double get maxValue;
  List<FlSpot> get graphData;
  List<FlSpot> get avgData;
  List<GraphDataPoint> get graphDataPoints;

  /// Create a copy of StatsGraphState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatsGraphStateCopyWith<StatsGraphState> get copyWith =>
      _$StatsGraphStateCopyWithImpl<StatsGraphState>(
          this as StatsGraphState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatsGraphState &&
            (identical(other.periodMax, periodMax) ||
                other.periodMax == periodMax) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            const DeepCollectionEquality().equals(other.graphData, graphData) &&
            const DeepCollectionEquality().equals(other.avgData, avgData) &&
            const DeepCollectionEquality()
                .equals(other.graphDataPoints, graphDataPoints));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      periodMax,
      loading,
      count,
      minValue,
      maxValue,
      const DeepCollectionEquality().hash(graphData),
      const DeepCollectionEquality().hash(avgData),
      const DeepCollectionEquality().hash(graphDataPoints));

  @override
  String toString() {
    return 'StatsGraphState(periodMax: $periodMax, loading: $loading, count: $count, minValue: $minValue, maxValue: $maxValue, graphData: $graphData, avgData: $avgData, graphDataPoints: $graphDataPoints)';
  }
}

/// @nodoc
abstract mixin class $StatsGraphStateCopyWith<$Res> {
  factory $StatsGraphStateCopyWith(
          StatsGraphState value, $Res Function(StatsGraphState) _then) =
      _$StatsGraphStateCopyWithImpl;
  @useResult
  $Res call(
      {int periodMax,
      bool loading,
      int count,
      double minValue,
      double maxValue,
      List<FlSpot> graphData,
      List<FlSpot> avgData,
      List<GraphDataPoint> graphDataPoints});
}

/// @nodoc
class _$StatsGraphStateCopyWithImpl<$Res>
    implements $StatsGraphStateCopyWith<$Res> {
  _$StatsGraphStateCopyWithImpl(this._self, this._then);

  final StatsGraphState _self;
  final $Res Function(StatsGraphState) _then;

  /// Create a copy of StatsGraphState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodMax = null,
    Object? loading = null,
    Object? count = null,
    Object? minValue = null,
    Object? maxValue = null,
    Object? graphData = null,
    Object? avgData = null,
    Object? graphDataPoints = null,
  }) {
    return _then(_self.copyWith(
      periodMax: null == periodMax
          ? _self.periodMax
          : periodMax // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      minValue: null == minValue
          ? _self.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _self.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      graphData: null == graphData
          ? _self.graphData
          : graphData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      avgData: null == avgData
          ? _self.avgData
          : avgData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      graphDataPoints: null == graphDataPoints
          ? _self.graphDataPoints
          : graphDataPoints // ignore: cast_nullable_to_non_nullable
              as List<GraphDataPoint>,
    ));
  }
}

/// @nodoc

class _StatsGraphState implements StatsGraphState {
  const _StatsGraphState(
      {this.periodMax = 10,
      this.loading = true,
      this.count = 5,
      this.minValue = 0,
      this.maxValue = 0,
      final List<FlSpot> graphData = const [
        FlSpot(0, 0),
        FlSpot(1, 0),
        FlSpot(2, 0),
        FlSpot(3, 0),
        FlSpot(4, 0)
      ],
      final List<FlSpot> avgData = const [
        FlSpot(0, 0),
        FlSpot(1, 0),
        FlSpot(2, 0),
        FlSpot(3, 0),
        FlSpot(4, 0)
      ],
      final List<GraphDataPoint> graphDataPoints = const [
        GraphDataPoint(date: '2021', amount: 0),
        GraphDataPoint(date: '2020', amount: 0),
        GraphDataPoint(date: '2019', amount: 0),
        GraphDataPoint(date: '2018', amount: 0),
        GraphDataPoint(date: '2017', amount: 0)
      ]})
      : _graphData = graphData,
        _avgData = avgData,
        _graphDataPoints = graphDataPoints;

  @override
  @JsonKey()
  final int periodMax;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final double minValue;
  @override
  @JsonKey()
  final double maxValue;
  final List<FlSpot> _graphData;
  @override
  @JsonKey()
  List<FlSpot> get graphData {
    if (_graphData is EqualUnmodifiableListView) return _graphData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_graphData);
  }

  final List<FlSpot> _avgData;
  @override
  @JsonKey()
  List<FlSpot> get avgData {
    if (_avgData is EqualUnmodifiableListView) return _avgData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avgData);
  }

  final List<GraphDataPoint> _graphDataPoints;
  @override
  @JsonKey()
  List<GraphDataPoint> get graphDataPoints {
    if (_graphDataPoints is EqualUnmodifiableListView) return _graphDataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_graphDataPoints);
  }

  /// Create a copy of StatsGraphState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatsGraphStateCopyWith<_StatsGraphState> get copyWith =>
      __$StatsGraphStateCopyWithImpl<_StatsGraphState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatsGraphState &&
            (identical(other.periodMax, periodMax) ||
                other.periodMax == periodMax) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            const DeepCollectionEquality()
                .equals(other._graphData, _graphData) &&
            const DeepCollectionEquality().equals(other._avgData, _avgData) &&
            const DeepCollectionEquality()
                .equals(other._graphDataPoints, _graphDataPoints));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      periodMax,
      loading,
      count,
      minValue,
      maxValue,
      const DeepCollectionEquality().hash(_graphData),
      const DeepCollectionEquality().hash(_avgData),
      const DeepCollectionEquality().hash(_graphDataPoints));

  @override
  String toString() {
    return 'StatsGraphState(periodMax: $periodMax, loading: $loading, count: $count, minValue: $minValue, maxValue: $maxValue, graphData: $graphData, avgData: $avgData, graphDataPoints: $graphDataPoints)';
  }
}

/// @nodoc
abstract mixin class _$StatsGraphStateCopyWith<$Res>
    implements $StatsGraphStateCopyWith<$Res> {
  factory _$StatsGraphStateCopyWith(
          _StatsGraphState value, $Res Function(_StatsGraphState) _then) =
      __$StatsGraphStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int periodMax,
      bool loading,
      int count,
      double minValue,
      double maxValue,
      List<FlSpot> graphData,
      List<FlSpot> avgData,
      List<GraphDataPoint> graphDataPoints});
}

/// @nodoc
class __$StatsGraphStateCopyWithImpl<$Res>
    implements _$StatsGraphStateCopyWith<$Res> {
  __$StatsGraphStateCopyWithImpl(this._self, this._then);

  final _StatsGraphState _self;
  final $Res Function(_StatsGraphState) _then;

  /// Create a copy of StatsGraphState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? periodMax = null,
    Object? loading = null,
    Object? count = null,
    Object? minValue = null,
    Object? maxValue = null,
    Object? graphData = null,
    Object? avgData = null,
    Object? graphDataPoints = null,
  }) {
    return _then(_StatsGraphState(
      periodMax: null == periodMax
          ? _self.periodMax
          : periodMax // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      minValue: null == minValue
          ? _self.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _self.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      graphData: null == graphData
          ? _self._graphData
          : graphData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      avgData: null == avgData
          ? _self._avgData
          : avgData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      graphDataPoints: null == graphDataPoints
          ? _self._graphDataPoints
          : graphDataPoints // ignore: cast_nullable_to_non_nullable
              as List<GraphDataPoint>,
    ));
  }
}

// dart format on
