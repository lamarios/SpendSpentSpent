// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guess_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GuessCategoryState {

 bool get loading; CategoryGuessResult? get results; String? get selected; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of GuessCategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuessCategoryStateCopyWith<GuessCategoryState> get copyWith => _$GuessCategoryStateCopyWithImpl<GuessCategoryState>(this as GuessCategoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuessCategoryState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.results, results) || other.results == results)&&(identical(other.selected, selected) || other.selected == selected)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,loading,results,selected,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'GuessCategoryState(loading: $loading, results: $results, selected: $selected, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $GuessCategoryStateCopyWith<$Res>  {
  factory $GuessCategoryStateCopyWith(GuessCategoryState value, $Res Function(GuessCategoryState) _then) = _$GuessCategoryStateCopyWithImpl;
@useResult
$Res call({
 bool loading, CategoryGuessResult? results, String? selected, dynamic error, StackTrace? stackTrace
});


$CategoryGuessResultCopyWith<$Res>? get results;

}
/// @nodoc
class _$GuessCategoryStateCopyWithImpl<$Res>
    implements $GuessCategoryStateCopyWith<$Res> {
  _$GuessCategoryStateCopyWithImpl(this._self, this._then);

  final GuessCategoryState _self;
  final $Res Function(GuessCategoryState) _then;

/// Create a copy of GuessCategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? results = freezed,Object? selected = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as CategoryGuessResult?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}
/// Create a copy of GuessCategoryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryGuessResultCopyWith<$Res>? get results {
    if (_self.results == null) {
    return null;
  }

  return $CategoryGuessResultCopyWith<$Res>(_self.results!, (value) {
    return _then(_self.copyWith(results: value));
  });
}
}


/// Adds pattern-matching-related methods to [GuessCategoryState].
extension GuessCategoryStatePatterns on GuessCategoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuessCategoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuessCategoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuessCategoryState value)  $default,){
final _that = this;
switch (_that) {
case _GuessCategoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuessCategoryState value)?  $default,){
final _that = this;
switch (_that) {
case _GuessCategoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  CategoryGuessResult? results,  String? selected,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuessCategoryState() when $default != null:
return $default(_that.loading,_that.results,_that.selected,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  CategoryGuessResult? results,  String? selected,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _GuessCategoryState():
return $default(_that.loading,_that.results,_that.selected,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  CategoryGuessResult? results,  String? selected,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _GuessCategoryState() when $default != null:
return $default(_that.loading,_that.results,_that.selected,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _GuessCategoryState implements GuessCategoryState {
  const _GuessCategoryState({this.loading = true, this.results, this.selected, this.error, this.stackTrace});
  

@override@JsonKey() final  bool loading;
@override final  CategoryGuessResult? results;
@override final  String? selected;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of GuessCategoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuessCategoryStateCopyWith<_GuessCategoryState> get copyWith => __$GuessCategoryStateCopyWithImpl<_GuessCategoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuessCategoryState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.results, results) || other.results == results)&&(identical(other.selected, selected) || other.selected == selected)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,loading,results,selected,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'GuessCategoryState(loading: $loading, results: $results, selected: $selected, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$GuessCategoryStateCopyWith<$Res> implements $GuessCategoryStateCopyWith<$Res> {
  factory _$GuessCategoryStateCopyWith(_GuessCategoryState value, $Res Function(_GuessCategoryState) _then) = __$GuessCategoryStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, CategoryGuessResult? results, String? selected, dynamic error, StackTrace? stackTrace
});


@override $CategoryGuessResultCopyWith<$Res>? get results;

}
/// @nodoc
class __$GuessCategoryStateCopyWithImpl<$Res>
    implements _$GuessCategoryStateCopyWith<$Res> {
  __$GuessCategoryStateCopyWithImpl(this._self, this._then);

  final _GuessCategoryState _self;
  final $Res Function(_GuessCategoryState) _then;

/// Create a copy of GuessCategoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? results = freezed,Object? selected = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_GuessCategoryState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as CategoryGuessResult?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

/// Create a copy of GuessCategoryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryGuessResultCopyWith<$Res>? get results {
    if (_self.results == null) {
    return null;
  }

  return $CategoryGuessResultCopyWith<$Res>(_self.results!, (value) {
    return _then(_self.copyWith(results: value));
  });
}
}

// dart format on
