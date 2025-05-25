// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'left_column_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeftColumnStats {
  Category get category;
  double get total;
  double get amount;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LeftColumnStatsCopyWith<LeftColumnStats> get copyWith =>
      _$LeftColumnStatsCopyWithImpl<LeftColumnStats>(
          this as LeftColumnStats, _$identity);

  /// Serializes this LeftColumnStats to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LeftColumnStats &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, total, amount);

  @override
  String toString() {
    return 'LeftColumnStats(category: $category, total: $total, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $LeftColumnStatsCopyWith<$Res> {
  factory $LeftColumnStatsCopyWith(
          LeftColumnStats value, $Res Function(LeftColumnStats) _then) =
      _$LeftColumnStatsCopyWithImpl;
  @useResult
  $Res call({Category category, double total, double amount});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$LeftColumnStatsCopyWithImpl<$Res>
    implements $LeftColumnStatsCopyWith<$Res> {
  _$LeftColumnStatsCopyWithImpl(this._self, this._then);

  final LeftColumnStats _self;
  final $Res Function(LeftColumnStats) _then;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? amount = null,
  }) {
    return _then(_self.copyWith(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_self.category, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _LeftColumnStats implements LeftColumnStats {
  const _LeftColumnStats(
      {required this.category, required this.total, required this.amount});
  factory _LeftColumnStats.fromJson(Map<String, dynamic> json) =>
      _$LeftColumnStatsFromJson(json);

  @override
  final Category category;
  @override
  final double total;
  @override
  final double amount;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LeftColumnStatsCopyWith<_LeftColumnStats> get copyWith =>
      __$LeftColumnStatsCopyWithImpl<_LeftColumnStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LeftColumnStatsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LeftColumnStats &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, total, amount);

  @override
  String toString() {
    return 'LeftColumnStats(category: $category, total: $total, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$LeftColumnStatsCopyWith<$Res>
    implements $LeftColumnStatsCopyWith<$Res> {
  factory _$LeftColumnStatsCopyWith(
          _LeftColumnStats value, $Res Function(_LeftColumnStats) _then) =
      __$LeftColumnStatsCopyWithImpl;
  @override
  @useResult
  $Res call({Category category, double total, double amount});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$LeftColumnStatsCopyWithImpl<$Res>
    implements _$LeftColumnStatsCopyWith<$Res> {
  __$LeftColumnStatsCopyWithImpl(this._self, this._then);

  final _LeftColumnStats _self;
  final $Res Function(_LeftColumnStats) _then;

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? amount = null,
  }) {
    return _then(_LeftColumnStats(
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of LeftColumnStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_self.category, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

// dart format on
