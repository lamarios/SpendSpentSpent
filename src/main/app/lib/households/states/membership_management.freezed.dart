// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_management.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipManagementState {

 bool get admin; HouseholdColor get color;
/// Create a copy of MembershipManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipManagementStateCopyWith<MembershipManagementState> get copyWith => _$MembershipManagementStateCopyWithImpl<MembershipManagementState>(this as MembershipManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipManagementState&&(identical(other.admin, admin) || other.admin == admin)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,admin,color);

@override
String toString() {
  return 'MembershipManagementState(admin: $admin, color: $color)';
}


}

/// @nodoc
abstract mixin class $MembershipManagementStateCopyWith<$Res>  {
  factory $MembershipManagementStateCopyWith(MembershipManagementState value, $Res Function(MembershipManagementState) _then) = _$MembershipManagementStateCopyWithImpl;
@useResult
$Res call({
 bool admin, HouseholdColor color
});




}
/// @nodoc
class _$MembershipManagementStateCopyWithImpl<$Res>
    implements $MembershipManagementStateCopyWith<$Res> {
  _$MembershipManagementStateCopyWithImpl(this._self, this._then);

  final MembershipManagementState _self;
  final $Res Function(MembershipManagementState) _then;

/// Create a copy of MembershipManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? admin = null,Object? color = null,}) {
  return _then(_self.copyWith(
admin: null == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as HouseholdColor,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipManagementState].
extension MembershipManagementStatePatterns on MembershipManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipManagementState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool admin,  HouseholdColor color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipManagementState() when $default != null:
return $default(_that.admin,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool admin,  HouseholdColor color)  $default,) {final _that = this;
switch (_that) {
case _MembershipManagementState():
return $default(_that.admin,_that.color);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool admin,  HouseholdColor color)?  $default,) {final _that = this;
switch (_that) {
case _MembershipManagementState() when $default != null:
return $default(_that.admin,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipManagementState implements MembershipManagementState {
  const _MembershipManagementState({required this.admin, required this.color});
  

@override final  bool admin;
@override final  HouseholdColor color;

/// Create a copy of MembershipManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipManagementStateCopyWith<_MembershipManagementState> get copyWith => __$MembershipManagementStateCopyWithImpl<_MembershipManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipManagementState&&(identical(other.admin, admin) || other.admin == admin)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,admin,color);

@override
String toString() {
  return 'MembershipManagementState(admin: $admin, color: $color)';
}


}

/// @nodoc
abstract mixin class _$MembershipManagementStateCopyWith<$Res> implements $MembershipManagementStateCopyWith<$Res> {
  factory _$MembershipManagementStateCopyWith(_MembershipManagementState value, $Res Function(_MembershipManagementState) _then) = __$MembershipManagementStateCopyWithImpl;
@override @useResult
$Res call({
 bool admin, HouseholdColor color
});




}
/// @nodoc
class __$MembershipManagementStateCopyWithImpl<$Res>
    implements _$MembershipManagementStateCopyWith<$Res> {
  __$MembershipManagementStateCopyWithImpl(this._self, this._then);

  final _MembershipManagementState _self;
  final $Res Function(_MembershipManagementState) _then;

/// Create a copy of MembershipManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? admin = null,Object? color = null,}) {
  return _then(_MembershipManagementState(
admin: null == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as HouseholdColor,
  ));
}


}

// dart format on
