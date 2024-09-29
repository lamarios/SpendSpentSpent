// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'left_column_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeftColumnStats _$LeftColumnStatsFromJson(Map<String, dynamic> json) {
  return _LeftColumnStats.fromJson(json);
}

/// @nodoc
mixin _$LeftColumnStats {
  Category get category => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this LeftColumnStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeftColumnStatsCopyWith<LeftColumnStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeftColumnStatsCopyWith<$Res> {
  factory $LeftColumnStatsCopyWith(
          LeftColumnStats value, $Res Function(LeftColumnStats) then) =
      _$LeftColumnStatsCopyWithImpl<$Res, LeftColumnStats>;
  @useResult
  $Res call({Category category, double total, double amount});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$LeftColumnStatsCopyWithImpl<$Res, $Val extends LeftColumnStats>
    implements $LeftColumnStatsCopyWith<$Res> {
  _$LeftColumnStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeftColumnStatsImplCopyWith<$Res>
    implements $LeftColumnStatsCopyWith<$Res> {
  factory _$$LeftColumnStatsImplCopyWith(_$LeftColumnStatsImpl value,
          $Res Function(_$LeftColumnStatsImpl) then) =
      __$$LeftColumnStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Category category, double total, double amount});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$LeftColumnStatsImplCopyWithImpl<$Res>
    extends _$LeftColumnStatsCopyWithImpl<$Res, _$LeftColumnStatsImpl>
    implements _$$LeftColumnStatsImplCopyWith<$Res> {
  __$$LeftColumnStatsImplCopyWithImpl(
      _$LeftColumnStatsImpl _value, $Res Function(_$LeftColumnStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? amount = null,
  }) {
    return _then(_$LeftColumnStatsImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeftColumnStatsImpl implements _LeftColumnStats {
  const _$LeftColumnStatsImpl(
      {required this.category, required this.total, required this.amount});

  factory _$LeftColumnStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeftColumnStatsImplFromJson(json);

  @override
  final Category category;
  @override
  final double total;
  @override
  final double amount;

  @override
  String toString() {
    return 'LeftColumnStats(category: $category, total: $total, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeftColumnStatsImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, total, amount);

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeftColumnStatsImplCopyWith<_$LeftColumnStatsImpl> get copyWith =>
      __$$LeftColumnStatsImplCopyWithImpl<_$LeftColumnStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeftColumnStatsImplToJson(
      this,
    );
  }
}

abstract class _LeftColumnStats implements LeftColumnStats {
  const factory _LeftColumnStats(
      {required final Category category,
      required final double total,
      required final double amount}) = _$LeftColumnStatsImpl;

  factory _LeftColumnStats.fromJson(Map<String, dynamic> json) =
      _$LeftColumnStatsImpl.fromJson;

  @override
  Category get category;
  @override
  double get total;
  @override
  double get amount;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeftColumnStatsImplCopyWith<_$LeftColumnStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
