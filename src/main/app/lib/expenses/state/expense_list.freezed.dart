// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseListState {
  List<String> get months => throw _privateConstructorUsedError;
  String get selected => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get searchMode => throw _privateConstructorUsedError;
  Map<String, DayExpense> get expenses => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpenseListStateCopyWith<ExpenseListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseListStateCopyWith<$Res> {
  factory $ExpenseListStateCopyWith(
          ExpenseListState value, $Res Function(ExpenseListState) then) =
      _$ExpenseListStateCopyWithImpl<$Res, ExpenseListState>;
  @useResult
  $Res call(
      {List<String> months,
      String selected,
      double total,
      bool loading,
      bool searchMode,
      Map<String, DayExpense> expenses,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class _$ExpenseListStateCopyWithImpl<$Res, $Val extends ExpenseListState>
    implements $ExpenseListStateCopyWith<$Res> {
  _$ExpenseListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? months = null,
    Object? selected = null,
    Object? total = null,
    Object? loading = null,
    Object? searchMode = null,
    Object? expenses = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_value.copyWith(
      months: null == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      searchMode: null == searchMode
          ? _value.searchMode
          : searchMode // ignore: cast_nullable_to_non_nullable
              as bool,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as Map<String, DayExpense>,
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
abstract class _$$ExpenseListStateImplCopyWith<$Res>
    implements $ExpenseListStateCopyWith<$Res> {
  factory _$$ExpenseListStateImplCopyWith(_$ExpenseListStateImpl value,
          $Res Function(_$ExpenseListStateImpl) then) =
      __$$ExpenseListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> months,
      String selected,
      double total,
      bool loading,
      bool searchMode,
      Map<String, DayExpense> expenses,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class __$$ExpenseListStateImplCopyWithImpl<$Res>
    extends _$ExpenseListStateCopyWithImpl<$Res, _$ExpenseListStateImpl>
    implements _$$ExpenseListStateImplCopyWith<$Res> {
  __$$ExpenseListStateImplCopyWithImpl(_$ExpenseListStateImpl _value,
      $Res Function(_$ExpenseListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? months = null,
    Object? selected = null,
    Object? total = null,
    Object? loading = null,
    Object? searchMode = null,
    Object? expenses = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_$ExpenseListStateImpl(
      months: null == months
          ? _value._months
          : months // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      searchMode: null == searchMode
          ? _value.searchMode
          : searchMode // ignore: cast_nullable_to_non_nullable
              as bool,
      expenses: null == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as Map<String, DayExpense>,
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

class _$ExpenseListStateImpl implements _ExpenseListState {
  const _$ExpenseListStateImpl(
      {final List<String> months = const [],
      this.selected = '',
      this.total = 0,
      this.loading = false,
      this.searchMode = false,
      final Map<String, DayExpense> expenses = const {},
      this.error,
      this.stackTrace})
      : _months = months,
        _expenses = expenses;

  final List<String> _months;
  @override
  @JsonKey()
  List<String> get months {
    if (_months is EqualUnmodifiableListView) return _months;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_months);
  }

  @override
  @JsonKey()
  final String selected;
  @override
  @JsonKey()
  final double total;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool searchMode;
  final Map<String, DayExpense> _expenses;
  @override
  @JsonKey()
  Map<String, DayExpense> get expenses {
    if (_expenses is EqualUnmodifiableMapView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_expenses);
  }

  @override
  final dynamic error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'ExpenseListState(months: $months, selected: $selected, total: $total, loading: $loading, searchMode: $searchMode, expenses: $expenses, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseListStateImpl &&
            const DeepCollectionEquality().equals(other._months, _months) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.searchMode, searchMode) ||
                other.searchMode == searchMode) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_months),
      selected,
      total,
      loading,
      searchMode,
      const DeepCollectionEquality().hash(_expenses),
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseListStateImplCopyWith<_$ExpenseListStateImpl> get copyWith =>
      __$$ExpenseListStateImplCopyWithImpl<_$ExpenseListStateImpl>(
          this, _$identity);
}

abstract class _ExpenseListState implements ExpenseListState, WithError {
  const factory _ExpenseListState(
      {final List<String> months,
      final String selected,
      final double total,
      final bool loading,
      final bool searchMode,
      final Map<String, DayExpense> expenses,
      final dynamic error,
      final StackTrace? stackTrace}) = _$ExpenseListStateImpl;

  @override
  List<String> get months;
  @override
  String get selected;
  @override
  double get total;
  @override
  bool get loading;
  @override
  bool get searchMode;
  @override
  Map<String, DayExpense> get expenses;
  @override
  dynamic get error;
  @override
  StackTrace? get stackTrace;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseListStateImplCopyWith<_$ExpenseListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
