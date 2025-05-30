// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseListState {
  List<String> get months;
  String get selected;
  double get total;
  bool get loading;
  bool get searchMode;
  Map<String, DayExpense> get expenses;
  dynamic get error;
  StackTrace? get stackTrace;

  /// Create a copy of ExpenseListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseListStateCopyWith<ExpenseListState> get copyWith =>
      _$ExpenseListStateCopyWithImpl<ExpenseListState>(
          this as ExpenseListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseListState &&
            const DeepCollectionEquality().equals(other.months, months) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.searchMode, searchMode) ||
                other.searchMode == searchMode) &&
            const DeepCollectionEquality().equals(other.expenses, expenses) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(months),
      selected,
      total,
      loading,
      searchMode,
      const DeepCollectionEquality().hash(expenses),
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'ExpenseListState(months: $months, selected: $selected, total: $total, loading: $loading, searchMode: $searchMode, expenses: $expenses, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $ExpenseListStateCopyWith<$Res> {
  factory $ExpenseListStateCopyWith(
          ExpenseListState value, $Res Function(ExpenseListState) _then) =
      _$ExpenseListStateCopyWithImpl;
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
class _$ExpenseListStateCopyWithImpl<$Res>
    implements $ExpenseListStateCopyWith<$Res> {
  _$ExpenseListStateCopyWithImpl(this._self, this._then);

  final ExpenseListState _self;
  final $Res Function(ExpenseListState) _then;

  /// Create a copy of ExpenseListState
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_self.copyWith(
      months: null == months
          ? _self.months
          : months // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      searchMode: null == searchMode
          ? _self.searchMode
          : searchMode // ignore: cast_nullable_to_non_nullable
              as bool,
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as Map<String, DayExpense>,
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

class _ExpenseListState implements ExpenseListState, WithError {
  const _ExpenseListState(
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

  /// Create a copy of ExpenseListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseListStateCopyWith<_ExpenseListState> get copyWith =>
      __$ExpenseListStateCopyWithImpl<_ExpenseListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseListState &&
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

  @override
  String toString() {
    return 'ExpenseListState(months: $months, selected: $selected, total: $total, loading: $loading, searchMode: $searchMode, expenses: $expenses, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseListStateCopyWith<$Res>
    implements $ExpenseListStateCopyWith<$Res> {
  factory _$ExpenseListStateCopyWith(
          _ExpenseListState value, $Res Function(_ExpenseListState) _then) =
      __$ExpenseListStateCopyWithImpl;
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
class __$ExpenseListStateCopyWithImpl<$Res>
    implements _$ExpenseListStateCopyWith<$Res> {
  __$ExpenseListStateCopyWithImpl(this._self, this._then);

  final _ExpenseListState _self;
  final $Res Function(_ExpenseListState) _then;

  /// Create a copy of ExpenseListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_ExpenseListState(
      months: null == months
          ? _self._months
          : months // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      searchMode: null == searchMode
          ? _self.searchMode
          : searchMode // ignore: cast_nullable_to_non_nullable
              as bool,
      expenses: null == expenses
          ? _self._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as Map<String, DayExpense>,
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
