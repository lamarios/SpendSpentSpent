// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) {
  return _RecurringExpense.fromJson(json);
}

/// @nodoc
mixin _$RecurringExpense {
  String? get nextOccurrence => throw _privateConstructorUsedError;
  String? get lastOccurrence => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  bool get income => throw _privateConstructorUsedError;
  Category get category => throw _privateConstructorUsedError;
  int get typeParam => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this RecurringExpense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringExpenseCopyWith<RecurringExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringExpenseCopyWith<$Res> {
  factory $RecurringExpenseCopyWith(
          RecurringExpense value, $Res Function(RecurringExpense) then) =
      _$RecurringExpenseCopyWithImpl<$Res, RecurringExpense>;
  @useResult
  $Res call(
      {String? nextOccurrence,
      String? lastOccurrence,
      double amount,
      int type,
      bool income,
      Category category,
      int typeParam,
      int? id,
      String name});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$RecurringExpenseCopyWithImpl<$Res, $Val extends RecurringExpense>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextOccurrence = freezed,
    Object? lastOccurrence = freezed,
    Object? amount = null,
    Object? type = null,
    Object? income = null,
    Object? category = null,
    Object? typeParam = null,
    Object? id = freezed,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      nextOccurrence: freezed == nextOccurrence
          ? _value.nextOccurrence
          : nextOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOccurrence: freezed == lastOccurrence
          ? _value.lastOccurrence
          : lastOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as bool,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      typeParam: null == typeParam
          ? _value.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of RecurringExpense
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
abstract class _$$RecurringExpenseImplCopyWith<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  factory _$$RecurringExpenseImplCopyWith(_$RecurringExpenseImpl value,
          $Res Function(_$RecurringExpenseImpl) then) =
      __$$RecurringExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? nextOccurrence,
      String? lastOccurrence,
      double amount,
      int type,
      bool income,
      Category category,
      int typeParam,
      int? id,
      String name});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$$RecurringExpenseImplCopyWithImpl<$Res>
    extends _$RecurringExpenseCopyWithImpl<$Res, _$RecurringExpenseImpl>
    implements _$$RecurringExpenseImplCopyWith<$Res> {
  __$$RecurringExpenseImplCopyWithImpl(_$RecurringExpenseImpl _value,
      $Res Function(_$RecurringExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nextOccurrence = freezed,
    Object? lastOccurrence = freezed,
    Object? amount = null,
    Object? type = null,
    Object? income = null,
    Object? category = null,
    Object? typeParam = null,
    Object? id = freezed,
    Object? name = null,
  }) {
    return _then(_$RecurringExpenseImpl(
      nextOccurrence: freezed == nextOccurrence
          ? _value.nextOccurrence
          : nextOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOccurrence: freezed == lastOccurrence
          ? _value.lastOccurrence
          : lastOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as bool,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      typeParam: null == typeParam
          ? _value.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringExpenseImpl implements _RecurringExpense {
  const _$RecurringExpenseImpl(
      {this.nextOccurrence,
      this.lastOccurrence,
      required this.amount,
      this.type = 1,
      this.income = false,
      required this.category,
      required this.typeParam,
      this.id,
      required this.name});

  factory _$RecurringExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringExpenseImplFromJson(json);

  @override
  final String? nextOccurrence;
  @override
  final String? lastOccurrence;
  @override
  final double amount;
  @override
  @JsonKey()
  final int type;
  @override
  @JsonKey()
  final bool income;
  @override
  final Category category;
  @override
  final int typeParam;
  @override
  final int? id;
  @override
  final String name;

  @override
  String toString() {
    return 'RecurringExpense(nextOccurrence: $nextOccurrence, lastOccurrence: $lastOccurrence, amount: $amount, type: $type, income: $income, category: $category, typeParam: $typeParam, id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringExpenseImpl &&
            (identical(other.nextOccurrence, nextOccurrence) ||
                other.nextOccurrence == nextOccurrence) &&
            (identical(other.lastOccurrence, lastOccurrence) ||
                other.lastOccurrence == lastOccurrence) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.typeParam, typeParam) ||
                other.typeParam == typeParam) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nextOccurrence, lastOccurrence,
      amount, type, income, category, typeParam, id, name);

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringExpenseImplCopyWith<_$RecurringExpenseImpl> get copyWith =>
      __$$RecurringExpenseImplCopyWithImpl<_$RecurringExpenseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringExpenseImplToJson(
      this,
    );
  }
}

abstract class _RecurringExpense implements RecurringExpense {
  const factory _RecurringExpense(
      {final String? nextOccurrence,
      final String? lastOccurrence,
      required final double amount,
      final int type,
      final bool income,
      required final Category category,
      required final int typeParam,
      final int? id,
      required final String name}) = _$RecurringExpenseImpl;

  factory _RecurringExpense.fromJson(Map<String, dynamic> json) =
      _$RecurringExpenseImpl.fromJson;

  @override
  String? get nextOccurrence;
  @override
  String? get lastOccurrence;
  @override
  double get amount;
  @override
  int get type;
  @override
  bool get income;
  @override
  Category get category;
  @override
  int get typeParam;
  @override
  int? get id;
  @override
  String get name;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringExpenseImplCopyWith<_$RecurringExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
