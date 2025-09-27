// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HouseholdState {

 Household? get household; List<HouseholdMembers> get invitations; Map<String, ColorScheme> get userLightColors; Map<String, ColorScheme> get userDarkColors; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdStateCopyWith<HouseholdState> get copyWith => _$HouseholdStateCopyWithImpl<HouseholdState>(this as HouseholdState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdState&&(identical(other.household, household) || other.household == household)&&const DeepCollectionEquality().equals(other.invitations, invitations)&&const DeepCollectionEquality().equals(other.userLightColors, userLightColors)&&const DeepCollectionEquality().equals(other.userDarkColors, userDarkColors)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,household,const DeepCollectionEquality().hash(invitations),const DeepCollectionEquality().hash(userLightColors),const DeepCollectionEquality().hash(userDarkColors),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'HouseholdState(household: $household, invitations: $invitations, userLightColors: $userLightColors, userDarkColors: $userDarkColors, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $HouseholdStateCopyWith<$Res>  {
  factory $HouseholdStateCopyWith(HouseholdState value, $Res Function(HouseholdState) _then) = _$HouseholdStateCopyWithImpl;
@useResult
$Res call({
 Household? household, List<HouseholdMembers> invitations, Map<String, ColorScheme> userLightColors, Map<String, ColorScheme> userDarkColors, dynamic error, StackTrace? stackTrace
});


$HouseholdCopyWith<$Res>? get household;

}
/// @nodoc
class _$HouseholdStateCopyWithImpl<$Res>
    implements $HouseholdStateCopyWith<$Res> {
  _$HouseholdStateCopyWithImpl(this._self, this._then);

  final HouseholdState _self;
  final $Res Function(HouseholdState) _then;

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? household = freezed,Object? invitations = null,Object? userLightColors = null,Object? userDarkColors = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
household: freezed == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household?,invitations: null == invitations ? _self.invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<HouseholdMembers>,userLightColors: null == userLightColors ? _self.userLightColors : userLightColors // ignore: cast_nullable_to_non_nullable
as Map<String, ColorScheme>,userDarkColors: null == userDarkColors ? _self.userDarkColors : userDarkColors // ignore: cast_nullable_to_non_nullable
as Map<String, ColorScheme>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}
/// Create a copy of HouseholdState
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


/// Adds pattern-matching-related methods to [HouseholdState].
extension HouseholdStatePatterns on HouseholdState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseholdState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseholdState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseholdState value)  $default,){
final _that = this;
switch (_that) {
case _HouseholdState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseholdState value)?  $default,){
final _that = this;
switch (_that) {
case _HouseholdState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Household? household,  List<HouseholdMembers> invitations,  Map<String, ColorScheme> userLightColors,  Map<String, ColorScheme> userDarkColors,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseholdState() when $default != null:
return $default(_that.household,_that.invitations,_that.userLightColors,_that.userDarkColors,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Household? household,  List<HouseholdMembers> invitations,  Map<String, ColorScheme> userLightColors,  Map<String, ColorScheme> userDarkColors,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _HouseholdState():
return $default(_that.household,_that.invitations,_that.userLightColors,_that.userDarkColors,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Household? household,  List<HouseholdMembers> invitations,  Map<String, ColorScheme> userLightColors,  Map<String, ColorScheme> userDarkColors,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _HouseholdState() when $default != null:
return $default(_that.household,_that.invitations,_that.userLightColors,_that.userDarkColors,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _HouseholdState extends HouseholdState implements WithError {
  const _HouseholdState({this.household, final  List<HouseholdMembers> invitations = const [], final  Map<String, ColorScheme> userLightColors = const {}, final  Map<String, ColorScheme> userDarkColors = const {}, this.error, this.stackTrace}): _invitations = invitations,_userLightColors = userLightColors,_userDarkColors = userDarkColors,super._();
  

@override final  Household? household;
 final  List<HouseholdMembers> _invitations;
@override@JsonKey() List<HouseholdMembers> get invitations {
  if (_invitations is EqualUnmodifiableListView) return _invitations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invitations);
}

 final  Map<String, ColorScheme> _userLightColors;
@override@JsonKey() Map<String, ColorScheme> get userLightColors {
  if (_userLightColors is EqualUnmodifiableMapView) return _userLightColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_userLightColors);
}

 final  Map<String, ColorScheme> _userDarkColors;
@override@JsonKey() Map<String, ColorScheme> get userDarkColors {
  if (_userDarkColors is EqualUnmodifiableMapView) return _userDarkColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_userDarkColors);
}

@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdStateCopyWith<_HouseholdState> get copyWith => __$HouseholdStateCopyWithImpl<_HouseholdState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseholdState&&(identical(other.household, household) || other.household == household)&&const DeepCollectionEquality().equals(other._invitations, _invitations)&&const DeepCollectionEquality().equals(other._userLightColors, _userLightColors)&&const DeepCollectionEquality().equals(other._userDarkColors, _userDarkColors)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,household,const DeepCollectionEquality().hash(_invitations),const DeepCollectionEquality().hash(_userLightColors),const DeepCollectionEquality().hash(_userDarkColors),const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'HouseholdState(household: $household, invitations: $invitations, userLightColors: $userLightColors, userDarkColors: $userDarkColors, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$HouseholdStateCopyWith<$Res> implements $HouseholdStateCopyWith<$Res> {
  factory _$HouseholdStateCopyWith(_HouseholdState value, $Res Function(_HouseholdState) _then) = __$HouseholdStateCopyWithImpl;
@override @useResult
$Res call({
 Household? household, List<HouseholdMembers> invitations, Map<String, ColorScheme> userLightColors, Map<String, ColorScheme> userDarkColors, dynamic error, StackTrace? stackTrace
});


@override $HouseholdCopyWith<$Res>? get household;

}
/// @nodoc
class __$HouseholdStateCopyWithImpl<$Res>
    implements _$HouseholdStateCopyWith<$Res> {
  __$HouseholdStateCopyWithImpl(this._self, this._then);

  final _HouseholdState _self;
  final $Res Function(_HouseholdState) _then;

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? household = freezed,Object? invitations = null,Object? userLightColors = null,Object? userDarkColors = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_HouseholdState(
household: freezed == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household?,invitations: null == invitations ? _self._invitations : invitations // ignore: cast_nullable_to_non_nullable
as List<HouseholdMembers>,userLightColors: null == userLightColors ? _self._userLightColors : userLightColors // ignore: cast_nullable_to_non_nullable
as Map<String, ColorScheme>,userDarkColors: null == userDarkColors ? _self._userDarkColors : userDarkColors // ignore: cast_nullable_to_non_nullable
as Map<String, ColorScheme>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

/// Create a copy of HouseholdState
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
