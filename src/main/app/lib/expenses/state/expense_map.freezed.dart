// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseMapState {

 List<WeightedLatLng> get aggregatedData; bool get showHeatmap; bool get showAmounts;
/// Create a copy of ExpenseMapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseMapStateCopyWith<ExpenseMapState> get copyWith => _$ExpenseMapStateCopyWithImpl<ExpenseMapState>(this as ExpenseMapState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseMapState&&const DeepCollectionEquality().equals(other.aggregatedData, aggregatedData)&&(identical(other.showHeatmap, showHeatmap) || other.showHeatmap == showHeatmap)&&(identical(other.showAmounts, showAmounts) || other.showAmounts == showAmounts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(aggregatedData),showHeatmap,showAmounts);

@override
String toString() {
  return 'ExpenseMapState(aggregatedData: $aggregatedData, showHeatmap: $showHeatmap, showAmounts: $showAmounts)';
}


}

/// @nodoc
abstract mixin class $ExpenseMapStateCopyWith<$Res>  {
  factory $ExpenseMapStateCopyWith(ExpenseMapState value, $Res Function(ExpenseMapState) _then) = _$ExpenseMapStateCopyWithImpl;
@useResult
$Res call({
 List<WeightedLatLng> aggregatedData, bool showHeatmap, bool showAmounts
});




}
/// @nodoc
class _$ExpenseMapStateCopyWithImpl<$Res>
    implements $ExpenseMapStateCopyWith<$Res> {
  _$ExpenseMapStateCopyWithImpl(this._self, this._then);

  final ExpenseMapState _self;
  final $Res Function(ExpenseMapState) _then;

/// Create a copy of ExpenseMapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aggregatedData = null,Object? showHeatmap = null,Object? showAmounts = null,}) {
  return _then(_self.copyWith(
aggregatedData: null == aggregatedData ? _self.aggregatedData : aggregatedData // ignore: cast_nullable_to_non_nullable
as List<WeightedLatLng>,showHeatmap: null == showHeatmap ? _self.showHeatmap : showHeatmap // ignore: cast_nullable_to_non_nullable
as bool,showAmounts: null == showAmounts ? _self.showAmounts : showAmounts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseMapState].
extension ExpenseMapStatePatterns on ExpenseMapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseMapState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseMapState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseMapState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseMapState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseMapState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseMapState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WeightedLatLng> aggregatedData,  bool showHeatmap,  bool showAmounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseMapState() when $default != null:
return $default(_that.aggregatedData,_that.showHeatmap,_that.showAmounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WeightedLatLng> aggregatedData,  bool showHeatmap,  bool showAmounts)  $default,) {final _that = this;
switch (_that) {
case _ExpenseMapState():
return $default(_that.aggregatedData,_that.showHeatmap,_that.showAmounts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WeightedLatLng> aggregatedData,  bool showHeatmap,  bool showAmounts)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseMapState() when $default != null:
return $default(_that.aggregatedData,_that.showHeatmap,_that.showAmounts);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseMapState implements ExpenseMapState {
  const _ExpenseMapState({final  List<WeightedLatLng> aggregatedData = const [], this.showHeatmap = true, this.showAmounts = true}): _aggregatedData = aggregatedData;
  

 final  List<WeightedLatLng> _aggregatedData;
@override@JsonKey() List<WeightedLatLng> get aggregatedData {
  if (_aggregatedData is EqualUnmodifiableListView) return _aggregatedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aggregatedData);
}

@override@JsonKey() final  bool showHeatmap;
@override@JsonKey() final  bool showAmounts;

/// Create a copy of ExpenseMapState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseMapStateCopyWith<_ExpenseMapState> get copyWith => __$ExpenseMapStateCopyWithImpl<_ExpenseMapState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseMapState&&const DeepCollectionEquality().equals(other._aggregatedData, _aggregatedData)&&(identical(other.showHeatmap, showHeatmap) || other.showHeatmap == showHeatmap)&&(identical(other.showAmounts, showAmounts) || other.showAmounts == showAmounts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_aggregatedData),showHeatmap,showAmounts);

@override
String toString() {
  return 'ExpenseMapState(aggregatedData: $aggregatedData, showHeatmap: $showHeatmap, showAmounts: $showAmounts)';
}


}

/// @nodoc
abstract mixin class _$ExpenseMapStateCopyWith<$Res> implements $ExpenseMapStateCopyWith<$Res> {
  factory _$ExpenseMapStateCopyWith(_ExpenseMapState value, $Res Function(_ExpenseMapState) _then) = __$ExpenseMapStateCopyWithImpl;
@override @useResult
$Res call({
 List<WeightedLatLng> aggregatedData, bool showHeatmap, bool showAmounts
});




}
/// @nodoc
class __$ExpenseMapStateCopyWithImpl<$Res>
    implements _$ExpenseMapStateCopyWith<$Res> {
  __$ExpenseMapStateCopyWithImpl(this._self, this._then);

  final _ExpenseMapState _self;
  final $Res Function(_ExpenseMapState) _then;

/// Create a copy of ExpenseMapState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aggregatedData = null,Object? showHeatmap = null,Object? showAmounts = null,}) {
  return _then(_ExpenseMapState(
aggregatedData: null == aggregatedData ? _self._aggregatedData : aggregatedData // ignore: cast_nullable_to_non_nullable
as List<WeightedLatLng>,showHeatmap: null == showHeatmap ? _self.showHeatmap : showHeatmap // ignore: cast_nullable_to_non_nullable
as bool,showAmounts: null == showAmounts ? _self.showAmounts : showAmounts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
