// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategorySettingsState {

 List<Category> get categories; List<Category> get toDelete; int get expensesToDelete; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of CategorySettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySettingsStateCopyWith<CategorySettingsState> get copyWith => _$CategorySettingsStateCopyWithImpl<CategorySettingsState>(this as CategorySettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySettingsState&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.toDelete, toDelete)&&(identical(other.expensesToDelete, expensesToDelete) || other.expensesToDelete == expensesToDelete)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(toDelete),expensesToDelete,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'CategorySettingsState(categories: $categories, toDelete: $toDelete, expensesToDelete: $expensesToDelete, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $CategorySettingsStateCopyWith<$Res>  {
  factory $CategorySettingsStateCopyWith(CategorySettingsState value, $Res Function(CategorySettingsState) _then) = _$CategorySettingsStateCopyWithImpl;
@useResult
$Res call({
 List<Category> categories, List<Category> toDelete, int expensesToDelete, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$CategorySettingsStateCopyWithImpl<$Res>
    implements $CategorySettingsStateCopyWith<$Res> {
  _$CategorySettingsStateCopyWithImpl(this._self, this._then);

  final CategorySettingsState _self;
  final $Res Function(CategorySettingsState) _then;

/// Create a copy of CategorySettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? toDelete = null,Object? expensesToDelete = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,toDelete: null == toDelete ? _self.toDelete : toDelete // ignore: cast_nullable_to_non_nullable
as List<Category>,expensesToDelete: null == expensesToDelete ? _self.expensesToDelete : expensesToDelete // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySettingsState].
extension CategorySettingsStatePatterns on CategorySettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySettingsState value)  $default,){
final _that = this;
switch (_that) {
case _CategorySettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Category> categories,  List<Category> toDelete,  int expensesToDelete,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySettingsState() when $default != null:
return $default(_that.categories,_that.toDelete,_that.expensesToDelete,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Category> categories,  List<Category> toDelete,  int expensesToDelete,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _CategorySettingsState():
return $default(_that.categories,_that.toDelete,_that.expensesToDelete,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Category> categories,  List<Category> toDelete,  int expensesToDelete,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _CategorySettingsState() when $default != null:
return $default(_that.categories,_that.toDelete,_that.expensesToDelete,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _CategorySettingsState implements CategorySettingsState, WithError {
  const _CategorySettingsState({final  List<Category> categories = const [], final  List<Category> toDelete = const [], this.expensesToDelete = 0, this.error, this.stackTrace}): _categories = categories,_toDelete = toDelete;
  

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Category> _toDelete;
@override@JsonKey() List<Category> get toDelete {
  if (_toDelete is EqualUnmodifiableListView) return _toDelete;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toDelete);
}

@override@JsonKey() final  int expensesToDelete;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of CategorySettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySettingsStateCopyWith<_CategorySettingsState> get copyWith => __$CategorySettingsStateCopyWithImpl<_CategorySettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySettingsState&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._toDelete, _toDelete)&&(identical(other.expensesToDelete, expensesToDelete) || other.expensesToDelete == expensesToDelete)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_toDelete),expensesToDelete,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'CategorySettingsState(categories: $categories, toDelete: $toDelete, expensesToDelete: $expensesToDelete, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$CategorySettingsStateCopyWith<$Res> implements $CategorySettingsStateCopyWith<$Res> {
  factory _$CategorySettingsStateCopyWith(_CategorySettingsState value, $Res Function(_CategorySettingsState) _then) = __$CategorySettingsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Category> categories, List<Category> toDelete, int expensesToDelete, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$CategorySettingsStateCopyWithImpl<$Res>
    implements _$CategorySettingsStateCopyWith<$Res> {
  __$CategorySettingsStateCopyWithImpl(this._self, this._then);

  final _CategorySettingsState _self;
  final $Res Function(_CategorySettingsState) _then;

/// Create a copy of CategorySettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? toDelete = null,Object? expensesToDelete = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_CategorySettingsState(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,toDelete: null == toDelete ? _self._toDelete : toDelete // ignore: cast_nullable_to_non_nullable
as List<Category>,expensesToDelete: null == expensesToDelete ? _self.expensesToDelete : expensesToDelete // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
