// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseMenuState {

 Expense get expense; bool get loading;
/// Create a copy of ExpenseMenuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseMenuStateCopyWith<ExpenseMenuState> get copyWith => _$ExpenseMenuStateCopyWithImpl<ExpenseMenuState>(this as ExpenseMenuState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseMenuState&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,expense,loading);

@override
String toString() {
  return 'ExpenseMenuState(expense: $expense, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $ExpenseMenuStateCopyWith<$Res>  {
  factory $ExpenseMenuStateCopyWith(ExpenseMenuState value, $Res Function(ExpenseMenuState) _then) = _$ExpenseMenuStateCopyWithImpl;
@useResult
$Res call({
 Expense expense, bool loading
});


$ExpenseCopyWith<$Res> get expense;

}
/// @nodoc
class _$ExpenseMenuStateCopyWithImpl<$Res>
    implements $ExpenseMenuStateCopyWith<$Res> {
  _$ExpenseMenuStateCopyWithImpl(this._self, this._then);

  final ExpenseMenuState _self;
  final $Res Function(ExpenseMenuState) _then;

/// Create a copy of ExpenseMenuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expense = null,Object? loading = null,}) {
  return _then(_self.copyWith(
expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Expense,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ExpenseMenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpenseCopyWith<$Res> get expense {
  
  return $ExpenseCopyWith<$Res>(_self.expense, (value) {
    return _then(_self.copyWith(expense: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExpenseMenuState].
extension ExpenseMenuStatePatterns on ExpenseMenuState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseMenuState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseMenuState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseMenuState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseMenuState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseMenuState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseMenuState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Expense expense,  bool loading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseMenuState() when $default != null:
return $default(_that.expense,_that.loading);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Expense expense,  bool loading)  $default,) {final _that = this;
switch (_that) {
case _ExpenseMenuState():
return $default(_that.expense,_that.loading);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Expense expense,  bool loading)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseMenuState() when $default != null:
return $default(_that.expense,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseMenuState implements ExpenseMenuState {
  const _ExpenseMenuState({required this.expense, this.loading = true});
  

@override final  Expense expense;
@override@JsonKey() final  bool loading;

/// Create a copy of ExpenseMenuState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseMenuStateCopyWith<_ExpenseMenuState> get copyWith => __$ExpenseMenuStateCopyWithImpl<_ExpenseMenuState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseMenuState&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,expense,loading);

@override
String toString() {
  return 'ExpenseMenuState(expense: $expense, loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$ExpenseMenuStateCopyWith<$Res> implements $ExpenseMenuStateCopyWith<$Res> {
  factory _$ExpenseMenuStateCopyWith(_ExpenseMenuState value, $Res Function(_ExpenseMenuState) _then) = __$ExpenseMenuStateCopyWithImpl;
@override @useResult
$Res call({
 Expense expense, bool loading
});


@override $ExpenseCopyWith<$Res> get expense;

}
/// @nodoc
class __$ExpenseMenuStateCopyWithImpl<$Res>
    implements _$ExpenseMenuStateCopyWith<$Res> {
  __$ExpenseMenuStateCopyWithImpl(this._self, this._then);

  final _ExpenseMenuState _self;
  final $Res Function(_ExpenseMenuState) _then;

/// Create a copy of ExpenseMenuState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expense = null,Object? loading = null,}) {
  return _then(_ExpenseMenuState(
expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Expense,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ExpenseMenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpenseCopyWith<$Res> get expense {
  
  return $ExpenseCopyWith<$Res>(_self.expense, (value) {
    return _then(_self.copyWith(expense: value));
  });
}
}

// dart format on
