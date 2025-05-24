// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddCategoryState {
  String get selected;
  AvailableCategories get categories;

  /// Create a copy of AddCategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCategoryStateCopyWith<AddCategoryState> get copyWith =>
      _$AddCategoryStateCopyWithImpl<AddCategoryState>(
          this as AddCategoryState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCategoryState &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.categories, categories) ||
                other.categories == categories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selected, categories);

  @override
  String toString() {
    return 'AddCategoryState(selected: $selected, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $AddCategoryStateCopyWith<$Res> {
  factory $AddCategoryStateCopyWith(
          AddCategoryState value, $Res Function(AddCategoryState) _then) =
      _$AddCategoryStateCopyWithImpl;
  @useResult
  $Res call({String selected, AvailableCategories categories});

  $AvailableCategoriesCopyWith<$Res> get categories;
}

/// @nodoc
class _$AddCategoryStateCopyWithImpl<$Res>
    implements $AddCategoryStateCopyWith<$Res> {
  _$AddCategoryStateCopyWithImpl(this._self, this._then);

  final AddCategoryState _self;
  final $Res Function(AddCategoryState) _then;

  /// Create a copy of AddCategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selected = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as AvailableCategories,
    ));
  }

  /// Create a copy of AddCategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailableCategoriesCopyWith<$Res> get categories {
    return $AvailableCategoriesCopyWith<$Res>(_self.categories, (value) {
      return _then(_self.copyWith(categories: value));
    });
  }
}

/// @nodoc

class _AddCategoryState implements AddCategoryState {
  const _AddCategoryState(
      {this.selected = '', this.categories = const AvailableCategories()});

  @override
  @JsonKey()
  final String selected;
  @override
  @JsonKey()
  final AvailableCategories categories;

  /// Create a copy of AddCategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddCategoryStateCopyWith<_AddCategoryState> get copyWith =>
      __$AddCategoryStateCopyWithImpl<_AddCategoryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddCategoryState &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.categories, categories) ||
                other.categories == categories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selected, categories);

  @override
  String toString() {
    return 'AddCategoryState(selected: $selected, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$AddCategoryStateCopyWith<$Res>
    implements $AddCategoryStateCopyWith<$Res> {
  factory _$AddCategoryStateCopyWith(
          _AddCategoryState value, $Res Function(_AddCategoryState) _then) =
      __$AddCategoryStateCopyWithImpl;
  @override
  @useResult
  $Res call({String selected, AvailableCategories categories});

  @override
  $AvailableCategoriesCopyWith<$Res> get categories;
}

/// @nodoc
class __$AddCategoryStateCopyWithImpl<$Res>
    implements _$AddCategoryStateCopyWith<$Res> {
  __$AddCategoryStateCopyWithImpl(this._self, this._then);

  final _AddCategoryState _self;
  final $Res Function(_AddCategoryState) _then;

  /// Create a copy of AddCategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selected = null,
    Object? categories = null,
  }) {
    return _then(_AddCategoryState(
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as AvailableCategories,
    ));
  }

  /// Create a copy of AddCategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailableCategoriesCopyWith<$Res> get categories {
    return $AvailableCategoriesCopyWith<$Res>(_self.categories, (value) {
      return _then(_self.copyWith(categories: value));
    });
  }
}

// dart format on
