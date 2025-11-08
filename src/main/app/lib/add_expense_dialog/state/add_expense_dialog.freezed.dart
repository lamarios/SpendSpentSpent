// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_expense_dialog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddExpenseDialogState {

 Category get category; String get value; String get valueFrom; DateTime get expenseDate; String get expenseNote; bool get gettingLocation; bool get useLocation; CurrencyConversion? get currencyConversion; bool get showCurrencyConversion; bool get saving; List<String> get noteSuggestions; List<SssFile> get files; LocationData? get location; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of AddExpenseDialogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddExpenseDialogStateCopyWith<AddExpenseDialogState> get copyWith => _$AddExpenseDialogStateCopyWithImpl<AddExpenseDialogState>(this as AddExpenseDialogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddExpenseDialogState&&(identical(other.category, category) || other.category == category)&&(identical(other.value, value) || other.value == value)&&(identical(other.valueFrom, valueFrom) || other.valueFrom == valueFrom)&&(identical(other.expenseDate, expenseDate) || other.expenseDate == expenseDate)&&(identical(other.expenseNote, expenseNote) || other.expenseNote == expenseNote)&&(identical(other.gettingLocation, gettingLocation) || other.gettingLocation == gettingLocation)&&(identical(other.useLocation, useLocation) || other.useLocation == useLocation)&&(identical(other.currencyConversion, currencyConversion) || other.currencyConversion == currencyConversion)&&(identical(other.showCurrencyConversion, showCurrencyConversion) || other.showCurrencyConversion == showCurrencyConversion)&&(identical(other.saving, saving) || other.saving == saving)&&const DeepCollectionEquality().equals(other.noteSuggestions, noteSuggestions)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,category,value,valueFrom,expenseDate,expenseNote,gettingLocation,useLocation,currencyConversion,showCurrencyConversion,saving,const DeepCollectionEquality().hash(noteSuggestions),const DeepCollectionEquality().hash(files),location,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AddExpenseDialogState(category: $category, value: $value, valueFrom: $valueFrom, expenseDate: $expenseDate, expenseNote: $expenseNote, gettingLocation: $gettingLocation, useLocation: $useLocation, currencyConversion: $currencyConversion, showCurrencyConversion: $showCurrencyConversion, saving: $saving, noteSuggestions: $noteSuggestions, files: $files, location: $location, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $AddExpenseDialogStateCopyWith<$Res>  {
  factory $AddExpenseDialogStateCopyWith(AddExpenseDialogState value, $Res Function(AddExpenseDialogState) _then) = _$AddExpenseDialogStateCopyWithImpl;
@useResult
$Res call({
 Category category, String value, String valueFrom, DateTime expenseDate, String expenseNote, bool gettingLocation, bool useLocation, CurrencyConversion? currencyConversion, bool showCurrencyConversion, bool saving, List<String> noteSuggestions, List<SssFile> files, LocationData? location, dynamic error, StackTrace? stackTrace
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class _$AddExpenseDialogStateCopyWithImpl<$Res>
    implements $AddExpenseDialogStateCopyWith<$Res> {
  _$AddExpenseDialogStateCopyWithImpl(this._self, this._then);

  final AddExpenseDialogState _self;
  final $Res Function(AddExpenseDialogState) _then;

/// Create a copy of AddExpenseDialogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? value = null,Object? valueFrom = null,Object? expenseDate = null,Object? expenseNote = null,Object? gettingLocation = null,Object? useLocation = null,Object? currencyConversion = freezed,Object? showCurrencyConversion = null,Object? saving = null,Object? noteSuggestions = null,Object? files = null,Object? location = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,valueFrom: null == valueFrom ? _self.valueFrom : valueFrom // ignore: cast_nullable_to_non_nullable
as String,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as DateTime,expenseNote: null == expenseNote ? _self.expenseNote : expenseNote // ignore: cast_nullable_to_non_nullable
as String,gettingLocation: null == gettingLocation ? _self.gettingLocation : gettingLocation // ignore: cast_nullable_to_non_nullable
as bool,useLocation: null == useLocation ? _self.useLocation : useLocation // ignore: cast_nullable_to_non_nullable
as bool,currencyConversion: freezed == currencyConversion ? _self.currencyConversion : currencyConversion // ignore: cast_nullable_to_non_nullable
as CurrencyConversion?,showCurrencyConversion: null == showCurrencyConversion ? _self.showCurrencyConversion : showCurrencyConversion // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,noteSuggestions: null == noteSuggestions ? _self.noteSuggestions : noteSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<SssFile>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}
/// Create a copy of AddExpenseDialogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddExpenseDialogState].
extension AddExpenseDialogStatePatterns on AddExpenseDialogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddExpenseDialogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddExpenseDialogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddExpenseDialogState value)  $default,){
final _that = this;
switch (_that) {
case _AddExpenseDialogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddExpenseDialogState value)?  $default,){
final _that = this;
switch (_that) {
case _AddExpenseDialogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Category category,  String value,  String valueFrom,  DateTime expenseDate,  String expenseNote,  bool gettingLocation,  bool useLocation,  CurrencyConversion? currencyConversion,  bool showCurrencyConversion,  bool saving,  List<String> noteSuggestions,  List<SssFile> files,  LocationData? location,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddExpenseDialogState() when $default != null:
return $default(_that.category,_that.value,_that.valueFrom,_that.expenseDate,_that.expenseNote,_that.gettingLocation,_that.useLocation,_that.currencyConversion,_that.showCurrencyConversion,_that.saving,_that.noteSuggestions,_that.files,_that.location,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Category category,  String value,  String valueFrom,  DateTime expenseDate,  String expenseNote,  bool gettingLocation,  bool useLocation,  CurrencyConversion? currencyConversion,  bool showCurrencyConversion,  bool saving,  List<String> noteSuggestions,  List<SssFile> files,  LocationData? location,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _AddExpenseDialogState():
return $default(_that.category,_that.value,_that.valueFrom,_that.expenseDate,_that.expenseNote,_that.gettingLocation,_that.useLocation,_that.currencyConversion,_that.showCurrencyConversion,_that.saving,_that.noteSuggestions,_that.files,_that.location,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Category category,  String value,  String valueFrom,  DateTime expenseDate,  String expenseNote,  bool gettingLocation,  bool useLocation,  CurrencyConversion? currencyConversion,  bool showCurrencyConversion,  bool saving,  List<String> noteSuggestions,  List<SssFile> files,  LocationData? location,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _AddExpenseDialogState() when $default != null:
return $default(_that.category,_that.value,_that.valueFrom,_that.expenseDate,_that.expenseNote,_that.gettingLocation,_that.useLocation,_that.currencyConversion,_that.showCurrencyConversion,_that.saving,_that.noteSuggestions,_that.files,_that.location,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _AddExpenseDialogState extends AddExpenseDialogState implements WithError {
  const _AddExpenseDialogState({required this.category, this.value = "", this.valueFrom = "", required this.expenseDate, this.expenseNote = '', this.gettingLocation = false, this.useLocation = false, this.currencyConversion, this.showCurrencyConversion = false, this.saving = false, final  List<String> noteSuggestions = const [], final  List<SssFile> files = const [], this.location, this.error, this.stackTrace}): _noteSuggestions = noteSuggestions,_files = files,super._();
  

@override final  Category category;
@override@JsonKey() final  String value;
@override@JsonKey() final  String valueFrom;
@override final  DateTime expenseDate;
@override@JsonKey() final  String expenseNote;
@override@JsonKey() final  bool gettingLocation;
@override@JsonKey() final  bool useLocation;
@override final  CurrencyConversion? currencyConversion;
@override@JsonKey() final  bool showCurrencyConversion;
@override@JsonKey() final  bool saving;
 final  List<String> _noteSuggestions;
@override@JsonKey() List<String> get noteSuggestions {
  if (_noteSuggestions is EqualUnmodifiableListView) return _noteSuggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteSuggestions);
}

 final  List<SssFile> _files;
@override@JsonKey() List<SssFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  LocationData? location;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of AddExpenseDialogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddExpenseDialogStateCopyWith<_AddExpenseDialogState> get copyWith => __$AddExpenseDialogStateCopyWithImpl<_AddExpenseDialogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddExpenseDialogState&&(identical(other.category, category) || other.category == category)&&(identical(other.value, value) || other.value == value)&&(identical(other.valueFrom, valueFrom) || other.valueFrom == valueFrom)&&(identical(other.expenseDate, expenseDate) || other.expenseDate == expenseDate)&&(identical(other.expenseNote, expenseNote) || other.expenseNote == expenseNote)&&(identical(other.gettingLocation, gettingLocation) || other.gettingLocation == gettingLocation)&&(identical(other.useLocation, useLocation) || other.useLocation == useLocation)&&(identical(other.currencyConversion, currencyConversion) || other.currencyConversion == currencyConversion)&&(identical(other.showCurrencyConversion, showCurrencyConversion) || other.showCurrencyConversion == showCurrencyConversion)&&(identical(other.saving, saving) || other.saving == saving)&&const DeepCollectionEquality().equals(other._noteSuggestions, _noteSuggestions)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,category,value,valueFrom,expenseDate,expenseNote,gettingLocation,useLocation,currencyConversion,showCurrencyConversion,saving,const DeepCollectionEquality().hash(_noteSuggestions),const DeepCollectionEquality().hash(_files),location,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AddExpenseDialogState(category: $category, value: $value, valueFrom: $valueFrom, expenseDate: $expenseDate, expenseNote: $expenseNote, gettingLocation: $gettingLocation, useLocation: $useLocation, currencyConversion: $currencyConversion, showCurrencyConversion: $showCurrencyConversion, saving: $saving, noteSuggestions: $noteSuggestions, files: $files, location: $location, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$AddExpenseDialogStateCopyWith<$Res> implements $AddExpenseDialogStateCopyWith<$Res> {
  factory _$AddExpenseDialogStateCopyWith(_AddExpenseDialogState value, $Res Function(_AddExpenseDialogState) _then) = __$AddExpenseDialogStateCopyWithImpl;
@override @useResult
$Res call({
 Category category, String value, String valueFrom, DateTime expenseDate, String expenseNote, bool gettingLocation, bool useLocation, CurrencyConversion? currencyConversion, bool showCurrencyConversion, bool saving, List<String> noteSuggestions, List<SssFile> files, LocationData? location, dynamic error, StackTrace? stackTrace
});


@override $CategoryCopyWith<$Res> get category;

}
/// @nodoc
class __$AddExpenseDialogStateCopyWithImpl<$Res>
    implements _$AddExpenseDialogStateCopyWith<$Res> {
  __$AddExpenseDialogStateCopyWithImpl(this._self, this._then);

  final _AddExpenseDialogState _self;
  final $Res Function(_AddExpenseDialogState) _then;

/// Create a copy of AddExpenseDialogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? value = null,Object? valueFrom = null,Object? expenseDate = null,Object? expenseNote = null,Object? gettingLocation = null,Object? useLocation = null,Object? currencyConversion = freezed,Object? showCurrencyConversion = null,Object? saving = null,Object? noteSuggestions = null,Object? files = null,Object? location = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_AddExpenseDialogState(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,valueFrom: null == valueFrom ? _self.valueFrom : valueFrom // ignore: cast_nullable_to_non_nullable
as String,expenseDate: null == expenseDate ? _self.expenseDate : expenseDate // ignore: cast_nullable_to_non_nullable
as DateTime,expenseNote: null == expenseNote ? _self.expenseNote : expenseNote // ignore: cast_nullable_to_non_nullable
as String,gettingLocation: null == gettingLocation ? _self.gettingLocation : gettingLocation // ignore: cast_nullable_to_non_nullable
as bool,useLocation: null == useLocation ? _self.useLocation : useLocation // ignore: cast_nullable_to_non_nullable
as bool,currencyConversion: freezed == currencyConversion ? _self.currencyConversion : currencyConversion // ignore: cast_nullable_to_non_nullable
as CurrencyConversion?,showCurrencyConversion: null == showCurrencyConversion ? _self.showCurrencyConversion : showCurrencyConversion // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,noteSuggestions: null == noteSuggestions ? _self._noteSuggestions : noteSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<SssFile>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

/// Create a copy of AddExpenseDialogState
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
