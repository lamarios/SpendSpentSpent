// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_note_dialog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseNoteDialogState {

 bool get loading; String get note; List<String> get suggestions;
/// Create a copy of ExpenseNoteDialogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseNoteDialogStateCopyWith<ExpenseNoteDialogState> get copyWith => _$ExpenseNoteDialogStateCopyWithImpl<ExpenseNoteDialogState>(this as ExpenseNoteDialogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseNoteDialogState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.suggestions, suggestions));
}


@override
int get hashCode => Object.hash(runtimeType,loading,note,const DeepCollectionEquality().hash(suggestions));

@override
String toString() {
  return 'ExpenseNoteDialogState(loading: $loading, note: $note, suggestions: $suggestions)';
}


}

/// @nodoc
abstract mixin class $ExpenseNoteDialogStateCopyWith<$Res>  {
  factory $ExpenseNoteDialogStateCopyWith(ExpenseNoteDialogState value, $Res Function(ExpenseNoteDialogState) _then) = _$ExpenseNoteDialogStateCopyWithImpl;
@useResult
$Res call({
 bool loading, String note, List<String> suggestions
});




}
/// @nodoc
class _$ExpenseNoteDialogStateCopyWithImpl<$Res>
    implements $ExpenseNoteDialogStateCopyWith<$Res> {
  _$ExpenseNoteDialogStateCopyWithImpl(this._self, this._then);

  final ExpenseNoteDialogState _self;
  final $Res Function(ExpenseNoteDialogState) _then;

/// Create a copy of ExpenseNoteDialogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? note = null,Object? suggestions = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseNoteDialogState].
extension ExpenseNoteDialogStatePatterns on ExpenseNoteDialogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseNoteDialogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseNoteDialogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseNoteDialogState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseNoteDialogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseNoteDialogState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseNoteDialogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  String note,  List<String> suggestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseNoteDialogState() when $default != null:
return $default(_that.loading,_that.note,_that.suggestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  String note,  List<String> suggestions)  $default,) {final _that = this;
switch (_that) {
case _ExpenseNoteDialogState():
return $default(_that.loading,_that.note,_that.suggestions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  String note,  List<String> suggestions)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseNoteDialogState() when $default != null:
return $default(_that.loading,_that.note,_that.suggestions);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseNoteDialogState implements ExpenseNoteDialogState {
  const _ExpenseNoteDialogState({this.loading = false, this.note = '', final  List<String> suggestions = const []}): _suggestions = suggestions;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  String note;
 final  List<String> _suggestions;
@override@JsonKey() List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}


/// Create a copy of ExpenseNoteDialogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseNoteDialogStateCopyWith<_ExpenseNoteDialogState> get copyWith => __$ExpenseNoteDialogStateCopyWithImpl<_ExpenseNoteDialogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseNoteDialogState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions));
}


@override
int get hashCode => Object.hash(runtimeType,loading,note,const DeepCollectionEquality().hash(_suggestions));

@override
String toString() {
  return 'ExpenseNoteDialogState(loading: $loading, note: $note, suggestions: $suggestions)';
}


}

/// @nodoc
abstract mixin class _$ExpenseNoteDialogStateCopyWith<$Res> implements $ExpenseNoteDialogStateCopyWith<$Res> {
  factory _$ExpenseNoteDialogStateCopyWith(_ExpenseNoteDialogState value, $Res Function(_ExpenseNoteDialogState) _then) = __$ExpenseNoteDialogStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, String note, List<String> suggestions
});




}
/// @nodoc
class __$ExpenseNoteDialogStateCopyWithImpl<$Res>
    implements _$ExpenseNoteDialogStateCopyWith<$Res> {
  __$ExpenseNoteDialogStateCopyWithImpl(this._self, this._then);

  final _ExpenseNoteDialogState _self;
  final $Res Function(_ExpenseNoteDialogState) _then;

/// Create a copy of ExpenseNoteDialogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? note = null,Object? suggestions = null,}) {
  return _then(_ExpenseNoteDialogState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
