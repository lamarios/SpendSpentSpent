// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoriesState {
  bool get loading;
  List<Category> get categories;

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoriesStateCopyWith<CategoriesState> get copyWith =>
      _$CategoriesStateCopyWithImpl<CategoriesState>(
          this as CategoriesState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoriesState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, loading, const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'CategoriesState(loading: $loading, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $CategoriesStateCopyWith<$Res> {
  factory $CategoriesStateCopyWith(
          CategoriesState value, $Res Function(CategoriesState) _then) =
      _$CategoriesStateCopyWithImpl;
  @useResult
  $Res call({bool loading, List<Category> categories});
}

/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._self, this._then);

  final CategoriesState _self;
  final $Res Function(CategoriesState) _then;

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _CategoriesState implements CategoriesState {
  const _CategoriesState(
      {this.loading = true, final List<Category> categories = const []})
      : _categories = categories;

  @override
  @JsonKey()
  final bool loading;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoriesStateCopyWith<_CategoriesState> get copyWith =>
      __$CategoriesStateCopyWithImpl<_CategoriesState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoriesState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, loading, const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'CategoriesState(loading: $loading, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$CategoriesStateCopyWith<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  factory _$CategoriesStateCopyWith(
          _CategoriesState value, $Res Function(_CategoriesState) _then) =
      __$CategoriesStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool loading, List<Category> categories});
}

/// @nodoc
class __$CategoriesStateCopyWithImpl<$Res>
    implements _$CategoriesStateCopyWith<$Res> {
  __$CategoriesStateCopyWithImpl(this._self, this._then);

  final _CategoriesState _self;
  final $Res Function(_CategoriesState) _then;

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? categories = null,
  }) {
    return _then(_CategoriesState(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

// dart format on
