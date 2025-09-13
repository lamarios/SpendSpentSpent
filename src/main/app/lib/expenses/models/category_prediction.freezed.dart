// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_prediction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryPrediction {

 double get probability; Category get category;
/// Create a copy of CategoryPrediction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryPredictionCopyWith<CategoryPrediction> get copyWith => _$CategoryPredictionCopyWithImpl<CategoryPrediction>(this as CategoryPrediction, _$identity);

  /// Serializes this CategoryPrediction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryPrediction&&(identical(other.probability, probability) || other.probability == probability)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,probability,category);

@override
String toString() {
  return 'CategoryPrediction(probability: $probability, category: $category)';
}


}

/// @nodoc
abstract mixin class $CategoryPredictionCopyWith<$Res>  {
  factory $CategoryPredictionCopyWith(CategoryPrediction value, $Res Function(CategoryPrediction) _then) = _$CategoryPredictionCopyWithImpl;
@useResult
$Res call({
 double probability, Category category
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class _$CategoryPredictionCopyWithImpl<$Res>
    implements $CategoryPredictionCopyWith<$Res> {
  _$CategoryPredictionCopyWithImpl(this._self, this._then);

  final CategoryPrediction _self;
  final $Res Function(CategoryPrediction) _then;

/// Create a copy of CategoryPrediction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? probability = null,Object? category = null,}) {
  return _then(_self.copyWith(
probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,
  ));
}
/// Create a copy of CategoryPrediction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryPrediction].
extension CategoryPredictionPatterns on CategoryPrediction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryPrediction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryPrediction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryPrediction value)  $default,){
final _that = this;
switch (_that) {
case _CategoryPrediction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryPrediction value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryPrediction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double probability,  Category category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryPrediction() when $default != null:
return $default(_that.probability,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double probability,  Category category)  $default,) {final _that = this;
switch (_that) {
case _CategoryPrediction():
return $default(_that.probability,_that.category);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double probability,  Category category)?  $default,) {final _that = this;
switch (_that) {
case _CategoryPrediction() when $default != null:
return $default(_that.probability,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryPrediction implements CategoryPrediction {
  const _CategoryPrediction({required this.probability, required this.category});
  factory _CategoryPrediction.fromJson(Map<String, dynamic> json) => _$CategoryPredictionFromJson(json);

@override final  double probability;
@override final  Category category;

/// Create a copy of CategoryPrediction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryPredictionCopyWith<_CategoryPrediction> get copyWith => __$CategoryPredictionCopyWithImpl<_CategoryPrediction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryPredictionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryPrediction&&(identical(other.probability, probability) || other.probability == probability)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,probability,category);

@override
String toString() {
  return 'CategoryPrediction(probability: $probability, category: $category)';
}


}

/// @nodoc
abstract mixin class _$CategoryPredictionCopyWith<$Res> implements $CategoryPredictionCopyWith<$Res> {
  factory _$CategoryPredictionCopyWith(_CategoryPrediction value, $Res Function(_CategoryPrediction) _then) = __$CategoryPredictionCopyWithImpl;
@override @useResult
$Res call({
 double probability, Category category
});


@override $CategoryCopyWith<$Res> get category;

}
/// @nodoc
class __$CategoryPredictionCopyWithImpl<$Res>
    implements _$CategoryPredictionCopyWith<$Res> {
  __$CategoryPredictionCopyWithImpl(this._self, this._then);

  final _CategoryPrediction _self;
  final $Res Function(_CategoryPrediction) _then;

/// Create a copy of CategoryPrediction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? probability = null,Object? category = null,}) {
  return _then(_CategoryPrediction(
probability: null == probability ? _self.probability : probability // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,
  ));
}

/// Create a copy of CategoryPrediction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
