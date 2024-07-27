// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_limits.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseLimits _$ExpenseLimitsFromJson(Map<String, dynamic> json) {
  return _ExpenseLimits.fromJson(json);
}

/// @nodoc
mixin _$ExpenseLimits {
  int get years => throw _privateConstructorUsedError;
  int get months => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseLimitsCopyWith<ExpenseLimits> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseLimitsCopyWith<$Res> {
  factory $ExpenseLimitsCopyWith(
          ExpenseLimits value, $Res Function(ExpenseLimits) then) =
      _$ExpenseLimitsCopyWithImpl<$Res, ExpenseLimits>;
  @useResult
  $Res call({int years, int months});
}

/// @nodoc
class _$ExpenseLimitsCopyWithImpl<$Res, $Val extends ExpenseLimits>
    implements $ExpenseLimitsCopyWith<$Res> {
  _$ExpenseLimitsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? years = null,
    Object? months = null,
  }) {
    return _then(_value.copyWith(
      years: null == years
          ? _value.years
          : years // ignore: cast_nullable_to_non_nullable
              as int,
      months: null == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseLimitsImplCopyWith<$Res>
    implements $ExpenseLimitsCopyWith<$Res> {
  factory _$$ExpenseLimitsImplCopyWith(
          _$ExpenseLimitsImpl value, $Res Function(_$ExpenseLimitsImpl) then) =
      __$$ExpenseLimitsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int years, int months});
}

/// @nodoc
class __$$ExpenseLimitsImplCopyWithImpl<$Res>
    extends _$ExpenseLimitsCopyWithImpl<$Res, _$ExpenseLimitsImpl>
    implements _$$ExpenseLimitsImplCopyWith<$Res> {
  __$$ExpenseLimitsImplCopyWithImpl(
      _$ExpenseLimitsImpl _value, $Res Function(_$ExpenseLimitsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? years = null,
    Object? months = null,
  }) {
    return _then(_$ExpenseLimitsImpl(
      years: null == years
          ? _value.years
          : years // ignore: cast_nullable_to_non_nullable
              as int,
      months: null == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseLimitsImpl implements _ExpenseLimits {
  const _$ExpenseLimitsImpl({required this.years, required this.months});

  factory _$ExpenseLimitsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseLimitsImplFromJson(json);

  @override
  final int years;
  @override
  final int months;

  @override
  String toString() {
    return 'ExpenseLimits(years: $years, months: $months)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseLimitsImpl &&
            (identical(other.years, years) || other.years == years) &&
            (identical(other.months, months) || other.months == months));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, years, months);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseLimitsImplCopyWith<_$ExpenseLimitsImpl> get copyWith =>
      __$$ExpenseLimitsImplCopyWithImpl<_$ExpenseLimitsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseLimitsImplToJson(
      this,
    );
  }
}

abstract class _ExpenseLimits implements ExpenseLimits {
  const factory _ExpenseLimits(
      {required final int years,
      required final int months}) = _$ExpenseLimitsImpl;

  factory _ExpenseLimits.fromJson(Map<String, dynamic> json) =
      _$ExpenseLimitsImpl.fromJson;

  @override
  int get years;
  @override
  int get months;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseLimitsImplCopyWith<_$ExpenseLimitsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
