// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_images.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseImagesState {

 List<SssFile> get files;
/// Create a copy of ExpenseImagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseImagesStateCopyWith<ExpenseImagesState> get copyWith => _$ExpenseImagesStateCopyWithImpl<ExpenseImagesState>(this as ExpenseImagesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseImagesState&&const DeepCollectionEquality().equals(other.files, files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'ExpenseImagesState(files: $files)';
}


}

/// @nodoc
abstract mixin class $ExpenseImagesStateCopyWith<$Res>  {
  factory $ExpenseImagesStateCopyWith(ExpenseImagesState value, $Res Function(ExpenseImagesState) _then) = _$ExpenseImagesStateCopyWithImpl;
@useResult
$Res call({
 List<SssFile> files
});




}
/// @nodoc
class _$ExpenseImagesStateCopyWithImpl<$Res>
    implements $ExpenseImagesStateCopyWith<$Res> {
  _$ExpenseImagesStateCopyWithImpl(this._self, this._then);

  final ExpenseImagesState _self;
  final $Res Function(ExpenseImagesState) _then;

/// Create a copy of ExpenseImagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<SssFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseImagesState].
extension ExpenseImagesStatePatterns on ExpenseImagesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseImagesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseImagesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseImagesState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseImagesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseImagesState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseImagesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SssFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseImagesState() when $default != null:
return $default(_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SssFile> files)  $default,) {final _that = this;
switch (_that) {
case _ExpenseImagesState():
return $default(_that.files);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SssFile> files)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseImagesState() when $default != null:
return $default(_that.files);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseImagesState extends ExpenseImagesState {
  const _ExpenseImagesState({final  List<SssFile> files = const []}): _files = files,super._();
  

 final  List<SssFile> _files;
@override@JsonKey() List<SssFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of ExpenseImagesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseImagesStateCopyWith<_ExpenseImagesState> get copyWith => __$ExpenseImagesStateCopyWithImpl<_ExpenseImagesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseImagesState&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'ExpenseImagesState(files: $files)';
}


}

/// @nodoc
abstract mixin class _$ExpenseImagesStateCopyWith<$Res> implements $ExpenseImagesStateCopyWith<$Res> {
  factory _$ExpenseImagesStateCopyWith(_ExpenseImagesState value, $Res Function(_ExpenseImagesState) _then) = __$ExpenseImagesStateCopyWithImpl;
@override @useResult
$Res call({
 List<SssFile> files
});




}
/// @nodoc
class __$ExpenseImagesStateCopyWithImpl<$Res>
    implements _$ExpenseImagesStateCopyWith<$Res> {
  __$ExpenseImagesStateCopyWithImpl(this._self, this._then);

  final _ExpenseImagesState _self;
  final $Res Function(_ExpenseImagesState) _then;

/// Create a copy of ExpenseImagesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(_ExpenseImagesState(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<SssFile>,
  ));
}


}

// dart format on
