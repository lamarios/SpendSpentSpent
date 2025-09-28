// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_cluster.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseCluster {

 List<Expense> get expenses; double get total; LatLng get location;
/// Create a copy of ExpenseCluster
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseClusterCopyWith<ExpenseCluster> get copyWith => _$ExpenseClusterCopyWithImpl<ExpenseCluster>(this as ExpenseCluster, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCluster&&const DeepCollectionEquality().equals(other.expenses, expenses)&&(identical(other.total, total) || other.total == total)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(expenses),total,location);

@override
String toString() {
  return 'ExpenseCluster(expenses: $expenses, total: $total, location: $location)';
}


}

/// @nodoc
abstract mixin class $ExpenseClusterCopyWith<$Res>  {
  factory $ExpenseClusterCopyWith(ExpenseCluster value, $Res Function(ExpenseCluster) _then) = _$ExpenseClusterCopyWithImpl;
@useResult
$Res call({
 List<Expense> expenses, double total, LatLng location
});




}
/// @nodoc
class _$ExpenseClusterCopyWithImpl<$Res>
    implements $ExpenseClusterCopyWith<$Res> {
  _$ExpenseClusterCopyWithImpl(this._self, this._then);

  final ExpenseCluster _self;
  final $Res Function(ExpenseCluster) _then;

/// Create a copy of ExpenseCluster
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expenses = null,Object? total = null,Object? location = null,}) {
  return _then(_self.copyWith(
expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseCluster].
extension ExpenseClusterPatterns on ExpenseCluster {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseCluster value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseCluster() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseCluster value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseCluster():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseCluster value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseCluster() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Expense> expenses,  double total,  LatLng location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseCluster() when $default != null:
return $default(_that.expenses,_that.total,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Expense> expenses,  double total,  LatLng location)  $default,) {final _that = this;
switch (_that) {
case _ExpenseCluster():
return $default(_that.expenses,_that.total,_that.location);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Expense> expenses,  double total,  LatLng location)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseCluster() when $default != null:
return $default(_that.expenses,_that.total,_that.location);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseCluster implements ExpenseCluster {
  const _ExpenseCluster({final  List<Expense> expenses = const [], required this.total, required this.location}): _expenses = expenses;
  

 final  List<Expense> _expenses;
@override@JsonKey() List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}

@override final  double total;
@override final  LatLng location;

/// Create a copy of ExpenseCluster
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseClusterCopyWith<_ExpenseCluster> get copyWith => __$ExpenseClusterCopyWithImpl<_ExpenseCluster>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseCluster&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&(identical(other.total, total) || other.total == total)&&(identical(other.location, location) || other.location == location));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_expenses),total,location);

@override
String toString() {
  return 'ExpenseCluster(expenses: $expenses, total: $total, location: $location)';
}


}

/// @nodoc
abstract mixin class _$ExpenseClusterCopyWith<$Res> implements $ExpenseClusterCopyWith<$Res> {
  factory _$ExpenseClusterCopyWith(_ExpenseCluster value, $Res Function(_ExpenseCluster) _then) = __$ExpenseClusterCopyWithImpl;
@override @useResult
$Res call({
 List<Expense> expenses, double total, LatLng location
});




}
/// @nodoc
class __$ExpenseClusterCopyWithImpl<$Res>
    implements _$ExpenseClusterCopyWith<$Res> {
  __$ExpenseClusterCopyWithImpl(this._self, this._then);

  final _ExpenseCluster _self;
  final $Res Function(_ExpenseCluster) _then;

/// Create a copy of ExpenseCluster
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expenses = null,Object? total = null,Object? location = null,}) {
  return _then(_ExpenseCluster(
expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng,
  ));
}


}

// dart format on
