// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParsedNotification implements DiagnosticableTreeMixin {

 String? get package; String? get title; String? get content; int get time; double get amountFound;@JsonKey(includeFromJson: false, includeToJson: false) String? get appName;@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? get icon;
/// Create a copy of ParsedNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedNotificationCopyWith<ParsedNotification> get copyWith => _$ParsedNotificationCopyWithImpl<ParsedNotification>(this as ParsedNotification, _$identity);

  /// Serializes this ParsedNotification to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ParsedNotification'))
    ..add(DiagnosticsProperty('package', package))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('content', content))..add(DiagnosticsProperty('time', time))..add(DiagnosticsProperty('amountFound', amountFound))..add(DiagnosticsProperty('appName', appName))..add(DiagnosticsProperty('icon', icon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedNotification&&(identical(other.package, package) || other.package == package)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.time, time) || other.time == time)&&(identical(other.amountFound, amountFound) || other.amountFound == amountFound)&&(identical(other.appName, appName) || other.appName == appName)&&const DeepCollectionEquality().equals(other.icon, icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,package,title,content,time,amountFound,appName,const DeepCollectionEquality().hash(icon));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ParsedNotification(package: $package, title: $title, content: $content, time: $time, amountFound: $amountFound, appName: $appName, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $ParsedNotificationCopyWith<$Res>  {
  factory $ParsedNotificationCopyWith(ParsedNotification value, $Res Function(ParsedNotification) _then) = _$ParsedNotificationCopyWithImpl;
@useResult
$Res call({
 String? package, String? title, String? content, int time, double amountFound,@JsonKey(includeFromJson: false, includeToJson: false) String? appName,@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? icon
});




}
/// @nodoc
class _$ParsedNotificationCopyWithImpl<$Res>
    implements $ParsedNotificationCopyWith<$Res> {
  _$ParsedNotificationCopyWithImpl(this._self, this._then);

  final ParsedNotification _self;
  final $Res Function(ParsedNotification) _then;

/// Create a copy of ParsedNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? package = freezed,Object? title = freezed,Object? content = freezed,Object? time = null,Object? amountFound = null,Object? appName = freezed,Object? icon = freezed,}) {
  return _then(_self.copyWith(
package: freezed == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,amountFound: null == amountFound ? _self.amountFound : amountFound // ignore: cast_nullable_to_non_nullable
as double,appName: freezed == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedNotification].
extension ParsedNotificationPatterns on ParsedNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedNotification value)  $default,){
final _that = this;
switch (_that) {
case _ParsedNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedNotification value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? package,  String? title,  String? content,  int time,  double amountFound, @JsonKey(includeFromJson: false, includeToJson: false)  String? appName, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParsedNotification() when $default != null:
return $default(_that.package,_that.title,_that.content,_that.time,_that.amountFound,_that.appName,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? package,  String? title,  String? content,  int time,  double amountFound, @JsonKey(includeFromJson: false, includeToJson: false)  String? appName, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? icon)  $default,) {final _that = this;
switch (_that) {
case _ParsedNotification():
return $default(_that.package,_that.title,_that.content,_that.time,_that.amountFound,_that.appName,_that.icon);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? package,  String? title,  String? content,  int time,  double amountFound, @JsonKey(includeFromJson: false, includeToJson: false)  String? appName, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? icon)?  $default,) {final _that = this;
switch (_that) {
case _ParsedNotification() when $default != null:
return $default(_that.package,_that.title,_that.content,_that.time,_that.amountFound,_that.appName,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParsedNotification with DiagnosticableTreeMixin implements ParsedNotification {
  const _ParsedNotification({this.package, this.title, this.content, required this.time, required this.amountFound, @JsonKey(includeFromJson: false, includeToJson: false) this.appName, @JsonKey(includeFromJson: false, includeToJson: false) this.icon});
  factory _ParsedNotification.fromJson(Map<String, dynamic> json) => _$ParsedNotificationFromJson(json);

@override final  String? package;
@override final  String? title;
@override final  String? content;
@override final  int time;
@override final  double amountFound;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? appName;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  Uint8List? icon;

/// Create a copy of ParsedNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedNotificationCopyWith<_ParsedNotification> get copyWith => __$ParsedNotificationCopyWithImpl<_ParsedNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParsedNotificationToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ParsedNotification'))
    ..add(DiagnosticsProperty('package', package))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('content', content))..add(DiagnosticsProperty('time', time))..add(DiagnosticsProperty('amountFound', amountFound))..add(DiagnosticsProperty('appName', appName))..add(DiagnosticsProperty('icon', icon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedNotification&&(identical(other.package, package) || other.package == package)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.time, time) || other.time == time)&&(identical(other.amountFound, amountFound) || other.amountFound == amountFound)&&(identical(other.appName, appName) || other.appName == appName)&&const DeepCollectionEquality().equals(other.icon, icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,package,title,content,time,amountFound,appName,const DeepCollectionEquality().hash(icon));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ParsedNotification(package: $package, title: $title, content: $content, time: $time, amountFound: $amountFound, appName: $appName, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$ParsedNotificationCopyWith<$Res> implements $ParsedNotificationCopyWith<$Res> {
  factory _$ParsedNotificationCopyWith(_ParsedNotification value, $Res Function(_ParsedNotification) _then) = __$ParsedNotificationCopyWithImpl;
@override @useResult
$Res call({
 String? package, String? title, String? content, int time, double amountFound,@JsonKey(includeFromJson: false, includeToJson: false) String? appName,@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? icon
});




}
/// @nodoc
class __$ParsedNotificationCopyWithImpl<$Res>
    implements _$ParsedNotificationCopyWith<$Res> {
  __$ParsedNotificationCopyWithImpl(this._self, this._then);

  final _ParsedNotification _self;
  final $Res Function(_ParsedNotification) _then;

/// Create a copy of ParsedNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? package = freezed,Object? title = freezed,Object? content = freezed,Object? time = null,Object? amountFound = null,Object? appName = freezed,Object? icon = freezed,}) {
  return _then(_ParsedNotification(
package: freezed == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,amountFound: null == amountFound ? _self.amountFound : amountFound // ignore: cast_nullable_to_non_nullable
as double,appName: freezed == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on
