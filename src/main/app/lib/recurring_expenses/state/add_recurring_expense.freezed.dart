// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddRecurringExpenseState {
  int get step => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  int? get typeParam => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<Category> get categories => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddRecurringExpenseStateCopyWith<AddRecurringExpenseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddRecurringExpenseStateCopyWith<$Res> {
  factory $AddRecurringExpenseStateCopyWith(AddRecurringExpenseState value,
          $Res Function(AddRecurringExpenseState) then) =
      _$AddRecurringExpenseStateCopyWithImpl<$Res, AddRecurringExpenseState>;
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
class _$AddRecurringExpenseStateCopyWithImpl<$Res,
        $Val extends AddRecurringExpenseState>
    implements $AddRecurringExpenseStateCopyWith<$Res> {
  _$AddRecurringExpenseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      typeParam: freezed == typeParam
          ? _value.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddRecurringExpenseStateImplCopyWith<$Res>
    implements $AddRecurringExpenseStateCopyWith<$Res> {
  factory _$$AddRecurringExpenseStateImplCopyWith(
          _$AddRecurringExpenseStateImpl value,
          $Res Function(_$AddRecurringExpenseStateImpl) then) =
      __$$AddRecurringExpenseStateImplCopyWithImpl<$Res>;
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
class __$$AddRecurringExpenseStateImplCopyWithImpl<$Res>
    extends _$AddRecurringExpenseStateCopyWithImpl<$Res,
        _$AddRecurringExpenseStateImpl>
    implements _$$AddRecurringExpenseStateImplCopyWith<$Res> {
  __$$AddRecurringExpenseStateImplCopyWithImpl(
      _$AddRecurringExpenseStateImpl _value,
      $Res Function(_$AddRecurringExpenseStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$AddRecurringExpenseStateImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      typeParam: freezed == typeParam
          ? _value.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _$AddRecurringExpenseStateImpl extends _AddRecurringExpenseState {
  const _$AddRecurringExpenseStateImpl(
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

  @override
  String toString() {
    return 'AddRecurringExpenseState(step: $step, category: $category, type: $type, typeParam: $typeParam, amount: $amount, name: $name, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddRecurringExpenseStateImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddRecurringExpenseStateImplCopyWith<_$AddRecurringExpenseStateImpl>
      get copyWith => __$$AddRecurringExpenseStateImplCopyWithImpl<
          _$AddRecurringExpenseStateImpl>(this, _$identity);
}

abstract class _AddRecurringExpenseState extends AddRecurringExpenseState {
  const factory _AddRecurringExpenseState(
      {final int step,
      final Category? category,
      final int? type,
      final int? typeParam,
      final String amount,
      final String name,
      final List<Category> categories}) = _$AddRecurringExpenseStateImpl;
  const _AddRecurringExpenseState._() : super._();

  @override
  int get step;
  @override
  Category? get category;
  @override
  int? get type;
  @override
  int? get typeParam;
  @override
  String get amount;
  @override
  String get name;
  @override
  List<Category> get categories;
  @override
  @JsonKey(ignore: true)
  _$$AddRecurringExpenseStateImplCopyWith<_$AddRecurringExpenseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
