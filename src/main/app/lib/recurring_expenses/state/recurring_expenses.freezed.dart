// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expenses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringExpensesState {
  bool get loading;
  dynamic get error;
  StackTrace? get stackTrace;
  List<RecurringExpense> get expenses;

  /// Create a copy of RecurringExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringExpensesStateCopyWith<RecurringExpensesState> get copyWith =>
      _$RecurringExpensesStateCopyWithImpl<RecurringExpensesState>(
          this as RecurringExpensesState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringExpensesState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            const DeepCollectionEquality().equals(other.expenses, expenses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(error),
      stackTrace,
      const DeepCollectionEquality().hash(expenses));

  @override
  String toString() {
    return 'RecurringExpensesState(loading: $loading, error: $error, stackTrace: $stackTrace, expenses: $expenses)';
  }
}

/// @nodoc
abstract mixin class $RecurringExpensesStateCopyWith<$Res> {
  factory $RecurringExpensesStateCopyWith(RecurringExpensesState value,
          $Res Function(RecurringExpensesState) _then) =
      _$RecurringExpensesStateCopyWithImpl;
  @useResult
  $Res call(
      {bool loading,
      dynamic error,
      StackTrace? stackTrace,
      List<RecurringExpense> expenses});
}

/// @nodoc
class _$RecurringExpensesStateCopyWithImpl<$Res>
    implements $RecurringExpensesStateCopyWith<$Res> {
  _$RecurringExpensesStateCopyWithImpl(this._self, this._then);

  final RecurringExpensesState _self;
  final $Res Function(RecurringExpensesState) _then;

  /// Create a copy of RecurringExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
    Object? expenses = null,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<RecurringExpense>,
    ));
  }
}

/// @nodoc

class _RecurringExpensesState implements RecurringExpensesState, WithError {
  const _RecurringExpensesState(
      {this.loading = false,
      this.error,
      this.stackTrace,
      final List<RecurringExpense> expenses = const []})
      : _expenses = expenses;

  @override
  @JsonKey()
  final bool loading;
  @override
  final dynamic error;
  @override
  final StackTrace? stackTrace;
  final List<RecurringExpense> _expenses;
  @override
  @JsonKey()
  List<RecurringExpense> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

  /// Create a copy of RecurringExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringExpensesStateCopyWith<_RecurringExpensesState> get copyWith =>
      __$RecurringExpensesStateCopyWithImpl<_RecurringExpensesState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringExpensesState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(error),
      stackTrace,
      const DeepCollectionEquality().hash(_expenses));

  @override
  String toString() {
    return 'RecurringExpensesState(loading: $loading, error: $error, stackTrace: $stackTrace, expenses: $expenses)';
  }
}

/// @nodoc
abstract mixin class _$RecurringExpensesStateCopyWith<$Res>
    implements $RecurringExpensesStateCopyWith<$Res> {
  factory _$RecurringExpensesStateCopyWith(_RecurringExpensesState value,
          $Res Function(_RecurringExpensesState) _then) =
      __$RecurringExpensesStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool loading,
      dynamic error,
      StackTrace? stackTrace,
      List<RecurringExpense> expenses});
}

/// @nodoc
class __$RecurringExpensesStateCopyWithImpl<$Res>
    implements _$RecurringExpensesStateCopyWith<$Res> {
  __$RecurringExpensesStateCopyWithImpl(this._self, this._then);

  final _RecurringExpensesState _self;
  final $Res Function(_RecurringExpensesState) _then;

  /// Create a copy of RecurringExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
    Object? expenses = null,
  }) {
    return _then(_RecurringExpensesState(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      expenses: null == expenses
          ? _self._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<RecurringExpense>,
    ));
  }
}

// dart format on
