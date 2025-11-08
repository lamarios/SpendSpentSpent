// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_listener_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationListenerSettingsState {

 bool get enabled; List<ParsedNotification> get history; List<String> get ignoreList;
/// Create a copy of NotificationListenerSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListenerSettingsStateCopyWith<NotificationListenerSettingsState> get copyWith => _$NotificationListenerSettingsStateCopyWithImpl<NotificationListenerSettingsState>(this as NotificationListenerSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListenerSettingsState&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.history, history)&&const DeepCollectionEquality().equals(other.ignoreList, ignoreList));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(history),const DeepCollectionEquality().hash(ignoreList));

@override
String toString() {
  return 'NotificationListenerSettingsState(enabled: $enabled, history: $history, ignoreList: $ignoreList)';
}


}

/// @nodoc
abstract mixin class $NotificationListenerSettingsStateCopyWith<$Res>  {
  factory $NotificationListenerSettingsStateCopyWith(NotificationListenerSettingsState value, $Res Function(NotificationListenerSettingsState) _then) = _$NotificationListenerSettingsStateCopyWithImpl;
@useResult
$Res call({
 bool enabled, List<ParsedNotification> history, List<String> ignoreList
});




}
/// @nodoc
class _$NotificationListenerSettingsStateCopyWithImpl<$Res>
    implements $NotificationListenerSettingsStateCopyWith<$Res> {
  _$NotificationListenerSettingsStateCopyWithImpl(this._self, this._then);

  final NotificationListenerSettingsState _self;
  final $Res Function(NotificationListenerSettingsState) _then;

/// Create a copy of NotificationListenerSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? history = null,Object? ignoreList = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ParsedNotification>,ignoreList: null == ignoreList ? _self.ignoreList : ignoreList // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationListenerSettingsState].
extension NotificationListenerSettingsStatePatterns on NotificationListenerSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationListenerSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationListenerSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationListenerSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationListenerSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationListenerSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationListenerSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  List<ParsedNotification> history,  List<String> ignoreList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListenerSettingsState() when $default != null:
return $default(_that.enabled,_that.history,_that.ignoreList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  List<ParsedNotification> history,  List<String> ignoreList)  $default,) {final _that = this;
switch (_that) {
case _NotificationListenerSettingsState():
return $default(_that.enabled,_that.history,_that.ignoreList);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  List<ParsedNotification> history,  List<String> ignoreList)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListenerSettingsState() when $default != null:
return $default(_that.enabled,_that.history,_that.ignoreList);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationListenerSettingsState implements NotificationListenerSettingsState {
  const _NotificationListenerSettingsState({this.enabled = false, final  List<ParsedNotification> history = const [], final  List<String> ignoreList = const []}): _history = history,_ignoreList = ignoreList;
  

@override@JsonKey() final  bool enabled;
 final  List<ParsedNotification> _history;
@override@JsonKey() List<ParsedNotification> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

 final  List<String> _ignoreList;
@override@JsonKey() List<String> get ignoreList {
  if (_ignoreList is EqualUnmodifiableListView) return _ignoreList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ignoreList);
}


/// Create a copy of NotificationListenerSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationListenerSettingsStateCopyWith<_NotificationListenerSettingsState> get copyWith => __$NotificationListenerSettingsStateCopyWithImpl<_NotificationListenerSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListenerSettingsState&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._history, _history)&&const DeepCollectionEquality().equals(other._ignoreList, _ignoreList));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(_history),const DeepCollectionEquality().hash(_ignoreList));

@override
String toString() {
  return 'NotificationListenerSettingsState(enabled: $enabled, history: $history, ignoreList: $ignoreList)';
}


}

/// @nodoc
abstract mixin class _$NotificationListenerSettingsStateCopyWith<$Res> implements $NotificationListenerSettingsStateCopyWith<$Res> {
  factory _$NotificationListenerSettingsStateCopyWith(_NotificationListenerSettingsState value, $Res Function(_NotificationListenerSettingsState) _then) = __$NotificationListenerSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, List<ParsedNotification> history, List<String> ignoreList
});




}
/// @nodoc
class __$NotificationListenerSettingsStateCopyWithImpl<$Res>
    implements _$NotificationListenerSettingsStateCopyWith<$Res> {
  __$NotificationListenerSettingsStateCopyWithImpl(this._self, this._then);

  final _NotificationListenerSettingsState _self;
  final $Res Function(_NotificationListenerSettingsState) _then;

/// Create a copy of NotificationListenerSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? history = null,Object? ignoreList = null,}) {
  return _then(_NotificationListenerSettingsState(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ParsedNotification>,ignoreList: null == ignoreList ? _self._ignoreList : ignoreList // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
