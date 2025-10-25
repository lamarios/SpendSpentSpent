// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'username_password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsernamePasswordState {

 String? get token; OidcConfig? get oidcConfig; User? get user;
/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsernamePasswordStateCopyWith<UsernamePasswordState> get copyWith => _$UsernamePasswordStateCopyWithImpl<UsernamePasswordState>(this as UsernamePasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsernamePasswordState&&(identical(other.token, token) || other.token == token)&&(identical(other.oidcConfig, oidcConfig) || other.oidcConfig == oidcConfig)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,token,oidcConfig,user);

@override
String toString() {
  return 'UsernamePasswordState(token: $token, oidcConfig: $oidcConfig, user: $user)';
}


}

/// @nodoc
abstract mixin class $UsernamePasswordStateCopyWith<$Res>  {
  factory $UsernamePasswordStateCopyWith(UsernamePasswordState value, $Res Function(UsernamePasswordState) _then) = _$UsernamePasswordStateCopyWithImpl;
@useResult
$Res call({
 String? token, OidcConfig? oidcConfig, User? user
});


$OidcConfigCopyWith<$Res>? get oidcConfig;$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$UsernamePasswordStateCopyWithImpl<$Res>
    implements $UsernamePasswordStateCopyWith<$Res> {
  _$UsernamePasswordStateCopyWithImpl(this._self, this._then);

  final UsernamePasswordState _self;
  final $Res Function(UsernamePasswordState) _then;

/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = freezed,Object? oidcConfig = freezed,Object? user = freezed,}) {
  return _then(_self.copyWith(
token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,oidcConfig: freezed == oidcConfig ? _self.oidcConfig : oidcConfig // ignore: cast_nullable_to_non_nullable
as OidcConfig?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}
/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OidcConfigCopyWith<$Res>? get oidcConfig {
    if (_self.oidcConfig == null) {
    return null;
  }

  return $OidcConfigCopyWith<$Res>(_self.oidcConfig!, (value) {
    return _then(_self.copyWith(oidcConfig: value));
  });
}/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UsernamePasswordState].
extension UsernamePasswordStatePatterns on UsernamePasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsernamePasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsernamePasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsernamePasswordState value)  $default,){
final _that = this;
switch (_that) {
case _UsernamePasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsernamePasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _UsernamePasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? token,  OidcConfig? oidcConfig,  User? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsernamePasswordState() when $default != null:
return $default(_that.token,_that.oidcConfig,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? token,  OidcConfig? oidcConfig,  User? user)  $default,) {final _that = this;
switch (_that) {
case _UsernamePasswordState():
return $default(_that.token,_that.oidcConfig,_that.user);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? token,  OidcConfig? oidcConfig,  User? user)?  $default,) {final _that = this;
switch (_that) {
case _UsernamePasswordState() when $default != null:
return $default(_that.token,_that.oidcConfig,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _UsernamePasswordState implements UsernamePasswordState {
  const _UsernamePasswordState({this.token, this.oidcConfig, this.user});
  

@override final  String? token;
@override final  OidcConfig? oidcConfig;
@override final  User? user;

/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsernamePasswordStateCopyWith<_UsernamePasswordState> get copyWith => __$UsernamePasswordStateCopyWithImpl<_UsernamePasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsernamePasswordState&&(identical(other.token, token) || other.token == token)&&(identical(other.oidcConfig, oidcConfig) || other.oidcConfig == oidcConfig)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,token,oidcConfig,user);

@override
String toString() {
  return 'UsernamePasswordState(token: $token, oidcConfig: $oidcConfig, user: $user)';
}


}

/// @nodoc
abstract mixin class _$UsernamePasswordStateCopyWith<$Res> implements $UsernamePasswordStateCopyWith<$Res> {
  factory _$UsernamePasswordStateCopyWith(_UsernamePasswordState value, $Res Function(_UsernamePasswordState) _then) = __$UsernamePasswordStateCopyWithImpl;
@override @useResult
$Res call({
 String? token, OidcConfig? oidcConfig, User? user
});


@override $OidcConfigCopyWith<$Res>? get oidcConfig;@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$UsernamePasswordStateCopyWithImpl<$Res>
    implements _$UsernamePasswordStateCopyWith<$Res> {
  __$UsernamePasswordStateCopyWithImpl(this._self, this._then);

  final _UsernamePasswordState _self;
  final $Res Function(_UsernamePasswordState) _then;

/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = freezed,Object? oidcConfig = freezed,Object? user = freezed,}) {
  return _then(_UsernamePasswordState(
token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,oidcConfig: freezed == oidcConfig ? _self.oidcConfig : oidcConfig // ignore: cast_nullable_to_non_nullable
as OidcConfig?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}

/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OidcConfigCopyWith<$Res>? get oidcConfig {
    if (_self.oidcConfig == null) {
    return null;
  }

  return $OidcConfigCopyWith<$Res>(_self.oidcConfig!, (value) {
    return _then(_self.copyWith(oidcConfig: value));
  });
}/// Create a copy of UsernamePasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
