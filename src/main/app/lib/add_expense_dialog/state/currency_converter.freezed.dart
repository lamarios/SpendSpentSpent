// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_converter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CurrencyConverterState {

 String get fromCurrency; String get toCurrency;
/// Create a copy of CurrencyConverterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrencyConverterStateCopyWith<CurrencyConverterState> get copyWith => _$CurrencyConverterStateCopyWithImpl<CurrencyConverterState>(this as CurrencyConverterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrencyConverterState&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency));
}


@override
int get hashCode => Object.hash(runtimeType,fromCurrency,toCurrency);

@override
String toString() {
  return 'CurrencyConverterState(fromCurrency: $fromCurrency, toCurrency: $toCurrency)';
}


}

/// @nodoc
abstract mixin class $CurrencyConverterStateCopyWith<$Res>  {
  factory $CurrencyConverterStateCopyWith(CurrencyConverterState value, $Res Function(CurrencyConverterState) _then) = _$CurrencyConverterStateCopyWithImpl;
@useResult
$Res call({
 String fromCurrency, String toCurrency
});




}
/// @nodoc
class _$CurrencyConverterStateCopyWithImpl<$Res>
    implements $CurrencyConverterStateCopyWith<$Res> {
  _$CurrencyConverterStateCopyWithImpl(this._self, this._then);

  final CurrencyConverterState _self;
  final $Res Function(CurrencyConverterState) _then;

/// Create a copy of CurrencyConverterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromCurrency = null,Object? toCurrency = null,}) {
  return _then(_self.copyWith(
fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrencyConverterState].
extension CurrencyConverterStatePatterns on CurrencyConverterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrencyConverterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrencyConverterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrencyConverterState value)  $default,){
final _that = this;
switch (_that) {
case _CurrencyConverterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrencyConverterState value)?  $default,){
final _that = this;
switch (_that) {
case _CurrencyConverterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fromCurrency,  String toCurrency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrencyConverterState() when $default != null:
return $default(_that.fromCurrency,_that.toCurrency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fromCurrency,  String toCurrency)  $default,) {final _that = this;
switch (_that) {
case _CurrencyConverterState():
return $default(_that.fromCurrency,_that.toCurrency);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fromCurrency,  String toCurrency)?  $default,) {final _that = this;
switch (_that) {
case _CurrencyConverterState() when $default != null:
return $default(_that.fromCurrency,_that.toCurrency);case _:
  return null;

}
}

}

/// @nodoc


class _CurrencyConverterState implements CurrencyConverterState {
  const _CurrencyConverterState({this.fromCurrency = "USD", this.toCurrency = "EUR"});
  

@override@JsonKey() final  String fromCurrency;
@override@JsonKey() final  String toCurrency;

/// Create a copy of CurrencyConverterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrencyConverterStateCopyWith<_CurrencyConverterState> get copyWith => __$CurrencyConverterStateCopyWithImpl<_CurrencyConverterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrencyConverterState&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency));
}


@override
int get hashCode => Object.hash(runtimeType,fromCurrency,toCurrency);

@override
String toString() {
  return 'CurrencyConverterState(fromCurrency: $fromCurrency, toCurrency: $toCurrency)';
}


}

/// @nodoc
abstract mixin class _$CurrencyConverterStateCopyWith<$Res> implements $CurrencyConverterStateCopyWith<$Res> {
  factory _$CurrencyConverterStateCopyWith(_CurrencyConverterState value, $Res Function(_CurrencyConverterState) _then) = __$CurrencyConverterStateCopyWithImpl;
@override @useResult
$Res call({
 String fromCurrency, String toCurrency
});




}
/// @nodoc
class __$CurrencyConverterStateCopyWithImpl<$Res>
    implements _$CurrencyConverterStateCopyWith<$Res> {
  __$CurrencyConverterStateCopyWithImpl(this._self, this._then);

  final _CurrencyConverterState _self;
  final $Res Function(_CurrencyConverterState) _then;

/// Create a copy of CurrencyConverterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromCurrency = null,Object? toCurrency = null,}) {
  return _then(_CurrencyConverterState(
fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
