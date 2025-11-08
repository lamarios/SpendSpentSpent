// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_tapped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationTappedState {

 int get time; double get amount;
/// Create a copy of NotificationTappedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTappedStateCopyWith<NotificationTappedState> get copyWith => _$NotificationTappedStateCopyWithImpl<NotificationTappedState>(this as NotificationTappedState, _$identity);

  /// Serializes this NotificationTappedState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTappedState&&(identical(other.time, time) || other.time == time)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,amount);

@override
String toString() {
  return 'NotificationTappedState(time: $time, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $NotificationTappedStateCopyWith<$Res>  {
  factory $NotificationTappedStateCopyWith(NotificationTappedState value, $Res Function(NotificationTappedState) _then) = _$NotificationTappedStateCopyWithImpl;
@useResult
$Res call({
 int time, double amount
});




}
/// @nodoc
class _$NotificationTappedStateCopyWithImpl<$Res>
    implements $NotificationTappedStateCopyWith<$Res> {
  _$NotificationTappedStateCopyWithImpl(this._self, this._then);

  final NotificationTappedState _self;
  final $Res Function(NotificationTappedState) _then;

/// Create a copy of NotificationTappedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? amount = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationTappedState].
extension NotificationTappedStatePatterns on NotificationTappedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationTappedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationTappedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationTappedState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationTappedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationTappedState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationTappedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int time,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTappedState() when $default != null:
return $default(_that.time,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int time,  double amount)  $default,) {final _that = this;
switch (_that) {
case _NotificationTappedState():
return $default(_that.time,_that.amount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int time,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTappedState() when $default != null:
return $default(_that.time,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTappedState implements NotificationTappedState {
  const _NotificationTappedState({required this.time, required this.amount});
  factory _NotificationTappedState.fromJson(Map<String, dynamic> json) => _$NotificationTappedStateFromJson(json);

@override final  int time;
@override final  double amount;

/// Create a copy of NotificationTappedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationTappedStateCopyWith<_NotificationTappedState> get copyWith => __$NotificationTappedStateCopyWithImpl<_NotificationTappedState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationTappedStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTappedState&&(identical(other.time, time) || other.time == time)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,amount);

@override
String toString() {
  return 'NotificationTappedState(time: $time, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$NotificationTappedStateCopyWith<$Res> implements $NotificationTappedStateCopyWith<$Res> {
  factory _$NotificationTappedStateCopyWith(_NotificationTappedState value, $Res Function(_NotificationTappedState) _then) = __$NotificationTappedStateCopyWithImpl;
@override @useResult
$Res call({
 int time, double amount
});




}
/// @nodoc
class __$NotificationTappedStateCopyWithImpl<$Res>
    implements _$NotificationTappedStateCopyWith<$Res> {
  __$NotificationTappedStateCopyWithImpl(this._self, this._then);

  final _NotificationTappedState _self;
  final $Res Function(_NotificationTappedState) _then;

/// Create a copy of NotificationTappedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? amount = null,}) {
  return _then(_NotificationTappedState(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
