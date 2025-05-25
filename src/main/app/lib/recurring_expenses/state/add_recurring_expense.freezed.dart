// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddRecurringExpenseState {
  int get step;
  Category? get category;
  int? get type;
  int? get typeParam;
  String get amount;
  String get name;
  List<Category> get categories;

  /// Create a copy of AddRecurringExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddRecurringExpenseStateCopyWith<AddRecurringExpenseState> get copyWith =>
      _$AddRecurringExpenseStateCopyWithImpl<AddRecurringExpenseState>(
          this as AddRecurringExpenseState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddRecurringExpenseState &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.typeParam, typeParam) ||
                other.typeParam == typeParam) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, step, category, type, typeParam,
      amount, name, const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'AddRecurringExpenseState(step: $step, category: $category, type: $type, typeParam: $typeParam, amount: $amount, name: $name, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $AddRecurringExpenseStateCopyWith<$Res> {
  factory $AddRecurringExpenseStateCopyWith(AddRecurringExpenseState value,
          $Res Function(AddRecurringExpenseState) _then) =
      _$AddRecurringExpenseStateCopyWithImpl;
  @useResult
  $Res call(
      {int step,
      Category? category,
      int? type,
      int? typeParam,
      String amount,
      String name,
      List<Category> categories});

  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$AddRecurringExpenseStateCopyWithImpl<$Res>
    implements $AddRecurringExpenseStateCopyWith<$Res> {
  _$AddRecurringExpenseStateCopyWithImpl(this._self, this._then);

  final AddRecurringExpenseState _self;
  final $Res Function(AddRecurringExpenseState) _then;

  /// Create a copy of AddRecurringExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? category = freezed,
    Object? type = freezed,
    Object? typeParam = freezed,
    Object? amount = null,
    Object? name = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      step: null == step
          ? _self.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      typeParam: freezed == typeParam
          ? _self.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }

  /// Create a copy of AddRecurringExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_self.category!, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

/// @nodoc

class _AddRecurringExpenseState extends AddRecurringExpenseState {
  const _AddRecurringExpenseState(
      {this.step = 0,
      this.category,
      this.type,
      this.typeParam,
      this.amount = '',
      this.name = '',
      final List<Category> categories = const []})
      : _categories = categories,
        super._();

  @override
  @JsonKey()
  final int step;
  @override
  final Category? category;
  @override
  final int? type;
  @override
  final int? typeParam;
  @override
  @JsonKey()
  final String amount;
  @override
  @JsonKey()
  final String name;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of AddRecurringExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddRecurringExpenseStateCopyWith<_AddRecurringExpenseState> get copyWith =>
      __$AddRecurringExpenseStateCopyWithImpl<_AddRecurringExpenseState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddRecurringExpenseState &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.typeParam, typeParam) ||
                other.typeParam == typeParam) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, step, category, type, typeParam,
      amount, name, const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'AddRecurringExpenseState(step: $step, category: $category, type: $type, typeParam: $typeParam, amount: $amount, name: $name, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$AddRecurringExpenseStateCopyWith<$Res>
    implements $AddRecurringExpenseStateCopyWith<$Res> {
  factory _$AddRecurringExpenseStateCopyWith(_AddRecurringExpenseState value,
          $Res Function(_AddRecurringExpenseState) _then) =
      __$AddRecurringExpenseStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int step,
      Category? category,
      int? type,
      int? typeParam,
      String amount,
      String name,
      List<Category> categories});

  @override
  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$AddRecurringExpenseStateCopyWithImpl<$Res>
    implements _$AddRecurringExpenseStateCopyWith<$Res> {
  __$AddRecurringExpenseStateCopyWithImpl(this._self, this._then);

  final _AddRecurringExpenseState _self;
  final $Res Function(_AddRecurringExpenseState) _then;

  /// Create a copy of AddRecurringExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? step = null,
    Object? category = freezed,
    Object? type = freezed,
    Object? typeParam = freezed,
    Object? amount = null,
    Object? name = null,
    Object? categories = null,
  }) {
    return _then(_AddRecurringExpenseState(
      step: null == step
          ? _self.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      typeParam: freezed == typeParam
          ? _self.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }

  /// Create a copy of AddRecurringExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_self.category!, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

// dart format on
