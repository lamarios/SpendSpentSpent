// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expenses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecurringExpensesState {
  bool get loading => throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;
  StackTrace? get stackTrace => throw _privateConstructorUsedError;
  List<RecurringExpense> get expenses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecurringExpensesStateCopyWith<RecurringExpensesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringExpensesStateCopyWith<$Res> {
  factory $RecurringExpensesStateCopyWith(RecurringExpensesState value,
          $Res Function(RecurringExpensesState) then) =
      _$RecurringExpensesStateCopyWithImpl<$Res, RecurringExpensesState>;
  @useResult
  $Res call(
      {bool loading,
      dynamic error,
      StackTrace? stackTrace,
      List<RecurringExpense> expenses});
}

/// @nodoc
class _$RecurringExpensesStateCopyWithImpl<$Res,
        $Val extends RecurringExpensesState>
    implements $RecurringExpensesStateCopyWith<$Res> {
  _$RecurringExpensesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
    Object? expenses = null,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<RecurringExpense>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurringExpensesStateImplCopyWith<$Res>
    implements $RecurringExpensesStateCopyWith<$Res> {
  factory _$$RecurringExpensesStateImplCopyWith(
          _$RecurringExpensesStateImpl value,
          $Res Function(_$RecurringExpensesStateImpl) then) =
      __$$RecurringExpensesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      dynamic error,
      StackTrace? stackTrace,
      List<RecurringExpense> expenses});
}

/// @nodoc
class __$$RecurringExpensesStateImplCopyWithImpl<$Res>
    extends _$RecurringExpensesStateCopyWithImpl<$Res,
        _$RecurringExpensesStateImpl>
    implements _$$RecurringExpensesStateImplCopyWith<$Res> {
  __$$RecurringExpensesStateImplCopyWithImpl(
      _$RecurringExpensesStateImpl _value,
      $Res Function(_$RecurringExpensesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
    Object? expenses = null,
  }) {
    return _then(_$RecurringExpensesStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      expenses: null == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<RecurringExpense>,
    ));
  }
}

/// @nodoc

class _$RecurringExpensesStateImpl implements _RecurringExpensesState {
  const _$RecurringExpensesStateImpl(
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

  @override
  String toString() {
    return 'RecurringExpensesState(loading: $loading, error: $error, stackTrace: $stackTrace, expenses: $expenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringExpensesStateImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringExpensesStateImplCopyWith<_$RecurringExpensesStateImpl>
      get copyWith => __$$RecurringExpensesStateImplCopyWithImpl<
          _$RecurringExpensesStateImpl>(this, _$identity);
}

abstract class _RecurringExpensesState
    implements RecurringExpensesState, WithError {
  const factory _RecurringExpensesState(
      {final bool loading,
      final dynamic error,
      final StackTrace? stackTrace,
      final List<RecurringExpense> expenses}) = _$RecurringExpensesStateImpl;

  @override
  bool get loading;
  @override
  dynamic get error;
  @override
  StackTrace? get stackTrace;
  @override
  List<RecurringExpense> get expenses;
  @override
  @JsonKey(ignore: true)
  _$$RecurringExpensesStateImplCopyWith<_$RecurringExpensesStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
