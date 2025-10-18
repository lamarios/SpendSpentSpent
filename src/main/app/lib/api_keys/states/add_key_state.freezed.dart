// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_key_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddKeyState {

 String get name; KeyExpiryPreset get expiry;
/// Create a copy of AddKeyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddKeyStateCopyWith<AddKeyState> get copyWith => _$AddKeyStateCopyWithImpl<AddKeyState>(this as AddKeyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddKeyState&&(identical(other.name, name) || other.name == name)&&(identical(other.expiry, expiry) || other.expiry == expiry));
}


@override
int get hashCode => Object.hash(runtimeType,name,expiry);

@override
String toString() {
  return 'AddKeyState(name: $name, expiry: $expiry)';
}


}

/// @nodoc
abstract mixin class $AddKeyStateCopyWith<$Res>  {
  factory $AddKeyStateCopyWith(AddKeyState value, $Res Function(AddKeyState) _then) = _$AddKeyStateCopyWithImpl;
@useResult
$Res call({
 String name, KeyExpiryPreset expiry
});




}
/// @nodoc
class _$AddKeyStateCopyWithImpl<$Res>
    implements $AddKeyStateCopyWith<$Res> {
  _$AddKeyStateCopyWithImpl(this._self, this._then);

  final AddKeyState _self;
  final $Res Function(AddKeyState) _then;

/// Create a copy of AddKeyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? expiry = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expiry: null == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as KeyExpiryPreset,
  ));
}

}


/// Adds pattern-matching-related methods to [AddKeyState].
extension AddKeyStatePatterns on AddKeyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddKeyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddKeyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddKeyState value)  $default,){
final _that = this;
switch (_that) {
case _AddKeyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddKeyState value)?  $default,){
final _that = this;
switch (_that) {
case _AddKeyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  KeyExpiryPreset expiry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddKeyState() when $default != null:
return $default(_that.name,_that.expiry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  KeyExpiryPreset expiry)  $default,) {final _that = this;
switch (_that) {
case _AddKeyState():
return $default(_that.name,_that.expiry);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  KeyExpiryPreset expiry)?  $default,) {final _that = this;
switch (_that) {
case _AddKeyState() when $default != null:
return $default(_that.name,_that.expiry);case _:
  return null;

}
}

}

/// @nodoc


class _AddKeyState implements AddKeyState {
  const _AddKeyState({this.name = "", this.expiry = KeyExpiryPreset.days7});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  KeyExpiryPreset expiry;

/// Create a copy of AddKeyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddKeyStateCopyWith<_AddKeyState> get copyWith => __$AddKeyStateCopyWithImpl<_AddKeyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddKeyState&&(identical(other.name, name) || other.name == name)&&(identical(other.expiry, expiry) || other.expiry == expiry));
}


@override
int get hashCode => Object.hash(runtimeType,name,expiry);

@override
String toString() {
  return 'AddKeyState(name: $name, expiry: $expiry)';
}


}

/// @nodoc
abstract mixin class _$AddKeyStateCopyWith<$Res> implements $AddKeyStateCopyWith<$Res> {
  factory _$AddKeyStateCopyWith(_AddKeyState value, $Res Function(_AddKeyState) _then) = __$AddKeyStateCopyWithImpl;
@override @useResult
$Res call({
 String name, KeyExpiryPreset expiry
});




}
/// @nodoc
class __$AddKeyStateCopyWithImpl<$Res>
    implements _$AddKeyStateCopyWith<$Res> {
  __$AddKeyStateCopyWithImpl(this._self, this._then);

  final _AddKeyState _self;
  final $Res Function(_AddKeyState) _then;

/// Create a copy of AddKeyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? expiry = null,}) {
  return _then(_AddKeyState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expiry: null == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as KeyExpiryPreset,
  ));
}


}

// dart format on
