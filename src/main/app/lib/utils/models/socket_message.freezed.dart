// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SssSocketMessage {

 Map<String, dynamic> get message; SssSocketMessageType get type;
/// Create a copy of SssSocketMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SssSocketMessageCopyWith<SssSocketMessage> get copyWith => _$SssSocketMessageCopyWithImpl<SssSocketMessage>(this as SssSocketMessage, _$identity);

  /// Serializes this SssSocketMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SssSocketMessage&&const DeepCollectionEquality().equals(other.message, message)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(message),type);

@override
String toString() {
  return 'SssSocketMessage(message: $message, type: $type)';
}


}

/// @nodoc
abstract mixin class $SssSocketMessageCopyWith<$Res>  {
  factory $SssSocketMessageCopyWith(SssSocketMessage value, $Res Function(SssSocketMessage) _then) = _$SssSocketMessageCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> message, SssSocketMessageType type
});




}
/// @nodoc
class _$SssSocketMessageCopyWithImpl<$Res>
    implements $SssSocketMessageCopyWith<$Res> {
  _$SssSocketMessageCopyWithImpl(this._self, this._then);

  final SssSocketMessage _self;
  final $Res Function(SssSocketMessage) _then;

/// Create a copy of SssSocketMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? type = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SssSocketMessageType,
  ));
}

}


/// Adds pattern-matching-related methods to [SssSocketMessage].
extension SssSocketMessagePatterns on SssSocketMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SssSocketMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SssSocketMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SssSocketMessage value)  $default,){
final _that = this;
switch (_that) {
case _SssSocketMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SssSocketMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SssSocketMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> message,  SssSocketMessageType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SssSocketMessage() when $default != null:
return $default(_that.message,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> message,  SssSocketMessageType type)  $default,) {final _that = this;
switch (_that) {
case _SssSocketMessage():
return $default(_that.message,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> message,  SssSocketMessageType type)?  $default,) {final _that = this;
switch (_that) {
case _SssSocketMessage() when $default != null:
return $default(_that.message,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SssSocketMessage implements SssSocketMessage {
  const _SssSocketMessage({required final  Map<String, dynamic> message, required this.type}): _message = message;
  factory _SssSocketMessage.fromJson(Map<String, dynamic> json) => _$SssSocketMessageFromJson(json);

 final  Map<String, dynamic> _message;
@override Map<String, dynamic> get message {
  if (_message is EqualUnmodifiableMapView) return _message;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_message);
}

@override final  SssSocketMessageType type;

/// Create a copy of SssSocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SssSocketMessageCopyWith<_SssSocketMessage> get copyWith => __$SssSocketMessageCopyWithImpl<_SssSocketMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SssSocketMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SssSocketMessage&&const DeepCollectionEquality().equals(other._message, _message)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_message),type);

@override
String toString() {
  return 'SssSocketMessage(message: $message, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SssSocketMessageCopyWith<$Res> implements $SssSocketMessageCopyWith<$Res> {
  factory _$SssSocketMessageCopyWith(_SssSocketMessage value, $Res Function(_SssSocketMessage) _then) = __$SssSocketMessageCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> message, SssSocketMessageType type
});




}
/// @nodoc
class __$SssSocketMessageCopyWithImpl<$Res>
    implements _$SssSocketMessageCopyWith<$Res> {
  __$SssSocketMessageCopyWithImpl(this._self, this._then);

  final _SssSocketMessage _self;
  final $Res Function(_SssSocketMessage) _then;

/// Create a copy of SssSocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? type = null,}) {
  return _then(_SssSocketMessage(
message: null == message ? _self._message : message // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SssSocketMessageType,
  ));
}


}

// dart format on
