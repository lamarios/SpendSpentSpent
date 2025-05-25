// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayExpense {
  String get date;
  double get total;
  List<Expense> get expenses;

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DayExpenseCopyWith<DayExpense> get copyWith =>
      _$DayExpenseCopyWithImpl<DayExpense>(this as DayExpense, _$identity);

  /// Serializes this DayExpense to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DayExpense &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other.expenses, expenses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, total, const DeepCollectionEquality().hash(expenses));

  @override
  String toString() {
    return 'DayExpense(date: $date, total: $total, expenses: $expenses)';
  }
}

/// @nodoc
abstract mixin class $DayExpenseCopyWith<$Res> {
  factory $DayExpenseCopyWith(
          DayExpense value, $Res Function(DayExpense) _then) =
      _$DayExpenseCopyWithImpl;
  @useResult
  $Res call({String date, double total, List<Expense> expenses});
}

/// @nodoc
class _$DayExpenseCopyWithImpl<$Res> implements $DayExpenseCopyWith<$Res> {
  _$DayExpenseCopyWithImpl(this._self, this._then);

  final DayExpense _self;
  final $Res Function(DayExpense) _then;

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? total = null,
    Object? expenses = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DayExpense implements DayExpense {
  const _DayExpense(
      {required this.date,
      required this.total,
      final List<Expense> expenses = const []})
      : _expenses = expenses;
  factory _DayExpense.fromJson(Map<String, dynamic> json) =>
      _$DayExpenseFromJson(json);

  @override
  final String date;
  @override
  final double total;
  final List<Expense> _expenses;
  @override
  @JsonKey()
  List<Expense> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DayExpenseCopyWith<_DayExpense> get copyWith =>
      __$DayExpenseCopyWithImpl<_DayExpense>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DayExpenseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DayExpense &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, total, const DeepCollectionEquality().hash(_expenses));

  @override
  String toString() {
    return 'DayExpense(date: $date, total: $total, expenses: $expenses)';
  }
}

/// @nodoc
abstract mixin class _$DayExpenseCopyWith<$Res>
    implements $DayExpenseCopyWith<$Res> {
  factory _$DayExpenseCopyWith(
          _DayExpense value, $Res Function(_DayExpense) _then) =
      __$DayExpenseCopyWithImpl;
  @override
  @useResult
  $Res call({String date, double total, List<Expense> expenses});
}

/// @nodoc
class __$DayExpenseCopyWithImpl<$Res> implements _$DayExpenseCopyWith<$Res> {
  __$DayExpenseCopyWithImpl(this._self, this._then);

  final _DayExpense _self;
  final $Res Function(_DayExpense) _then;

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? total = null,
    Object? expenses = null,
  }) {
    return _then(_DayExpense(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _self._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ));
  }
}

// dart format on
