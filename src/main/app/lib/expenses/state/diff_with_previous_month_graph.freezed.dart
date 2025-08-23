// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diff_with_previous_month_graph.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiffWithPreviousMonthGraphState {

 bool get loading; bool get includeRecurring; DateTimeRange get currentPeriod; List<List<FlSpot>> get spots; DateTimeRange get previousPeriod;
/// Create a copy of DiffWithPreviousMonthGraphState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiffWithPreviousMonthGraphStateCopyWith<DiffWithPreviousMonthGraphState> get copyWith => _$DiffWithPreviousMonthGraphStateCopyWithImpl<DiffWithPreviousMonthGraphState>(this as DiffWithPreviousMonthGraphState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiffWithPreviousMonthGraphState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.includeRecurring, includeRecurring) || other.includeRecurring == includeRecurring)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod)&&const DeepCollectionEquality().equals(other.spots, spots)&&(identical(other.previousPeriod, previousPeriod) || other.previousPeriod == previousPeriod));
}


@override
int get hashCode => Object.hash(runtimeType,loading,includeRecurring,currentPeriod,const DeepCollectionEquality().hash(spots),previousPeriod);

@override
String toString() {
  return 'DiffWithPreviousMonthGraphState(loading: $loading, includeRecurring: $includeRecurring, currentPeriod: $currentPeriod, spots: $spots, previousPeriod: $previousPeriod)';
}


}

/// @nodoc
abstract mixin class $DiffWithPreviousMonthGraphStateCopyWith<$Res>  {
  factory $DiffWithPreviousMonthGraphStateCopyWith(DiffWithPreviousMonthGraphState value, $Res Function(DiffWithPreviousMonthGraphState) _then) = _$DiffWithPreviousMonthGraphStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool includeRecurring, DateTimeRange currentPeriod, List<List<FlSpot>> spots, DateTimeRange previousPeriod
});




}
/// @nodoc
class _$DiffWithPreviousMonthGraphStateCopyWithImpl<$Res>
    implements $DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  _$DiffWithPreviousMonthGraphStateCopyWithImpl(this._self, this._then);

  final DiffWithPreviousMonthGraphState _self;
  final $Res Function(DiffWithPreviousMonthGraphState) _then;

/// Create a copy of DiffWithPreviousMonthGraphState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? includeRecurring = null,Object? currentPeriod = null,Object? spots = null,Object? previousPeriod = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,includeRecurring: null == includeRecurring ? _self.includeRecurring : includeRecurring // ignore: cast_nullable_to_non_nullable
as bool,currentPeriod: null == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as DateTimeRange,spots: null == spots ? _self.spots : spots // ignore: cast_nullable_to_non_nullable
as List<List<FlSpot>>,previousPeriod: null == previousPeriod ? _self.previousPeriod : previousPeriod // ignore: cast_nullable_to_non_nullable
as DateTimeRange,
  ));
}

}


/// Adds pattern-matching-related methods to [DiffWithPreviousMonthGraphState].
extension DiffWithPreviousMonthGraphStatePatterns on DiffWithPreviousMonthGraphState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiffWithPreviousMonthGraphState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiffWithPreviousMonthGraphState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiffWithPreviousMonthGraphState value)  $default,){
final _that = this;
switch (_that) {
case _DiffWithPreviousMonthGraphState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiffWithPreviousMonthGraphState value)?  $default,){
final _that = this;
switch (_that) {
case _DiffWithPreviousMonthGraphState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool includeRecurring,  DateTimeRange currentPeriod,  List<List<FlSpot>> spots,  DateTimeRange previousPeriod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiffWithPreviousMonthGraphState() when $default != null:
return $default(_that.loading,_that.includeRecurring,_that.currentPeriod,_that.spots,_that.previousPeriod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool includeRecurring,  DateTimeRange currentPeriod,  List<List<FlSpot>> spots,  DateTimeRange previousPeriod)  $default,) {final _that = this;
switch (_that) {
case _DiffWithPreviousMonthGraphState():
return $default(_that.loading,_that.includeRecurring,_that.currentPeriod,_that.spots,_that.previousPeriod);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool includeRecurring,  DateTimeRange currentPeriod,  List<List<FlSpot>> spots,  DateTimeRange previousPeriod)?  $default,) {final _that = this;
switch (_that) {
case _DiffWithPreviousMonthGraphState() when $default != null:
return $default(_that.loading,_that.includeRecurring,_that.currentPeriod,_that.spots,_that.previousPeriod);case _:
  return null;

}
}

}

/// @nodoc


class _DiffWithPreviousMonthGraphState implements DiffWithPreviousMonthGraphState {
  const _DiffWithPreviousMonthGraphState({this.loading = true, required this.includeRecurring, required this.currentPeriod, final  List<List<FlSpot>> spots = const [], required this.previousPeriod}): _spots = spots;
  

@override@JsonKey() final  bool loading;
@override final  bool includeRecurring;
@override final  DateTimeRange currentPeriod;
 final  List<List<FlSpot>> _spots;
@override@JsonKey() List<List<FlSpot>> get spots {
  if (_spots is EqualUnmodifiableListView) return _spots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spots);
}

@override final  DateTimeRange previousPeriod;

/// Create a copy of DiffWithPreviousMonthGraphState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiffWithPreviousMonthGraphStateCopyWith<_DiffWithPreviousMonthGraphState> get copyWith => __$DiffWithPreviousMonthGraphStateCopyWithImpl<_DiffWithPreviousMonthGraphState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiffWithPreviousMonthGraphState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.includeRecurring, includeRecurring) || other.includeRecurring == includeRecurring)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod)&&const DeepCollectionEquality().equals(other._spots, _spots)&&(identical(other.previousPeriod, previousPeriod) || other.previousPeriod == previousPeriod));
}


@override
int get hashCode => Object.hash(runtimeType,loading,includeRecurring,currentPeriod,const DeepCollectionEquality().hash(_spots),previousPeriod);

@override
String toString() {
  return 'DiffWithPreviousMonthGraphState(loading: $loading, includeRecurring: $includeRecurring, currentPeriod: $currentPeriod, spots: $spots, previousPeriod: $previousPeriod)';
}


}

/// @nodoc
abstract mixin class _$DiffWithPreviousMonthGraphStateCopyWith<$Res> implements $DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  factory _$DiffWithPreviousMonthGraphStateCopyWith(_DiffWithPreviousMonthGraphState value, $Res Function(_DiffWithPreviousMonthGraphState) _then) = __$DiffWithPreviousMonthGraphStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool includeRecurring, DateTimeRange currentPeriod, List<List<FlSpot>> spots, DateTimeRange previousPeriod
});




}
/// @nodoc
class __$DiffWithPreviousMonthGraphStateCopyWithImpl<$Res>
    implements _$DiffWithPreviousMonthGraphStateCopyWith<$Res> {
  __$DiffWithPreviousMonthGraphStateCopyWithImpl(this._self, this._then);

  final _DiffWithPreviousMonthGraphState _self;
  final $Res Function(_DiffWithPreviousMonthGraphState) _then;

/// Create a copy of DiffWithPreviousMonthGraphState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? includeRecurring = null,Object? currentPeriod = null,Object? spots = null,Object? previousPeriod = null,}) {
  return _then(_DiffWithPreviousMonthGraphState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,includeRecurring: null == includeRecurring ? _self.includeRecurring : includeRecurring // ignore: cast_nullable_to_non_nullable
as bool,currentPeriod: null == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as DateTimeRange,spots: null == spots ? _self._spots : spots // ignore: cast_nullable_to_non_nullable
as List<List<FlSpot>>,previousPeriod: null == previousPeriod ? _self.previousPeriod : previousPeriod // ignore: cast_nullable_to_non_nullable
as DateTimeRange,
  ));
}


}

// dart format on
