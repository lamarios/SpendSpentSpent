// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_file_management.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseFileManagementState {

 bool get loading; List<SssFile> get files;
/// Create a copy of ExpenseFileManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseFileManagementStateCopyWith<ExpenseFileManagementState> get copyWith => _$ExpenseFileManagementStateCopyWithImpl<ExpenseFileManagementState>(this as ExpenseFileManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseFileManagementState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.files, files));
}


@override
int get hashCode => Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'ExpenseFileManagementState(loading: $loading, files: $files)';
}


}

/// @nodoc
abstract mixin class $ExpenseFileManagementStateCopyWith<$Res>  {
  factory $ExpenseFileManagementStateCopyWith(ExpenseFileManagementState value, $Res Function(ExpenseFileManagementState) _then) = _$ExpenseFileManagementStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<SssFile> files
});




}
/// @nodoc
class _$ExpenseFileManagementStateCopyWithImpl<$Res>
    implements $ExpenseFileManagementStateCopyWith<$Res> {
  _$ExpenseFileManagementStateCopyWithImpl(this._self, this._then);

  final ExpenseFileManagementState _self;
  final $Res Function(ExpenseFileManagementState) _then;

/// Create a copy of ExpenseFileManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? files = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<SssFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseFileManagementState].
extension ExpenseFileManagementStatePatterns on ExpenseFileManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseFileManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseFileManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseFileManagementState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseFileManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseFileManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseFileManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<SssFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseFileManagementState() when $default != null:
return $default(_that.loading,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<SssFile> files)  $default,) {final _that = this;
switch (_that) {
case _ExpenseFileManagementState():
return $default(_that.loading,_that.files);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<SssFile> files)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseFileManagementState() when $default != null:
return $default(_that.loading,_that.files);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseFileManagementState extends ExpenseFileManagementState {
  const _ExpenseFileManagementState({this.loading = false, final  List<SssFile> files = const []}): _files = files,super._();
  

@override@JsonKey() final  bool loading;
 final  List<SssFile> _files;
@override@JsonKey() List<SssFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of ExpenseFileManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseFileManagementStateCopyWith<_ExpenseFileManagementState> get copyWith => __$ExpenseFileManagementStateCopyWithImpl<_ExpenseFileManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseFileManagementState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'ExpenseFileManagementState(loading: $loading, files: $files)';
}


}

/// @nodoc
abstract mixin class _$ExpenseFileManagementStateCopyWith<$Res> implements $ExpenseFileManagementStateCopyWith<$Res> {
  factory _$ExpenseFileManagementStateCopyWith(_ExpenseFileManagementState value, $Res Function(_ExpenseFileManagementState) _then) = __$ExpenseFileManagementStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<SssFile> files
});




}
/// @nodoc
class __$ExpenseFileManagementStateCopyWithImpl<$Res>
    implements _$ExpenseFileManagementStateCopyWith<$Res> {
  __$ExpenseFileManagementStateCopyWithImpl(this._self, this._then);

  final _ExpenseFileManagementState _self;
  final $Res Function(_ExpenseFileManagementState) _then;

/// Create a copy of ExpenseFileManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? files = null,}) {
  return _then(_ExpenseFileManagementState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<SssFile>,
  ));
}


}

// dart format on
