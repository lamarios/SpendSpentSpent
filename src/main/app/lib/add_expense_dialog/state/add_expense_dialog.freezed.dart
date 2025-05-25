// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
  String get value;
  String get valueFrom;
  DateTime get expenseDate;
  String get expenseNote;
  bool get gettingLocation;
  bool get useLocation;
  CurrencyConversion? get currencyConversion;
  bool get showCurrencyConversion;
  bool get saving;
  Widget? get savingIcon;
  List<String> get noteSuggestions;
  LocationData? get location;
  dynamic get error;
  StackTrace? get stackTrace;

  /// Create a copy of AddExpenseDialogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddExpenseDialogStateCopyWith<AddExpenseDialogState> get copyWith =>
      _$AddExpenseDialogStateCopyWithImpl<AddExpenseDialogState>(
          this as AddExpenseDialogState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddExpenseDialogState &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.valueFrom, valueFrom) ||
                other.valueFrom == valueFrom) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.expenseNote, expenseNote) ||
                other.expenseNote == expenseNote) &&
            (identical(other.gettingLocation, gettingLocation) ||
                other.gettingLocation == gettingLocation) &&
            (identical(other.useLocation, useLocation) ||
                other.useLocation == useLocation) &&
            (identical(other.currencyConversion, currencyConversion) ||
                other.currencyConversion == currencyConversion) &&
            (identical(other.showCurrencyConversion, showCurrencyConversion) ||
                other.showCurrencyConversion == showCurrencyConversion) &&
            (identical(other.saving, saving) || other.saving == saving) &&
            (identical(other.savingIcon, savingIcon) ||
                other.savingIcon == savingIcon) &&
            const DeepCollectionEquality()
                .equals(other.noteSuggestions, noteSuggestions) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      value,
      valueFrom,
      expenseDate,
      expenseNote,
      gettingLocation,
      useLocation,
      currencyConversion,
      showCurrencyConversion,
      saving,
      savingIcon,
      const DeepCollectionEquality().hash(noteSuggestions),
      location,
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'AddExpenseDialogState(value: $value, valueFrom: $valueFrom, expenseDate: $expenseDate, expenseNote: $expenseNote, gettingLocation: $gettingLocation, useLocation: $useLocation, currencyConversion: $currencyConversion, showCurrencyConversion: $showCurrencyConversion, saving: $saving, savingIcon: $savingIcon, noteSuggestions: $noteSuggestions, location: $location, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $AddExpenseDialogStateCopyWith<$Res> {
  factory $AddExpenseDialogStateCopyWith(AddExpenseDialogState value,
          $Res Function(AddExpenseDialogState) _then) =
      _$AddExpenseDialogStateCopyWithImpl;
  @useResult
  $Res call(
      {String value,
      String valueFrom,
      DateTime expenseDate,
      String expenseNote,
      bool gettingLocation,
      bool useLocation,
      CurrencyConversion? currencyConversion,
      bool showCurrencyConversion,
      bool saving,
      Widget? savingIcon,
      List<String> noteSuggestions,
      LocationData? location,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class _$AddExpenseDialogStateCopyWithImpl<$Res>
    implements $AddExpenseDialogStateCopyWith<$Res> {
  _$AddExpenseDialogStateCopyWithImpl(this._self, this._then);

  final AddExpenseDialogState _self;
  final $Res Function(AddExpenseDialogState) _then;

  /// Create a copy of AddExpenseDialogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? valueFrom = null,
    Object? expenseDate = null,
    Object? expenseNote = null,
    Object? gettingLocation = null,
    Object? useLocation = null,
    Object? currencyConversion = freezed,
    Object? showCurrencyConversion = null,
    Object? saving = null,
    Object? savingIcon = freezed,
    Object? noteSuggestions = null,
    Object? location = freezed,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_self.copyWith(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      valueFrom: null == valueFrom
          ? _self.valueFrom
          : valueFrom // ignore: cast_nullable_to_non_nullable
              as String,
      expenseDate: null == expenseDate
          ? _self.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expenseNote: null == expenseNote
          ? _self.expenseNote
          : expenseNote // ignore: cast_nullable_to_non_nullable
              as String,
      gettingLocation: null == gettingLocation
          ? _self.gettingLocation
          : gettingLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      useLocation: null == useLocation
          ? _self.useLocation
          : useLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyConversion: freezed == currencyConversion
          ? _self.currencyConversion
          : currencyConversion // ignore: cast_nullable_to_non_nullable
              as CurrencyConversion?,
      showCurrencyConversion: null == showCurrencyConversion
          ? _self.showCurrencyConversion
          : showCurrencyConversion // ignore: cast_nullable_to_non_nullable
              as bool,
      saving: null == saving
          ? _self.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as bool,
      savingIcon: freezed == savingIcon
          ? _self.savingIcon
          : savingIcon // ignore: cast_nullable_to_non_nullable
              as Widget?,
      noteSuggestions: null == noteSuggestions
          ? _self.noteSuggestions
          : noteSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationData?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _AddExpenseDialogState implements AddExpenseDialogState, WithError {
  const _AddExpenseDialogState(
      {this.value = "",
      this.valueFrom = "",
      required this.expenseDate,
      this.expenseNote = '',
      this.gettingLocation = false,
      this.useLocation = false,
      this.currencyConversion,
      this.showCurrencyConversion = false,
      this.saving = false,
      this.savingIcon,
      final List<String> noteSuggestions = const [],
      this.location,
      this.error,
      this.stackTrace})
      : _noteSuggestions = noteSuggestions;

  @override
  @JsonKey()
  final String value;
  @override
  @JsonKey()
  final String valueFrom;
  @override
  final DateTime expenseDate;
  @override
  @JsonKey()
  final String expenseNote;
  @override
  @JsonKey()
  final bool gettingLocation;
  @override
  @JsonKey()
  final bool useLocation;
  @override
  final CurrencyConversion? currencyConversion;
  @override
  @JsonKey()
  final bool showCurrencyConversion;
  @override
  @JsonKey()
  final bool saving;
  @override
  final Widget? savingIcon;
  final List<String> _noteSuggestions;
  @override
  @JsonKey()
  List<String> get noteSuggestions {
    if (_noteSuggestions is EqualUnmodifiableListView) return _noteSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_noteSuggestions);
  }

  @override
  final LocationData? location;
  @override
  final dynamic error;
  @override
  final StackTrace? stackTrace;

  /// Create a copy of AddExpenseDialogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddExpenseDialogStateCopyWith<_AddExpenseDialogState> get copyWith =>
      __$AddExpenseDialogStateCopyWithImpl<_AddExpenseDialogState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddExpenseDialogState &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.valueFrom, valueFrom) ||
                other.valueFrom == valueFrom) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.expenseNote, expenseNote) ||
                other.expenseNote == expenseNote) &&
            (identical(other.gettingLocation, gettingLocation) ||
                other.gettingLocation == gettingLocation) &&
            (identical(other.useLocation, useLocation) ||
                other.useLocation == useLocation) &&
            (identical(other.currencyConversion, currencyConversion) ||
                other.currencyConversion == currencyConversion) &&
            (identical(other.showCurrencyConversion, showCurrencyConversion) ||
                other.showCurrencyConversion == showCurrencyConversion) &&
            (identical(other.saving, saving) || other.saving == saving) &&
            (identical(other.savingIcon, savingIcon) ||
                other.savingIcon == savingIcon) &&
            const DeepCollectionEquality()
                .equals(other._noteSuggestions, _noteSuggestions) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      value,
      valueFrom,
      expenseDate,
      expenseNote,
      gettingLocation,
      useLocation,
      currencyConversion,
      showCurrencyConversion,
      saving,
      savingIcon,
      const DeepCollectionEquality().hash(_noteSuggestions),
      location,
      const DeepCollectionEquality().hash(error),
      stackTrace);

  @override
  String toString() {
    return 'AddExpenseDialogState(value: $value, valueFrom: $valueFrom, expenseDate: $expenseDate, expenseNote: $expenseNote, gettingLocation: $gettingLocation, useLocation: $useLocation, currencyConversion: $currencyConversion, showCurrencyConversion: $showCurrencyConversion, saving: $saving, savingIcon: $savingIcon, noteSuggestions: $noteSuggestions, location: $location, error: $error, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class _$AddExpenseDialogStateCopyWith<$Res>
    implements $AddExpenseDialogStateCopyWith<$Res> {
  factory _$AddExpenseDialogStateCopyWith(_AddExpenseDialogState value,
          $Res Function(_AddExpenseDialogState) _then) =
      __$AddExpenseDialogStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String value,
      String valueFrom,
      DateTime expenseDate,
      String expenseNote,
      bool gettingLocation,
      bool useLocation,
      CurrencyConversion? currencyConversion,
      bool showCurrencyConversion,
      bool saving,
      Widget? savingIcon,
      List<String> noteSuggestions,
      LocationData? location,
      dynamic error,
      StackTrace? stackTrace});
}

/// @nodoc
class __$AddExpenseDialogStateCopyWithImpl<$Res>
    implements _$AddExpenseDialogStateCopyWith<$Res> {
  __$AddExpenseDialogStateCopyWithImpl(this._self, this._then);

  final _AddExpenseDialogState _self;
  final $Res Function(_AddExpenseDialogState) _then;

  /// Create a copy of AddExpenseDialogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
    Object? valueFrom = null,
    Object? expenseDate = null,
    Object? expenseNote = null,
    Object? gettingLocation = null,
    Object? useLocation = null,
    Object? currencyConversion = freezed,
    Object? showCurrencyConversion = null,
    Object? saving = null,
    Object? savingIcon = freezed,
    Object? noteSuggestions = null,
    Object? location = freezed,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_AddExpenseDialogState(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      valueFrom: null == valueFrom
          ? _self.valueFrom
          : valueFrom // ignore: cast_nullable_to_non_nullable
              as String,
      expenseDate: null == expenseDate
          ? _self.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expenseNote: null == expenseNote
          ? _self.expenseNote
          : expenseNote // ignore: cast_nullable_to_non_nullable
              as String,
      gettingLocation: null == gettingLocation
          ? _self.gettingLocation
          : gettingLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      useLocation: null == useLocation
          ? _self.useLocation
          : useLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyConversion: freezed == currencyConversion
          ? _self.currencyConversion
          : currencyConversion // ignore: cast_nullable_to_non_nullable
              as CurrencyConversion?,
      showCurrencyConversion: null == showCurrencyConversion
          ? _self.showCurrencyConversion
          : showCurrencyConversion // ignore: cast_nullable_to_non_nullable
              as bool,
      saving: null == saving
          ? _self.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as bool,
      savingIcon: freezed == savingIcon
          ? _self.savingIcon
          : savingIcon // ignore: cast_nullable_to_non_nullable
              as Widget?,
      noteSuggestions: null == noteSuggestions
          ? _self._noteSuggestions
          : noteSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationData?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
