// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diff_with_previous_month_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiffWithPreviousMonthSettingsState {

 bool get includeRecurringExpenses; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of DiffWithPreviousMonthSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiffWithPreviousMonthSettingsStateCopyWith<DiffWithPreviousMonthSettingsState> get copyWith => _$DiffWithPreviousMonthSettingsStateCopyWithImpl<DiffWithPreviousMonthSettingsState>(this as DiffWithPreviousMonthSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiffWithPreviousMonthSettingsState&&(identical(other.includeRecurringExpenses, includeRecurringExpenses) || other.includeRecurringExpenses == includeRecurringExpenses)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,includeRecurringExpenses,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'DiffWithPreviousMonthSettingsState(includeRecurringExpenses: $includeRecurringExpenses, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $DiffWithPreviousMonthSettingsStateCopyWith<$Res>  {
  factory $DiffWithPreviousMonthSettingsStateCopyWith(DiffWithPreviousMonthSettingsState value, $Res Function(DiffWithPreviousMonthSettingsState) _then) = _$DiffWithPreviousMonthSettingsStateCopyWithImpl;
@useResult
$Res call({
 bool includeRecurringExpenses, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$DiffWithPreviousMonthSettingsStateCopyWithImpl<$Res>
    implements $DiffWithPreviousMonthSettingsStateCopyWith<$Res> {
  _$DiffWithPreviousMonthSettingsStateCopyWithImpl(this._self, this._then);

  final DiffWithPreviousMonthSettingsState _self;
  final $Res Function(DiffWithPreviousMonthSettingsState) _then;

/// Create a copy of DiffWithPreviousMonthSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? includeRecurringExpenses = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
includeRecurringExpenses: null == includeRecurringExpenses ? _self.includeRecurringExpenses : includeRecurringExpenses // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiffWithPreviousMonthSettingsState].
extension DiffWithPreviousMonthSettingsStatePatterns on DiffWithPreviousMonthSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiffWithPreviousMonthSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiffWithPreviousMonthSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiffWithPreviousMonthSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _DiffWithPreviousMonthSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiffWithPreviousMonthSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _DiffWithPreviousMonthSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool includeRecurringExpenses,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiffWithPreviousMonthSettingsState() when $default != null:
return $default(_that.includeRecurringExpenses,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool includeRecurringExpenses,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _DiffWithPreviousMonthSettingsState():
return $default(_that.includeRecurringExpenses,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool includeRecurringExpenses,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _DiffWithPreviousMonthSettingsState() when $default != null:
return $default(_that.includeRecurringExpenses,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _DiffWithPreviousMonthSettingsState implements DiffWithPreviousMonthSettingsState, WithError {
  const _DiffWithPreviousMonthSettingsState({this.includeRecurringExpenses = true, this.error, this.stackTrace});
  

@override@JsonKey() final  bool includeRecurringExpenses;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of DiffWithPreviousMonthSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiffWithPreviousMonthSettingsStateCopyWith<_DiffWithPreviousMonthSettingsState> get copyWith => __$DiffWithPreviousMonthSettingsStateCopyWithImpl<_DiffWithPreviousMonthSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiffWithPreviousMonthSettingsState&&(identical(other.includeRecurringExpenses, includeRecurringExpenses) || other.includeRecurringExpenses == includeRecurringExpenses)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,includeRecurringExpenses,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'DiffWithPreviousMonthSettingsState(includeRecurringExpenses: $includeRecurringExpenses, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$DiffWithPreviousMonthSettingsStateCopyWith<$Res> implements $DiffWithPreviousMonthSettingsStateCopyWith<$Res> {
  factory _$DiffWithPreviousMonthSettingsStateCopyWith(_DiffWithPreviousMonthSettingsState value, $Res Function(_DiffWithPreviousMonthSettingsState) _then) = __$DiffWithPreviousMonthSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool includeRecurringExpenses, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$DiffWithPreviousMonthSettingsStateCopyWithImpl<$Res>
    implements _$DiffWithPreviousMonthSettingsStateCopyWith<$Res> {
  __$DiffWithPreviousMonthSettingsStateCopyWithImpl(this._self, this._then);

  final _DiffWithPreviousMonthSettingsState _self;
  final $Res Function(_DiffWithPreviousMonthSettingsState) _then;

/// Create a copy of DiffWithPreviousMonthSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? includeRecurringExpenses = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_DiffWithPreviousMonthSettingsState(
includeRecurringExpenses: null == includeRecurringExpenses ? _self.includeRecurringExpenses : includeRecurringExpenses // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
