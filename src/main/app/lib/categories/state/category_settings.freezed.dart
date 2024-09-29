// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategorySettingsState {
  List<Category> get categories => throw _privateConstructorUsedError;
  List<Category> get toDelete => throw _privateConstructorUsedError;
  int get expensesToDelete => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySettingsStateCopyWith<CategorySettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySettingsStateCopyWith<$Res> {
  factory $CategorySettingsStateCopyWith(CategorySettingsState value,
          $Res Function(CategorySettingsState) then) =
      _$CategorySettingsStateCopyWithImpl<$Res, CategorySettingsState>;
  @useResult
  $Res call(
      {List<Category> categories,
      List<Category> toDelete,
      int expensesToDelete,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class _$CategorySettingsStateCopyWithImpl<$Res,
        $Val extends CategorySettingsState>
    implements $CategorySettingsStateCopyWith<$Res> {
  _$CategorySettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      toDelete: null == toDelete
          ? _value.toDelete
          : toDelete // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      expensesToDelete: null == expensesToDelete
          ? _value.expensesToDelete
          : expensesToDelete // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySettingsStateImplCopyWith<$Res>
    implements $CategorySettingsStateCopyWith<$Res> {
  factory _$$CategorySettingsStateImplCopyWith(
          _$CategorySettingsStateImpl value,
          $Res Function(_$CategorySettingsStateImpl) then) =
      __$$CategorySettingsStateImplCopyWithImpl<$Res>;
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
class __$$CategorySettingsStateImplCopyWithImpl<$Res>
    extends _$CategorySettingsStateCopyWithImpl<$Res,
        _$CategorySettingsStateImpl>
    implements _$$CategorySettingsStateImplCopyWith<$Res> {
  __$$CategorySettingsStateImplCopyWithImpl(_$CategorySettingsStateImpl _value,
      $Res Function(_$CategorySettingsStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$CategorySettingsStateImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      toDelete: null == toDelete
          ? _value._toDelete
          : toDelete // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      expensesToDelete: null == expensesToDelete
          ? _value.expensesToDelete
          : expensesToDelete // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$CategorySettingsStateImpl implements _CategorySettingsState {
  const _$CategorySettingsStateImpl(
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

  @override
  String toString() {
    return 'CategorySettingsState(categories: $categories, toDelete: $toDelete, expensesToDelete: $expensesToDelete, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySettingsStateImpl &&
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

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySettingsStateImplCopyWith<_$CategorySettingsStateImpl>
      get copyWith => __$$CategorySettingsStateImplCopyWithImpl<
          _$CategorySettingsStateImpl>(this, _$identity);
}

abstract class _CategorySettingsState
    implements CategorySettingsState, WithError {
  const factory _CategorySettingsState(
      {final List<Category> categories,
      final List<Category> toDelete,
      final int expensesToDelete,
      final dynamic error,
      final StackTrace? stackTrace}) = _$CategorySettingsStateImpl;

  @override
  List<Category> get categories;
  @override
  List<Category> get toDelete;
  @override
  int get expensesToDelete;
  @override
  dynamic get error;
  @override
  StackTrace? get stackTrace;

  /// Create a copy of CategorySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySettingsStateImplCopyWith<_$CategorySettingsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
