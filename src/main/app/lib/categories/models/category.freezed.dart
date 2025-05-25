// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Category {
  String? get icon;
  int? get categoryOrder;
  int? get id;
  double? get percentageOfMonthly;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<Category> get copyWith =>
      _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Category &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.categoryOrder, categoryOrder) ||
                other.categoryOrder == categoryOrder) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.percentageOfMonthly, percentageOfMonthly) ||
                other.percentageOfMonthly == percentageOfMonthly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, icon, categoryOrder, id, percentageOfMonthly);

  @override
  String toString() {
    return 'Category(icon: $icon, categoryOrder: $categoryOrder, id: $id, percentageOfMonthly: $percentageOfMonthly)';
  }
}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) =
      _$CategoryCopyWithImpl;
  @useResult
  $Res call(
      {String? icon, int? categoryOrder, int? id, double? percentageOfMonthly});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res> implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = freezed,
    Object? categoryOrder = freezed,
    Object? id = freezed,
    Object? percentageOfMonthly = freezed,
  }) {
    return _then(_self.copyWith(
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryOrder: freezed == categoryOrder
          ? _self.categoryOrder
          : categoryOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      percentageOfMonthly: freezed == percentageOfMonthly
          ? _self.percentageOfMonthly
          : percentageOfMonthly // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Category implements Category {
  const _Category(
      {this.icon, this.categoryOrder, this.id, this.percentageOfMonthly});
  factory _Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  @override
  final String? icon;
  @override
  final int? categoryOrder;
  @override
  final int? id;
  @override
  final double? percentageOfMonthly;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryCopyWith<_Category> get copyWith =>
      __$CategoryCopyWithImpl<_Category>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Category &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.categoryOrder, categoryOrder) ||
                other.categoryOrder == categoryOrder) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.percentageOfMonthly, percentageOfMonthly) ||
                other.percentageOfMonthly == percentageOfMonthly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, icon, categoryOrder, id, percentageOfMonthly);

  @override
  String toString() {
    return 'Category(icon: $icon, categoryOrder: $categoryOrder, id: $id, percentageOfMonthly: $percentageOfMonthly)';
  }
}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) =
      __$CategoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? icon, int? categoryOrder, int? id, double? percentageOfMonthly});
}

/// @nodoc
class __$CategoryCopyWithImpl<$Res> implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? icon = freezed,
    Object? categoryOrder = freezed,
    Object? id = freezed,
    Object? percentageOfMonthly = freezed,
  }) {
    return _then(_Category(
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryOrder: freezed == categoryOrder
          ? _self.categoryOrder
          : categoryOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      percentageOfMonthly: freezed == percentageOfMonthly
          ? _self.percentageOfMonthly
          : percentageOfMonthly // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
