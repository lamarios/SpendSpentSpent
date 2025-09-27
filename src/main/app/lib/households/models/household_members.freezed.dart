// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household_members.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HouseholdMembers {

 String get id; User get user; User? get invitedBy; HouseholdInviteStatus get status; HouseholdColor get color; bool get admin;
/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdMembersCopyWith<HouseholdMembers> get copyWith => _$HouseholdMembersCopyWithImpl<HouseholdMembers>(this as HouseholdMembers, _$identity);

  /// Serializes this HouseholdMembers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdMembers&&(identical(other.id, id) || other.id == id)&&(identical(other.user, user) || other.user == user)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.color, color) || other.color == color)&&(identical(other.admin, admin) || other.admin == admin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user,invitedBy,status,color,admin);

@override
String toString() {
  return 'HouseholdMembers(id: $id, user: $user, invitedBy: $invitedBy, status: $status, color: $color, admin: $admin)';
}


}

/// @nodoc
abstract mixin class $HouseholdMembersCopyWith<$Res>  {
  factory $HouseholdMembersCopyWith(HouseholdMembers value, $Res Function(HouseholdMembers) _then) = _$HouseholdMembersCopyWithImpl;
@useResult
$Res call({
 String id, User user, User? invitedBy, HouseholdInviteStatus status, HouseholdColor color, bool admin
});


$UserCopyWith<$Res> get user;$UserCopyWith<$Res>? get invitedBy;

}
/// @nodoc
class _$HouseholdMembersCopyWithImpl<$Res>
    implements $HouseholdMembersCopyWith<$Res> {
  _$HouseholdMembersCopyWithImpl(this._self, this._then);

  final HouseholdMembers _self;
  final $Res Function(HouseholdMembers) _then;

/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? user = null,Object? invitedBy = freezed,Object? status = null,Object? color = null,Object? admin = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as User?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HouseholdInviteStatus,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as HouseholdColor,admin: null == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get invitedBy {
    if (_self.invitedBy == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.invitedBy!, (value) {
    return _then(_self.copyWith(invitedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [HouseholdMembers].
extension HouseholdMembersPatterns on HouseholdMembers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseholdMembers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseholdMembers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseholdMembers value)  $default,){
final _that = this;
switch (_that) {
case _HouseholdMembers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseholdMembers value)?  $default,){
final _that = this;
switch (_that) {
case _HouseholdMembers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  User user,  User? invitedBy,  HouseholdInviteStatus status,  HouseholdColor color,  bool admin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseholdMembers() when $default != null:
return $default(_that.id,_that.user,_that.invitedBy,_that.status,_that.color,_that.admin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  User user,  User? invitedBy,  HouseholdInviteStatus status,  HouseholdColor color,  bool admin)  $default,) {final _that = this;
switch (_that) {
case _HouseholdMembers():
return $default(_that.id,_that.user,_that.invitedBy,_that.status,_that.color,_that.admin);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  User user,  User? invitedBy,  HouseholdInviteStatus status,  HouseholdColor color,  bool admin)?  $default,) {final _that = this;
switch (_that) {
case _HouseholdMembers() when $default != null:
return $default(_that.id,_that.user,_that.invitedBy,_that.status,_that.color,_that.admin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HouseholdMembers implements HouseholdMembers {
  const _HouseholdMembers({required this.id, required this.user, this.invitedBy, required this.status, required this.color, this.admin = false});
  factory _HouseholdMembers.fromJson(Map<String, dynamic> json) => _$HouseholdMembersFromJson(json);

@override final  String id;
@override final  User user;
@override final  User? invitedBy;
@override final  HouseholdInviteStatus status;
@override final  HouseholdColor color;
@override@JsonKey() final  bool admin;

/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdMembersCopyWith<_HouseholdMembers> get copyWith => __$HouseholdMembersCopyWithImpl<_HouseholdMembers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseholdMembersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseholdMembers&&(identical(other.id, id) || other.id == id)&&(identical(other.user, user) || other.user == user)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.color, color) || other.color == color)&&(identical(other.admin, admin) || other.admin == admin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,user,invitedBy,status,color,admin);

@override
String toString() {
  return 'HouseholdMembers(id: $id, user: $user, invitedBy: $invitedBy, status: $status, color: $color, admin: $admin)';
}


}

/// @nodoc
abstract mixin class _$HouseholdMembersCopyWith<$Res> implements $HouseholdMembersCopyWith<$Res> {
  factory _$HouseholdMembersCopyWith(_HouseholdMembers value, $Res Function(_HouseholdMembers) _then) = __$HouseholdMembersCopyWithImpl;
@override @useResult
$Res call({
 String id, User user, User? invitedBy, HouseholdInviteStatus status, HouseholdColor color, bool admin
});


@override $UserCopyWith<$Res> get user;@override $UserCopyWith<$Res>? get invitedBy;

}
/// @nodoc
class __$HouseholdMembersCopyWithImpl<$Res>
    implements _$HouseholdMembersCopyWith<$Res> {
  __$HouseholdMembersCopyWithImpl(this._self, this._then);

  final _HouseholdMembers _self;
  final $Res Function(_HouseholdMembers) _then;

/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? user = null,Object? invitedBy = freezed,Object? status = null,Object? color = null,Object? admin = null,}) {
  return _then(_HouseholdMembers(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as User?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HouseholdInviteStatus,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as HouseholdColor,admin: null == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of HouseholdMembers
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get invitedBy {
    if (_self.invitedBy == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.invitedBy!, (value) {
    return _then(_self.copyWith(invitedBy: value));
  });
}
}

// dart format on
