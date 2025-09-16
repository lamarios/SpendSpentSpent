// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchParameters {

 List<Category> get categories; int get minAmount; int get maxAmount; String get searchQuery; int? get minDate; int? get maxDate;
/// Create a copy of SearchParameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchParametersCopyWith<SearchParameters> get copyWith => _$SearchParametersCopyWithImpl<SearchParameters>(this as SearchParameters, _$identity);

  /// Serializes this SearchParameters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchParameters&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.minAmount, minAmount) || other.minAmount == minAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),minAmount,maxAmount,searchQuery,minDate,maxDate);

@override
String toString() {
  return 'SearchParameters(categories: $categories, minAmount: $minAmount, maxAmount: $maxAmount, searchQuery: $searchQuery, minDate: $minDate, maxDate: $maxDate)';
}


}

/// @nodoc
abstract mixin class $SearchParametersCopyWith<$Res>  {
  factory $SearchParametersCopyWith(SearchParameters value, $Res Function(SearchParameters) _then) = _$SearchParametersCopyWithImpl;
@useResult
$Res call({
 List<Category> categories, int minAmount, int maxAmount, String searchQuery, int? minDate, int? maxDate
});




}
/// @nodoc
class _$SearchParametersCopyWithImpl<$Res>
    implements $SearchParametersCopyWith<$Res> {
  _$SearchParametersCopyWithImpl(this._self, this._then);

  final SearchParameters _self;
  final $Res Function(SearchParameters) _then;

/// Create a copy of SearchParameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? minAmount = null,Object? maxAmount = null,Object? searchQuery = null,Object? minDate = freezed,Object? maxDate = freezed,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,minAmount: null == minAmount ? _self.minAmount : minAmount // ignore: cast_nullable_to_non_nullable
as int,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as int,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as int?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchParameters].
extension SearchParametersPatterns on SearchParameters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchParameters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchParameters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchParameters value)  $default,){
final _that = this;
switch (_that) {
case _SearchParameters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchParameters value)?  $default,){
final _that = this;
switch (_that) {
case _SearchParameters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Category> categories,  int minAmount,  int maxAmount,  String searchQuery,  int? minDate,  int? maxDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchParameters() when $default != null:
return $default(_that.categories,_that.minAmount,_that.maxAmount,_that.searchQuery,_that.minDate,_that.maxDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Category> categories,  int minAmount,  int maxAmount,  String searchQuery,  int? minDate,  int? maxDate)  $default,) {final _that = this;
switch (_that) {
case _SearchParameters():
return $default(_that.categories,_that.minAmount,_that.maxAmount,_that.searchQuery,_that.minDate,_that.maxDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Category> categories,  int minAmount,  int maxAmount,  String searchQuery,  int? minDate,  int? maxDate)?  $default,) {final _that = this;
switch (_that) {
case _SearchParameters() when $default != null:
return $default(_that.categories,_that.minAmount,_that.maxAmount,_that.searchQuery,_that.minDate,_that.maxDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchParameters implements SearchParameters {
  const _SearchParameters({final  List<Category> categories = const [], required this.minAmount, required this.maxAmount, this.searchQuery = '', this.minDate, this.maxDate}): _categories = categories;
  factory _SearchParameters.fromJson(Map<String, dynamic> json) => _$SearchParametersFromJson(json);

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  int minAmount;
@override final  int maxAmount;
@override@JsonKey() final  String searchQuery;
@override final  int? minDate;
@override final  int? maxDate;

/// Create a copy of SearchParameters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchParametersCopyWith<_SearchParameters> get copyWith => __$SearchParametersCopyWithImpl<_SearchParameters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchParametersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchParameters&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.minAmount, minAmount) || other.minAmount == minAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),minAmount,maxAmount,searchQuery,minDate,maxDate);

@override
String toString() {
  return 'SearchParameters(categories: $categories, minAmount: $minAmount, maxAmount: $maxAmount, searchQuery: $searchQuery, minDate: $minDate, maxDate: $maxDate)';
}


}

/// @nodoc
abstract mixin class _$SearchParametersCopyWith<$Res> implements $SearchParametersCopyWith<$Res> {
  factory _$SearchParametersCopyWith(_SearchParameters value, $Res Function(_SearchParameters) _then) = __$SearchParametersCopyWithImpl;
@override @useResult
$Res call({
 List<Category> categories, int minAmount, int maxAmount, String searchQuery, int? minDate, int? maxDate
});




}
/// @nodoc
class __$SearchParametersCopyWithImpl<$Res>
    implements _$SearchParametersCopyWith<$Res> {
  __$SearchParametersCopyWithImpl(this._self, this._then);

  final _SearchParameters _self;
  final $Res Function(_SearchParameters) _then;

/// Create a copy of SearchParameters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? minAmount = null,Object? maxAmount = null,Object? searchQuery = null,Object? minDate = freezed,Object? maxDate = freezed,}) {
  return _then(_SearchParameters(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,minAmount: null == minAmount ? _self.minAmount : minAmount // ignore: cast_nullable_to_non_nullable
as int,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as int,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as int?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
