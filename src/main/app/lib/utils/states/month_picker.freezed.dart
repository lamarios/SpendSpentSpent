// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_picker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthPickerState {
  DateTime get selected;
  int get selectedYear;

  /// Create a copy of MonthPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthPickerStateCopyWith<MonthPickerState> get copyWith =>
      _$MonthPickerStateCopyWithImpl<MonthPickerState>(
          this as MonthPickerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthPickerState &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.selectedYear, selectedYear) ||
                other.selectedYear == selectedYear));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selected, selectedYear);

  @override
  String toString() {
    return 'MonthPickerState(selected: $selected, selectedYear: $selectedYear)';
  }
}

/// @nodoc
abstract mixin class $MonthPickerStateCopyWith<$Res> {
  factory $MonthPickerStateCopyWith(
          MonthPickerState value, $Res Function(MonthPickerState) _then) =
      _$MonthPickerStateCopyWithImpl;
  @useResult
  $Res call({DateTime selected, int selectedYear});
}

/// @nodoc
class _$MonthPickerStateCopyWithImpl<$Res>
    implements $MonthPickerStateCopyWith<$Res> {
  _$MonthPickerStateCopyWithImpl(this._self, this._then);

  final MonthPickerState _self;
  final $Res Function(MonthPickerState) _then;

  /// Create a copy of MonthPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selected = null,
    Object? selectedYear = null,
  }) {
    return _then(_self.copyWith(
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedYear: null == selectedYear
          ? _self.selectedYear
          : selectedYear // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MonthPickerState].
extension MonthPickerStatePatterns on MonthPickerState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MonthPickerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthPickerState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MonthPickerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthPickerState():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MonthPickerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthPickerState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DateTime selected, int selectedYear)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthPickerState() when $default != null:
        return $default(_that.selected, _that.selectedYear);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DateTime selected, int selectedYear) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthPickerState():
        return $default(_that.selected, _that.selectedYear);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DateTime selected, int selectedYear)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthPickerState() when $default != null:
        return $default(_that.selected, _that.selectedYear);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MonthPickerState implements MonthPickerState {
  const _MonthPickerState({required this.selected, required this.selectedYear});

  @override
  final DateTime selected;
  @override
  final int selectedYear;

  /// Create a copy of MonthPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthPickerStateCopyWith<_MonthPickerState> get copyWith =>
      __$MonthPickerStateCopyWithImpl<_MonthPickerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthPickerState &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.selectedYear, selectedYear) ||
                other.selectedYear == selectedYear));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selected, selectedYear);

  @override
  String toString() {
    return 'MonthPickerState(selected: $selected, selectedYear: $selectedYear)';
  }
}

/// @nodoc
abstract mixin class _$MonthPickerStateCopyWith<$Res>
    implements $MonthPickerStateCopyWith<$Res> {
  factory _$MonthPickerStateCopyWith(
          _MonthPickerState value, $Res Function(_MonthPickerState) _then) =
      __$MonthPickerStateCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime selected, int selectedYear});
}

/// @nodoc
class __$MonthPickerStateCopyWithImpl<$Res>
    implements _$MonthPickerStateCopyWith<$Res> {
  __$MonthPickerStateCopyWithImpl(this._self, this._then);

  final _MonthPickerState _self;
  final $Res Function(_MonthPickerState) _then;

  /// Create a copy of MonthPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selected = null,
    Object? selectedYear = null,
  }) {
    return _then(_MonthPickerState(
      selected: null == selected
          ? _self.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedYear: null == selectedYear
          ? _self.selectedYear
          : selectedYear // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
