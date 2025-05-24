// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategorySettingsState {
  List<Category> get categories;
  List<Category> get toDelete;
  int get expensesToDelete;
  dynamic get error;
  StackTrace? get stackTrace;

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategorySettingsStateCopyWith<CategorySettingsState> get copyWith =>
      _$CategorySettingsStateCopyWithImpl<CategorySettingsState>(
          this as CategorySettingsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategorySettingsState &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality().equals(other.toDelete, toDelete) &&
            (identical(other.expensesToDelete, expensesToDelete) ||
                other.expensesToDelete == expensesToDelete) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(toDelete),
      expensesToDelete,
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'CategorySettingsState(categories: $categories, toDelete: $toDelete, expensesToDelete: $expensesToDelete, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $CategorySettingsStateCopyWith<$Res> {
  factory $CategorySettingsStateCopyWith(CategorySettingsState value,
          $Res Function(CategorySettingsState) _then) =
      _$CategorySettingsStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Category> categories,
      List<Category> toDelete,
      int expensesToDelete,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class _$CategorySettingsStateCopyWithImpl<$Res>
    implements $CategorySettingsStateCopyWith<$Res> {
  _$CategorySettingsStateCopyWithImpl(this._self, this._then);

  final CategorySettingsState _self;
  final $Res Function(CategorySettingsState) _then;

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? toDelete = null,
    Object? expensesToDelete = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_self.copyWith(
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      toDelete: null == toDelete
          ? _self.toDelete
          : toDelete // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      expensesToDelete: null == expensesToDelete
          ? _self.expensesToDelete
          : expensesToDelete // ignore: cast_nullable_to_non_nullable
              as int,
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

/// @nodoc

class _CategorySettingsState implements CategorySettingsState, WithError {
  const _CategorySettingsState(
      {final List<Category> categories = const [],
      final List<Category> toDelete = const [],
      this.expensesToDelete = 0,
      this.error,
      this.stackTrace})
      : _categories = categories,
        _toDelete = toDelete;

  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<Category> _toDelete;
  @override
  @JsonKey()
  List<Category> get toDelete {
    if (_toDelete is EqualUnmodifiableListView) return _toDelete;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toDelete);
  }

  @override
  @JsonKey()
  final int expensesToDelete;
  @override
  final dynamic error;
  @override
  final StackTrace? stackTrace;

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategorySettingsStateCopyWith<_CategorySettingsState> get copyWith =>
      __$CategorySettingsStateCopyWithImpl<_CategorySettingsState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategorySettingsState &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._toDelete, _toDelete) &&
            (identical(other.expensesToDelete, expensesToDelete) ||
                other.expensesToDelete == expensesToDelete) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_toDelete),
      expensesToDelete,
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'CategorySettingsState(categories: $categories, toDelete: $toDelete, expensesToDelete: $expensesToDelete, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$CategorySettingsStateCopyWith<$Res>
    implements $CategorySettingsStateCopyWith<$Res> {
  factory _$CategorySettingsStateCopyWith(_CategorySettingsState value,
          $Res Function(_CategorySettingsState) _then) =
      __$CategorySettingsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Category> categories,
      List<Category> toDelete,
      int expensesToDelete,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class __$CategorySettingsStateCopyWithImpl<$Res>
    implements _$CategorySettingsStateCopyWith<$Res> {
  __$CategorySettingsStateCopyWithImpl(this._self, this._then);

  final _CategorySettingsState _self;
  final $Res Function(_CategorySettingsState) _then;

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
    Object? toDelete = null,
    Object? expensesToDelete = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_CategorySettingsState(
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      toDelete: null == toDelete
          ? _self._toDelete
          : toDelete // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      expensesToDelete: null == expensesToDelete
          ? _self.expensesToDelete
          : expensesToDelete // ignore: cast_nullable_to_non_nullable
              as int,
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
