// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household_management.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HouseholdManagementState {

 Household? get household; List<HouseholdMembers> get invitations; bool get loading; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of HouseholdManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdManagementStateCopyWith<HouseholdManagementState> get copyWith => _$HouseholdManagementStateCopyWithImpl<HouseholdManagementState>(this as HouseholdManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdManagementState&&(identical(other.household, household) || other.household == household)&&const DeepCollectionEquality().equals(other.invitations, invitations)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,household,const DeepCollectionEquality().hash(invitations),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'HouseholdManagementState(household: $household, invitations: $invitations, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $HouseholdManagementStateCopyWith<$Res>  {
  factory $HouseholdManagementStateCopyWith(HouseholdManagementState value, $Res Function(HouseholdManagementState) _then) = _$HouseholdManagementStateCopyWithImpl;
@useResult
$Res call({
 Household? household, List<HouseholdMembers> invitations, bool loading, dynamic error, StackTrace? stackTrace
});


$HouseholdCopyWith<$Res>? get household;

}
/// @nodoc
class _$HouseholdManagementStateCopyWithImpl<$Res>
    implements $HouseholdManagementStateCopyWith<$Res> {
  _$HouseholdManagementStateCopyWithImpl(this._self, this._then);

  final HouseholdManagementState _self;
  final $Res Function(HouseholdManagementState) _then;

/// Create a copy of HouseholdManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? household = freezed,Object? invitations = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
household: freezed == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household?,invitations: null == invitations ? _self.invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<HouseholdMembers>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}
/// Create a copy of HouseholdManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdCopyWith<$Res>? get household {
    if (_self.household == null) {
    return null;
  }

  return $HouseholdCopyWith<$Res>(_self.household!, (value) {
    return _then(_self.copyWith(household: value));
  });
}
}


/// Adds pattern-matching-related methods to [HouseholdManagementState].
extension HouseholdManagementStatePatterns on HouseholdManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseholdManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseholdManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseholdManagementState value)  $default,){
final _that = this;
switch (_that) {
case _HouseholdManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseholdManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _HouseholdManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Household? household,  List<HouseholdMembers> invitations,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseholdManagementState() when $default != null:
return $default(_that.household,_that.invitations,_that.loading,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Household? household,  List<HouseholdMembers> invitations,  bool loading,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _HouseholdManagementState():
return $default(_that.household,_that.invitations,_that.loading,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Household? household,  List<HouseholdMembers> invitations,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _HouseholdManagementState() when $default != null:
return $default(_that.household,_that.invitations,_that.loading,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _HouseholdManagementState implements HouseholdManagementState, WithError {
  const _HouseholdManagementState({this.household, final  List<HouseholdMembers> invitations = const [], this.loading = false, this.error, this.stackTrace}): _invitations = invitations;
  

@override final  Household? household;
 final  List<HouseholdMembers> _invitations;
@override@JsonKey() List<HouseholdMembers> get invitations {
  if (_invitations is EqualUnmodifiableListView) return _invitations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invitations);
}

@override@JsonKey() final  bool loading;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of HouseholdManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdManagementStateCopyWith<_HouseholdManagementState> get copyWith => __$HouseholdManagementStateCopyWithImpl<_HouseholdManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseholdManagementState&&(identical(other.household, household) || other.household == household)&&const DeepCollectionEquality().equals(other._invitations, _invitations)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,household,const DeepCollectionEquality().hash(_invitations),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'HouseholdManagementState(household: $household, invitations: $invitations, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$HouseholdManagementStateCopyWith<$Res> implements $HouseholdManagementStateCopyWith<$Res> {
  factory _$HouseholdManagementStateCopyWith(_HouseholdManagementState value, $Res Function(_HouseholdManagementState) _then) = __$HouseholdManagementStateCopyWithImpl;
@override @useResult
$Res call({
 Household? household, List<HouseholdMembers> invitations, bool loading, dynamic error, StackTrace? stackTrace
});


@override $HouseholdCopyWith<$Res>? get household;

}
/// @nodoc
class __$HouseholdManagementStateCopyWithImpl<$Res>
    implements _$HouseholdManagementStateCopyWith<$Res> {
  __$HouseholdManagementStateCopyWithImpl(this._self, this._then);

  final _HouseholdManagementState _self;
  final $Res Function(_HouseholdManagementState) _then;

/// Create a copy of HouseholdManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? household = freezed,Object? invitations = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_HouseholdManagementState(
household: freezed == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household?,invitations: null == invitations ? _self._invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<HouseholdMembers>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

/// Create a copy of HouseholdManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdCopyWith<$Res>? get household {
    if (_self.household == null) {
    return null;
  }

  return $HouseholdCopyWith<$Res>(_self.household!, (value) {
    return _then(_self.copyWith(household: value));
  });
}
}

// dart format on
