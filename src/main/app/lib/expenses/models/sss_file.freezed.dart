// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sss_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SssFile {

 String get id; String get userId; int? get expenseId; AiProcessingStatus get status; List<String> get aiTags; String get fileName; int get timeCreated; int get timeUpdated;
/// Create a copy of SssFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SssFileCopyWith<SssFile> get copyWith => _$SssFileCopyWithImpl<SssFile>(this as SssFile, _$identity);

  /// Serializes this SssFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SssFile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.aiTags, aiTags)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.timeCreated, timeCreated) || other.timeCreated == timeCreated)&&(identical(other.timeUpdated, timeUpdated) || other.timeUpdated == timeUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,expenseId,status,const DeepCollectionEquality().hash(aiTags),fileName,timeCreated,timeUpdated);

@override
String toString() {
  return 'SssFile(id: $id, userId: $userId, expenseId: $expenseId, status: $status, aiTags: $aiTags, fileName: $fileName, timeCreated: $timeCreated, timeUpdated: $timeUpdated)';
}


}

/// @nodoc
abstract mixin class $SssFileCopyWith<$Res>  {
  factory $SssFileCopyWith(SssFile value, $Res Function(SssFile) _then) = _$SssFileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int? expenseId, AiProcessingStatus status, List<String> aiTags, String fileName, int timeCreated, int timeUpdated
});




}
/// @nodoc
class _$SssFileCopyWithImpl<$Res>
    implements $SssFileCopyWith<$Res> {
  _$SssFileCopyWithImpl(this._self, this._then);

  final SssFile _self;
  final $Res Function(SssFile) _then;

/// Create a copy of SssFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? expenseId = freezed,Object? status = null,Object? aiTags = null,Object? fileName = null,Object? timeCreated = null,Object? timeUpdated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiProcessingStatus,aiTags: null == aiTags ? _self.aiTags : aiTags // ignore: cast_nullable_to_non_nullable
as List<String>,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,timeCreated: null == timeCreated ? _self.timeCreated : timeCreated // ignore: cast_nullable_to_non_nullable
as int,timeUpdated: null == timeUpdated ? _self.timeUpdated : timeUpdated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SssFile].
extension SssFilePatterns on SssFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SssFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SssFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SssFile value)  $default,){
final _that = this;
switch (_that) {
case _SssFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SssFile value)?  $default,){
final _that = this;
switch (_that) {
case _SssFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int? expenseId,  AiProcessingStatus status,  List<String> aiTags,  String fileName,  int timeCreated,  int timeUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SssFile() when $default != null:
return $default(_that.id,_that.userId,_that.expenseId,_that.status,_that.aiTags,_that.fileName,_that.timeCreated,_that.timeUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int? expenseId,  AiProcessingStatus status,  List<String> aiTags,  String fileName,  int timeCreated,  int timeUpdated)  $default,) {final _that = this;
switch (_that) {
case _SssFile():
return $default(_that.id,_that.userId,_that.expenseId,_that.status,_that.aiTags,_that.fileName,_that.timeCreated,_that.timeUpdated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int? expenseId,  AiProcessingStatus status,  List<String> aiTags,  String fileName,  int timeCreated,  int timeUpdated)?  $default,) {final _that = this;
switch (_that) {
case _SssFile() when $default != null:
return $default(_that.id,_that.userId,_that.expenseId,_that.status,_that.aiTags,_that.fileName,_that.timeCreated,_that.timeUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SssFile extends SssFile {
  const _SssFile({required this.id, required this.userId, this.expenseId, required this.status, final  List<String> aiTags = const [], required this.fileName, required this.timeCreated, required this.timeUpdated}): _aiTags = aiTags,super._();
  factory _SssFile.fromJson(Map<String, dynamic> json) => _$SssFileFromJson(json);

@override final  String id;
@override final  String userId;
@override final  int? expenseId;
@override final  AiProcessingStatus status;
 final  List<String> _aiTags;
@override@JsonKey() List<String> get aiTags {
  if (_aiTags is EqualUnmodifiableListView) return _aiTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aiTags);
}

@override final  String fileName;
@override final  int timeCreated;
@override final  int timeUpdated;

/// Create a copy of SssFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SssFileCopyWith<_SssFile> get copyWith => __$SssFileCopyWithImpl<_SssFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SssFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SssFile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._aiTags, _aiTags)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.timeCreated, timeCreated) || other.timeCreated == timeCreated)&&(identical(other.timeUpdated, timeUpdated) || other.timeUpdated == timeUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,expenseId,status,const DeepCollectionEquality().hash(_aiTags),fileName,timeCreated,timeUpdated);

@override
String toString() {
  return 'SssFile(id: $id, userId: $userId, expenseId: $expenseId, status: $status, aiTags: $aiTags, fileName: $fileName, timeCreated: $timeCreated, timeUpdated: $timeUpdated)';
}


}

/// @nodoc
abstract mixin class _$SssFileCopyWith<$Res> implements $SssFileCopyWith<$Res> {
  factory _$SssFileCopyWith(_SssFile value, $Res Function(_SssFile) _then) = __$SssFileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int? expenseId, AiProcessingStatus status, List<String> aiTags, String fileName, int timeCreated, int timeUpdated
});




}
/// @nodoc
class __$SssFileCopyWithImpl<$Res>
    implements _$SssFileCopyWith<$Res> {
  __$SssFileCopyWithImpl(this._self, this._then);

  final _SssFile _self;
  final $Res Function(_SssFile) _then;

/// Create a copy of SssFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? expenseId = freezed,Object? status = null,Object? aiTags = null,Object? fileName = null,Object? timeCreated = null,Object? timeUpdated = null,}) {
  return _then(_SssFile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiProcessingStatus,aiTags: null == aiTags ? _self._aiTags : aiTags // ignore: cast_nullable_to_non_nullable
as List<String>,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,timeCreated: null == timeCreated ? _self.timeCreated : timeCreated // ignore: cast_nullable_to_non_nullable
as int,timeUpdated: null == timeUpdated ? _self.timeUpdated : timeUpdated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
