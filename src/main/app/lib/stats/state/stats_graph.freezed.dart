// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StatsGraphState {
  int get periodMax => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get minValue => throw _privateConstructorUsedError;
  double get maxValue => throw _privateConstructorUsedError;
  List<FlSpot> get graphData => throw _privateConstructorUsedError;
  List<FlSpot> get avgData => throw _privateConstructorUsedError;
  List<GraphDataPoint> get graphDataPoints =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StatsGraphStateCopyWith<StatsGraphState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatsGraphStateCopyWith<$Res> {
  factory $StatsGraphStateCopyWith(
          StatsGraphState value, $Res Function(StatsGraphState) then) =
      _$StatsGraphStateCopyWithImpl<$Res, StatsGraphState>;
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
class _$StatsGraphStateCopyWithImpl<$Res, $Val extends StatsGraphState>
    implements $StatsGraphStateCopyWith<$Res> {
  _$StatsGraphStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      periodMax: null == periodMax
          ? _value.periodMax
          : periodMax // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      minValue: null == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      graphData: null == graphData
          ? _value.graphData
          : graphData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      avgData: null == avgData
          ? _value.avgData
          : avgData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      graphDataPoints: null == graphDataPoints
          ? _value.graphDataPoints
          : graphDataPoints // ignore: cast_nullable_to_non_nullable
              as List<GraphDataPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatsGraphStateImplCopyWith<$Res>
    implements $StatsGraphStateCopyWith<$Res> {
  factory _$$StatsGraphStateImplCopyWith(_$StatsGraphStateImpl value,
          $Res Function(_$StatsGraphStateImpl) then) =
      __$$StatsGraphStateImplCopyWithImpl<$Res>;
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
class __$$StatsGraphStateImplCopyWithImpl<$Res>
    extends _$StatsGraphStateCopyWithImpl<$Res, _$StatsGraphStateImpl>
    implements _$$StatsGraphStateImplCopyWith<$Res> {
  __$$StatsGraphStateImplCopyWithImpl(
      _$StatsGraphStateImpl _value, $Res Function(_$StatsGraphStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$StatsGraphStateImpl(
      periodMax: null == periodMax
          ? _value.periodMax
          : periodMax // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      minValue: null == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      graphData: null == graphData
          ? _value._graphData
          : graphData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      avgData: null == avgData
          ? _value._avgData
          : avgData // ignore: cast_nullable_to_non_nullable
              as List<FlSpot>,
      graphDataPoints: null == graphDataPoints
          ? _value._graphDataPoints
          : graphDataPoints // ignore: cast_nullable_to_non_nullable
              as List<GraphDataPoint>,
    ));
  }
}

/// @nodoc

class _$StatsGraphStateImpl implements _StatsGraphState {
  const _$StatsGraphStateImpl(
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

  @override
  String toString() {
    return 'StatsGraphState(periodMax: $periodMax, loading: $loading, count: $count, minValue: $minValue, maxValue: $maxValue, graphData: $graphData, avgData: $avgData, graphDataPoints: $graphDataPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatsGraphStateImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatsGraphStateImplCopyWith<_$StatsGraphStateImpl> get copyWith =>
      __$$StatsGraphStateImplCopyWithImpl<_$StatsGraphStateImpl>(
          this, _$identity);
}

abstract class _StatsGraphState implements StatsGraphState {
  const factory _StatsGraphState(
      {final int periodMax,
      final bool loading,
      final int count,
      final double minValue,
      final double maxValue,
      final List<FlSpot> graphData,
      final List<FlSpot> avgData,
      final List<GraphDataPoint> graphDataPoints}) = _$StatsGraphStateImpl;

  @override
  int get periodMax;
  @override
  bool get loading;
  @override
  int get count;
  @override
  double get minValue;
  @override
  double get maxValue;
  @override
  List<FlSpot> get graphData;
  @override
  List<FlSpot> get avgData;
  @override
  List<GraphDataPoint> get graphDataPoints;
  @override
  @JsonKey(ignore: true)
  _$$StatsGraphStateImplCopyWith<_$StatsGraphStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
