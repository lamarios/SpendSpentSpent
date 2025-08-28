// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_limits.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseLimits {
  int get years;
  int get months;

  /// Create a copy of ExpenseLimits
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseLimitsCopyWith<ExpenseLimits> get copyWith =>
      _$ExpenseLimitsCopyWithImpl<ExpenseLimits>(
          this as ExpenseLimits, _$identity);

  /// Serializes this ExpenseLimits to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseLimits &&
            (identical(other.years, years) || other.years == years) &&
            (identical(other.months, months) || other.months == months));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, years, months);

  @override
  String toString() {
    return 'ExpenseLimits(years: $years, months: $months)';
  }
}

/// @nodoc
abstract mixin class $ExpenseLimitsCopyWith<$Res> {
  factory $ExpenseLimitsCopyWith(
          ExpenseLimits value, $Res Function(ExpenseLimits) _then) =
      _$ExpenseLimitsCopyWithImpl;
  @useResult
  $Res call({int years, int months});
}

/// @nodoc
class _$ExpenseLimitsCopyWithImpl<$Res>
    implements $ExpenseLimitsCopyWith<$Res> {
  _$ExpenseLimitsCopyWithImpl(this._self, this._then);

  final ExpenseLimits _self;
  final $Res Function(ExpenseLimits) _then;

  /// Create a copy of ExpenseLimits
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? years = null,
    Object? months = null,
  }) {
    return _then(_self.copyWith(
      years: null == years
          ? _self.years
          : years // ignore: cast_nullable_to_non_nullable
              as int,
      months: null == months
          ? _self.months
          : months // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExpenseLimits].
extension ExpenseLimitsPatterns on ExpenseLimits {
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
    TResult Function(_ExpenseLimits value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseLimits() when $default != null:
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
    TResult Function(_ExpenseLimits value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseLimits():
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
    TResult? Function(_ExpenseLimits value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseLimits() when $default != null:
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
    TResult Function(int years, int months)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExpenseLimits() when $default != null:
        return $default(_that.years, _that.months);
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
    TResult Function(int years, int months) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseLimits():
        return $default(_that.years, _that.months);
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
    TResult? Function(int years, int months)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExpenseLimits() when $default != null:
        return $default(_that.years, _that.months);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExpenseLimits implements ExpenseLimits {
  const _ExpenseLimits({required this.years, required this.months});
  factory _ExpenseLimits.fromJson(Map<String, dynamic> json) =>
      _$ExpenseLimitsFromJson(json);

  @override
  final int years;
  @override
  final int months;

  /// Create a copy of ExpenseLimits
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseLimitsCopyWith<_ExpenseLimits> get copyWith =>
      __$ExpenseLimitsCopyWithImpl<_ExpenseLimits>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseLimitsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseLimits &&
            (identical(other.years, years) || other.years == years) &&
            (identical(other.months, months) || other.months == months));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, years, months);

  @override
  String toString() {
    return 'ExpenseLimits(years: $years, months: $months)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseLimitsCopyWith<$Res>
    implements $ExpenseLimitsCopyWith<$Res> {
  factory _$ExpenseLimitsCopyWith(
          _ExpenseLimits value, $Res Function(_ExpenseLimits) _then) =
      __$ExpenseLimitsCopyWithImpl;
  @override
  @useResult
  $Res call({int years, int months});
}

/// @nodoc
class __$ExpenseLimitsCopyWithImpl<$Res>
    implements _$ExpenseLimitsCopyWith<$Res> {
  __$ExpenseLimitsCopyWithImpl(this._self, this._then);

  final _ExpenseLimits _self;
  final $Res Function(_ExpenseLimits) _then;

  /// Create a copy of ExpenseLimits
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? years = null,
    Object? months = null,
  }) {
    return _then(_ExpenseLimits(
      years: null == years
          ? _self.years
          : years // ignore: cast_nullable_to_non_nullable
              as int,
      months: null == months
          ? _self.months
          : months // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
