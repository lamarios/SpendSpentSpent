// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_converter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrencyConverterState {
  String get fromCurrency => throw _privateConstructorUsedError;
  String get toCurrency => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CurrencyConverterStateCopyWith<CurrencyConverterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyConverterStateCopyWith<$Res> {
  factory $CurrencyConverterStateCopyWith(CurrencyConverterState value,
          $Res Function(CurrencyConverterState) then) =
      _$CurrencyConverterStateCopyWithImpl<$Res, CurrencyConverterState>;
  @useResult
  $Res call({String fromCurrency, String toCurrency});
}

/// @nodoc
class _$CurrencyConverterStateCopyWithImpl<$Res,
        $Val extends CurrencyConverterState>
    implements $CurrencyConverterStateCopyWith<$Res> {
  _$CurrencyConverterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromCurrency = null,
    Object? toCurrency = null,
  }) {
    return _then(_value.copyWith(
      fromCurrency: null == fromCurrency
          ? _value.fromCurrency
          : fromCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      toCurrency: null == toCurrency
          ? _value.toCurrency
          : toCurrency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyConverterStateImplCopyWith<$Res>
    implements $CurrencyConverterStateCopyWith<$Res> {
  factory _$$CurrencyConverterStateImplCopyWith(
          _$CurrencyConverterStateImpl value,
          $Res Function(_$CurrencyConverterStateImpl) then) =
      __$$CurrencyConverterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fromCurrency, String toCurrency});
}

/// @nodoc
class __$$CurrencyConverterStateImplCopyWithImpl<$Res>
    extends _$CurrencyConverterStateCopyWithImpl<$Res,
        _$CurrencyConverterStateImpl>
    implements _$$CurrencyConverterStateImplCopyWith<$Res> {
  __$$CurrencyConverterStateImplCopyWithImpl(
      _$CurrencyConverterStateImpl _value,
      $Res Function(_$CurrencyConverterStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromCurrency = null,
    Object? toCurrency = null,
  }) {
    return _then(_$CurrencyConverterStateImpl(
      fromCurrency: null == fromCurrency
          ? _value.fromCurrency
          : fromCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      toCurrency: null == toCurrency
          ? _value.toCurrency
          : toCurrency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CurrencyConverterStateImpl implements _CurrencyConverterState {
  const _$CurrencyConverterStateImpl(
      {this.fromCurrency = "USD", this.toCurrency = "EUR"});

  @override
  @JsonKey()
  final String fromCurrency;
  @override
  @JsonKey()
  final String toCurrency;

  @override
  String toString() {
    return 'CurrencyConverterState(fromCurrency: $fromCurrency, toCurrency: $toCurrency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyConverterStateImpl &&
            (identical(other.fromCurrency, fromCurrency) ||
                other.fromCurrency == fromCurrency) &&
            (identical(other.toCurrency, toCurrency) ||
                other.toCurrency == toCurrency));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fromCurrency, toCurrency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyConverterStateImplCopyWith<_$CurrencyConverterStateImpl>
      get copyWith => __$$CurrencyConverterStateImplCopyWithImpl<
          _$CurrencyConverterStateImpl>(this, _$identity);
}

abstract class _CurrencyConverterState implements CurrencyConverterState {
  const factory _CurrencyConverterState(
      {final String fromCurrency,
      final String toCurrency}) = _$CurrencyConverterStateImpl;

  @override
  String get fromCurrency;
  @override
  String get toCurrency;
  @override
  @JsonKey(ignore: true)
  _$$CurrencyConverterStateImplCopyWith<_$CurrencyConverterStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
