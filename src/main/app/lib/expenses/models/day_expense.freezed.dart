// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DayExpense _$DayExpenseFromJson(Map<String, dynamic> json) {
  return _DayExpense.fromJson(json);
}

/// @nodoc
mixin _$DayExpense {
  String get date => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  List<Expense> get expenses => throw _privateConstructorUsedError;

  /// Serializes this DayExpense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayExpenseCopyWith<DayExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayExpenseCopyWith<$Res> {
  factory $DayExpenseCopyWith(
          DayExpense value, $Res Function(DayExpense) then) =
      _$DayExpenseCopyWithImpl<$Res, DayExpense>;
  @useResult
  $Res call({String date, double total, List<Expense> expenses});
}

/// @nodoc
class _$DayExpenseCopyWithImpl<$Res, $Val extends DayExpense>
    implements $DayExpenseCopyWith<$Res> {
  _$DayExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? total = null,
    Object? expenses = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DayExpenseImplCopyWith<$Res>
    implements $DayExpenseCopyWith<$Res> {
  factory _$$DayExpenseImplCopyWith(
          _$DayExpenseImpl value, $Res Function(_$DayExpenseImpl) then) =
      __$$DayExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, double total, List<Expense> expenses});
}

/// @nodoc
class __$$DayExpenseImplCopyWithImpl<$Res>
    extends _$DayExpenseCopyWithImpl<$Res, _$DayExpenseImpl>
    implements _$$DayExpenseImplCopyWith<$Res> {
  __$$DayExpenseImplCopyWithImpl(
      _$DayExpenseImpl _value, $Res Function(_$DayExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? total = null,
    Object? expenses = null,
  }) {
    return _then(_$DayExpenseImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      expenses: null == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayExpenseImpl implements _DayExpense {
  const _$DayExpenseImpl(
      {required this.date,
      required this.total,
      final List<Expense> expenses = const []})
      : _expenses = expenses;

  factory _$DayExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayExpenseImplFromJson(json);

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

  @override
  String toString() {
    return 'DayExpense(date: $date, total: $total, expenses: $expenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayExpenseImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, total, const DeepCollectionEquality().hash(_expenses));

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayExpenseImplCopyWith<_$DayExpenseImpl> get copyWith =>
      __$$DayExpenseImplCopyWithImpl<_$DayExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayExpenseImplToJson(
      this,
    );
  }
}

abstract class _DayExpense implements DayExpense {
  const factory _DayExpense(
      {required final String date,
      required final double total,
      final List<Expense> expenses}) = _$DayExpenseImpl;

  factory _DayExpense.fromJson(Map<String, dynamic> json) =
      _$DayExpenseImpl.fromJson;

  @override
  String get date;
  @override
  double get total;
  @override
  List<Expense> get expenses;

  /// Create a copy of DayExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayExpenseImplCopyWith<_$DayExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
