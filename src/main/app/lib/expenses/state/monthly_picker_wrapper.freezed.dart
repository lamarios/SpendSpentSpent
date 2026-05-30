// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_picker_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyPickerWrapperState {

 Map<int, double> get totals; bool get loading; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of MonthlyPickerWrapperState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyPickerWrapperStateCopyWith<MonthlyPickerWrapperState> get copyWith => _$MonthlyPickerWrapperStateCopyWithImpl<MonthlyPickerWrapperState>(this as MonthlyPickerWrapperState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyPickerWrapperState&&const DeepCollectionEquality().equals(other.totals, totals)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(totals),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'MonthlyPickerWrapperState(totals: $totals, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $MonthlyPickerWrapperStateCopyWith<$Res>  {
  factory $MonthlyPickerWrapperStateCopyWith(MonthlyPickerWrapperState value, $Res Function(MonthlyPickerWrapperState) _then) = _$MonthlyPickerWrapperStateCopyWithImpl;
@useResult
$Res call({
 Map<int, double> totals, bool loading, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$MonthlyPickerWrapperStateCopyWithImpl<$Res>
    implements $MonthlyPickerWrapperStateCopyWith<$Res> {
  _$MonthlyPickerWrapperStateCopyWithImpl(this._self, this._then);

  final MonthlyPickerWrapperState _self;
  final $Res Function(MonthlyPickerWrapperState) _then;

/// Create a copy of MonthlyPickerWrapperState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totals = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as Map<int, double>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyPickerWrapperState].
extension MonthlyPickerWrapperStatePatterns on MonthlyPickerWrapperState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyPickerWrapperState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyPickerWrapperState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyPickerWrapperState value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyPickerWrapperState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyPickerWrapperState value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyPickerWrapperState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, double> totals,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyPickerWrapperState() when $default != null:
return $default(_that.totals,_that.loading,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, double> totals,  bool loading,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _MonthlyPickerWrapperState():
return $default(_that.totals,_that.loading,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, double> totals,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyPickerWrapperState() when $default != null:
return $default(_that.totals,_that.loading,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyPickerWrapperState implements MonthlyPickerWrapperState, WithError {
  const _MonthlyPickerWrapperState({final  Map<int, double> totals = const {}, this.loading = false, this.error, this.stackTrace}): _totals = totals;
  

 final  Map<int, double> _totals;
@override@JsonKey() Map<int, double> get totals {
  if (_totals is EqualUnmodifiableMapView) return _totals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_totals);
}

@override@JsonKey() final  bool loading;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of MonthlyPickerWrapperState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyPickerWrapperStateCopyWith<_MonthlyPickerWrapperState> get copyWith => __$MonthlyPickerWrapperStateCopyWithImpl<_MonthlyPickerWrapperState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyPickerWrapperState&&const DeepCollectionEquality().equals(other._totals, _totals)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_totals),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'MonthlyPickerWrapperState(totals: $totals, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$MonthlyPickerWrapperStateCopyWith<$Res> implements $MonthlyPickerWrapperStateCopyWith<$Res> {
  factory _$MonthlyPickerWrapperStateCopyWith(_MonthlyPickerWrapperState value, $Res Function(_MonthlyPickerWrapperState) _then) = __$MonthlyPickerWrapperStateCopyWithImpl;
@override @useResult
$Res call({
 Map<int, double> totals, bool loading, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$MonthlyPickerWrapperStateCopyWithImpl<$Res>
    implements _$MonthlyPickerWrapperStateCopyWith<$Res> {
  __$MonthlyPickerWrapperStateCopyWithImpl(this._self, this._then);

  final _MonthlyPickerWrapperState _self;
  final $Res Function(_MonthlyPickerWrapperState) _then;

/// Create a copy of MonthlyPickerWrapperState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totals = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_MonthlyPickerWrapperState(
totals: null == totals ? _self._totals : totals // ignore: cast_nullable_to_non_nullable
as Map<int, double>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
