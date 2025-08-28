// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'below_date_in_calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BelowDateInCalendarState {
  bool get loading;
  double? get amount;

  /// Create a copy of BelowDateInCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BelowDateInCalendarStateCopyWith<BelowDateInCalendarState> get copyWith =>
      _$BelowDateInCalendarStateCopyWithImpl<BelowDateInCalendarState>(
          this as BelowDateInCalendarState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BelowDateInCalendarState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, amount);

  @override
  String toString() {
    return 'BelowDateInCalendarState(loading: $loading, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $BelowDateInCalendarStateCopyWith<$Res> {
  factory $BelowDateInCalendarStateCopyWith(BelowDateInCalendarState value,
          $Res Function(BelowDateInCalendarState) _then) =
      _$BelowDateInCalendarStateCopyWithImpl;
  @useResult
  $Res call({bool loading, double? amount});
}

/// @nodoc
class _$BelowDateInCalendarStateCopyWithImpl<$Res>
    implements $BelowDateInCalendarStateCopyWith<$Res> {
  _$BelowDateInCalendarStateCopyWithImpl(this._self, this._then);

  final BelowDateInCalendarState _self;
  final $Res Function(BelowDateInCalendarState) _then;

  /// Create a copy of BelowDateInCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? amount = freezed,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BelowDateInCalendarState].
extension BelowDateInCalendarStatePatterns on BelowDateInCalendarState {
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
    TResult Function(_BelowDateInCalendarState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BelowDateInCalendarState() when $default != null:
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
    TResult Function(_BelowDateInCalendarState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BelowDateInCalendarState():
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
    TResult? Function(_BelowDateInCalendarState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BelowDateInCalendarState() when $default != null:
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
    TResult Function(bool loading, double? amount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BelowDateInCalendarState() when $default != null:
        return $default(_that.loading, _that.amount);
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
    TResult Function(bool loading, double? amount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BelowDateInCalendarState():
        return $default(_that.loading, _that.amount);
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
    TResult? Function(bool loading, double? amount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BelowDateInCalendarState() when $default != null:
        return $default(_that.loading, _that.amount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BelowDateInCalendarState implements BelowDateInCalendarState {
  const _BelowDateInCalendarState({this.loading = true, this.amount});

  @override
  @JsonKey()
  final bool loading;
  @override
  final double? amount;

  /// Create a copy of BelowDateInCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BelowDateInCalendarStateCopyWith<_BelowDateInCalendarState> get copyWith =>
      __$BelowDateInCalendarStateCopyWithImpl<_BelowDateInCalendarState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BelowDateInCalendarState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, amount);

  @override
  String toString() {
    return 'BelowDateInCalendarState(loading: $loading, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$BelowDateInCalendarStateCopyWith<$Res>
    implements $BelowDateInCalendarStateCopyWith<$Res> {
  factory _$BelowDateInCalendarStateCopyWith(_BelowDateInCalendarState value,
          $Res Function(_BelowDateInCalendarState) _then) =
      __$BelowDateInCalendarStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool loading, double? amount});
}

/// @nodoc
class __$BelowDateInCalendarStateCopyWithImpl<$Res>
    implements _$BelowDateInCalendarStateCopyWith<$Res> {
  __$BelowDateInCalendarStateCopyWithImpl(this._self, this._then);

  final _BelowDateInCalendarState _self;
  final $Res Function(_BelowDateInCalendarState) _then;

  /// Create a copy of BelowDateInCalendarState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? amount = freezed,
  }) {
    return _then(_BelowDateInCalendarState(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
