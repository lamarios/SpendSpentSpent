// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_key_management.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiKeyManagementState {

 List<ApiKey> get keys; bool get loading; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of ApiKeyManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiKeyManagementStateCopyWith<ApiKeyManagementState> get copyWith => _$ApiKeyManagementStateCopyWithImpl<ApiKeyManagementState>(this as ApiKeyManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiKeyManagementState&&const DeepCollectionEquality().equals(other.keys, keys)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(keys),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'ApiKeyManagementState(keys: $keys, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $ApiKeyManagementStateCopyWith<$Res>  {
  factory $ApiKeyManagementStateCopyWith(ApiKeyManagementState value, $Res Function(ApiKeyManagementState) _then) = _$ApiKeyManagementStateCopyWithImpl;
@useResult
$Res call({
 List<ApiKey> keys, bool loading, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$ApiKeyManagementStateCopyWithImpl<$Res>
    implements $ApiKeyManagementStateCopyWith<$Res> {
  _$ApiKeyManagementStateCopyWithImpl(this._self, this._then);

  final ApiKeyManagementState _self;
  final $Res Function(ApiKeyManagementState) _then;

/// Create a copy of ApiKeyManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keys = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
keys: null == keys ? _self.keys : keys // ignore: cast_nullable_to_non_nullable
as List<ApiKey>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiKeyManagementState].
extension ApiKeyManagementStatePatterns on ApiKeyManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiKeyManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiKeyManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiKeyManagementState value)  $default,){
final _that = this;
switch (_that) {
case _ApiKeyManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiKeyManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _ApiKeyManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ApiKey> keys,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiKeyManagementState() when $default != null:
return $default(_that.keys,_that.loading,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ApiKey> keys,  bool loading,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _ApiKeyManagementState():
return $default(_that.keys,_that.loading,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ApiKey> keys,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _ApiKeyManagementState() when $default != null:
return $default(_that.keys,_that.loading,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _ApiKeyManagementState implements ApiKeyManagementState, WithError {
  const _ApiKeyManagementState({final  List<ApiKey> keys = const [], this.loading = true, this.error, this.stackTrace}): _keys = keys;
  

 final  List<ApiKey> _keys;
@override@JsonKey() List<ApiKey> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}

@override@JsonKey() final  bool loading;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of ApiKeyManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiKeyManagementStateCopyWith<_ApiKeyManagementState> get copyWith => __$ApiKeyManagementStateCopyWithImpl<_ApiKeyManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiKeyManagementState&&const DeepCollectionEquality().equals(other._keys, _keys)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_keys),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'ApiKeyManagementState(keys: $keys, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$ApiKeyManagementStateCopyWith<$Res> implements $ApiKeyManagementStateCopyWith<$Res> {
  factory _$ApiKeyManagementStateCopyWith(_ApiKeyManagementState value, $Res Function(_ApiKeyManagementState) _then) = __$ApiKeyManagementStateCopyWithImpl;
@override @useResult
$Res call({
 List<ApiKey> keys, bool loading, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$ApiKeyManagementStateCopyWithImpl<$Res>
    implements _$ApiKeyManagementStateCopyWith<$Res> {
  __$ApiKeyManagementStateCopyWithImpl(this._self, this._then);

  final _ApiKeyManagementState _self;
  final $Res Function(_ApiKeyManagementState) _then;

/// Create a copy of ApiKeyManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keys = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_ApiKeyManagementState(
keys: null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<ApiKey>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
