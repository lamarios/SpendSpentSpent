// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_guess_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryGuessResult {

 List<String> get categories; SssFile get file;
/// Create a copy of CategoryGuessResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryGuessResultCopyWith<CategoryGuessResult> get copyWith => _$CategoryGuessResultCopyWithImpl<CategoryGuessResult>(this as CategoryGuessResult, _$identity);

  /// Serializes this CategoryGuessResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryGuessResult&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.file, file) || other.file == file));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),file);

@override
String toString() {
  return 'CategoryGuessResult(categories: $categories, file: $file)';
}


}

/// @nodoc
abstract mixin class $CategoryGuessResultCopyWith<$Res>  {
  factory $CategoryGuessResultCopyWith(CategoryGuessResult value, $Res Function(CategoryGuessResult) _then) = _$CategoryGuessResultCopyWithImpl;
@useResult
$Res call({
 List<String> categories, SssFile file
});


$SssFileCopyWith<$Res> get file;

}
/// @nodoc
class _$CategoryGuessResultCopyWithImpl<$Res>
    implements $CategoryGuessResultCopyWith<$Res> {
  _$CategoryGuessResultCopyWithImpl(this._self, this._then);

  final CategoryGuessResult _self;
  final $Res Function(CategoryGuessResult) _then;

/// Create a copy of CategoryGuessResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? file = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as SssFile,
  ));
}
/// Create a copy of CategoryGuessResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SssFileCopyWith<$Res> get file {
  
  return $SssFileCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryGuessResult].
extension CategoryGuessResultPatterns on CategoryGuessResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryGuessResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryGuessResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryGuessResult value)  $default,){
final _that = this;
switch (_that) {
case _CategoryGuessResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryGuessResult value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryGuessResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> categories,  SssFile file)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryGuessResult() when $default != null:
return $default(_that.categories,_that.file);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> categories,  SssFile file)  $default,) {final _that = this;
switch (_that) {
case _CategoryGuessResult():
return $default(_that.categories,_that.file);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> categories,  SssFile file)?  $default,) {final _that = this;
switch (_that) {
case _CategoryGuessResult() when $default != null:
return $default(_that.categories,_that.file);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryGuessResult implements CategoryGuessResult {
  const _CategoryGuessResult({final  List<String> categories = const [], required this.file}): _categories = categories;
  factory _CategoryGuessResult.fromJson(Map<String, dynamic> json) => _$CategoryGuessResultFromJson(json);

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  SssFile file;

/// Create a copy of CategoryGuessResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryGuessResultCopyWith<_CategoryGuessResult> get copyWith => __$CategoryGuessResultCopyWithImpl<_CategoryGuessResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryGuessResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryGuessResult&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.file, file) || other.file == file));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),file);

@override
String toString() {
  return 'CategoryGuessResult(categories: $categories, file: $file)';
}


}

/// @nodoc
abstract mixin class _$CategoryGuessResultCopyWith<$Res> implements $CategoryGuessResultCopyWith<$Res> {
  factory _$CategoryGuessResultCopyWith(_CategoryGuessResult value, $Res Function(_CategoryGuessResult) _then) = __$CategoryGuessResultCopyWithImpl;
@override @useResult
$Res call({
 List<String> categories, SssFile file
});


@override $SssFileCopyWith<$Res> get file;

}
/// @nodoc
class __$CategoryGuessResultCopyWithImpl<$Res>
    implements _$CategoryGuessResultCopyWith<$Res> {
  __$CategoryGuessResultCopyWithImpl(this._self, this._then);

  final _CategoryGuessResult _self;
  final $Res Function(_CategoryGuessResult) _then;

/// Create a copy of CategoryGuessResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? file = null,}) {
  return _then(_CategoryGuessResult(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as SssFile,
  ));
}

/// Create a copy of CategoryGuessResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SssFileCopyWith<$Res> get file {
  
  return $SssFileCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}

// dart format on
