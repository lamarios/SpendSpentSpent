// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringExpense {
  String? get nextOccurrence;
  String? get lastOccurrence;
  double get amount;
  int get type;
  bool get income;
  Category get category;
  int get typeParam;
  int? get id;
  String get name;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringExpenseCopyWith<RecurringExpense> get copyWith =>
      _$RecurringExpenseCopyWithImpl<RecurringExpense>(
          this as RecurringExpense, _$identity);

  /// Serializes this RecurringExpense to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringExpense &&
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

  @override
  String toString() {
    return 'RecurringExpense(nextOccurrence: $nextOccurrence, lastOccurrence: $lastOccurrence, amount: $amount, type: $type, income: $income, category: $category, typeParam: $typeParam, id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $RecurringExpenseCopyWith<$Res> {
  factory $RecurringExpenseCopyWith(
          RecurringExpense value, $Res Function(RecurringExpense) _then) =
      _$RecurringExpenseCopyWithImpl;
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
class _$RecurringExpenseCopyWithImpl<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._self, this._then);

  final RecurringExpense _self;
  final $Res Function(RecurringExpense) _then;

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
    return _then(_self.copyWith(
      nextOccurrence: freezed == nextOccurrence
          ? _self.nextOccurrence
          : nextOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOccurrence: freezed == lastOccurrence
          ? _self.lastOccurrence
          : lastOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      income: null == income
          ? _self.income
          : income // ignore: cast_nullable_to_non_nullable
              as bool,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      typeParam: null == typeParam
          ? _self.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of RecurringExpense
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
class _RecurringExpense implements RecurringExpense {
  const _RecurringExpense(
      {this.nextOccurrence,
      this.lastOccurrence,
      required this.amount,
      this.type = 1,
      this.income = false,
      required this.category,
      required this.typeParam,
      this.id,
      required this.name});
  factory _RecurringExpense.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseFromJson(json);

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

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringExpenseCopyWith<_RecurringExpense> get copyWith =>
      __$RecurringExpenseCopyWithImpl<_RecurringExpense>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecurringExpenseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringExpense &&
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

  @override
  String toString() {
    return 'RecurringExpense(nextOccurrence: $nextOccurrence, lastOccurrence: $lastOccurrence, amount: $amount, type: $type, income: $income, category: $category, typeParam: $typeParam, id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$RecurringExpenseCopyWith<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  factory _$RecurringExpenseCopyWith(
          _RecurringExpense value, $Res Function(_RecurringExpense) _then) =
      __$RecurringExpenseCopyWithImpl;
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
class __$RecurringExpenseCopyWithImpl<$Res>
    implements _$RecurringExpenseCopyWith<$Res> {
  __$RecurringExpenseCopyWithImpl(this._self, this._then);

  final _RecurringExpense _self;
  final $Res Function(_RecurringExpense) _then;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_RecurringExpense(
      nextOccurrence: freezed == nextOccurrence
          ? _self.nextOccurrence
          : nextOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOccurrence: freezed == lastOccurrence
          ? _self.lastOccurrence
          : lastOccurrence // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      income: null == income
          ? _self.income
          : income // ignore: cast_nullable_to_non_nullable
              as bool,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      typeParam: null == typeParam
          ? _self.typeParam
          : typeParam // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of RecurringExpense
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
