// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchParameters _$SearchParametersFromJson(Map<String, dynamic> json) {
  return _SearchParameters.fromJson(json);
}

/// @nodoc
mixin _$SearchParameters {
  List<Category> get categories => throw _privateConstructorUsedError;
  int get minAmount => throw _privateConstructorUsedError;
  int get maxAmount => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchParametersCopyWith<SearchParameters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchParametersCopyWith<$Res> {
  factory $SearchParametersCopyWith(
          SearchParameters value, $Res Function(SearchParameters) then) =
      _$SearchParametersCopyWithImpl<$Res, SearchParameters>;
  @useResult
  $Res call(
      {List<Category> categories, int minAmount, int maxAmount, String note});
}

/// @nodoc
class _$SearchParametersCopyWithImpl<$Res, $Val extends SearchParameters>
    implements $SearchParametersCopyWith<$Res> {
  _$SearchParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? minAmount = null,
    Object? maxAmount = null,
    Object? note = null,
  }) {
    return _then(_value.copyWith(
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as int,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchParametersImplCopyWith<$Res>
    implements $SearchParametersCopyWith<$Res> {
  factory _$$SearchParametersImplCopyWith(_$SearchParametersImpl value,
          $Res Function(_$SearchParametersImpl) then) =
      __$$SearchParametersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Category> categories, int minAmount, int maxAmount, String note});
}

/// @nodoc
class __$$SearchParametersImplCopyWithImpl<$Res>
    extends _$SearchParametersCopyWithImpl<$Res, _$SearchParametersImpl>
    implements _$$SearchParametersImplCopyWith<$Res> {
  __$$SearchParametersImplCopyWithImpl(_$SearchParametersImpl _value,
      $Res Function(_$SearchParametersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? minAmount = null,
    Object? maxAmount = null,
    Object? note = null,
  }) {
    return _then(_$SearchParametersImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as int,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchParametersImpl implements _SearchParameters {
  const _$SearchParametersImpl(
      {final List<Category> categories = const [],
      required this.minAmount,
      required this.maxAmount,
      required this.note})
      : _categories = categories;

  factory _$SearchParametersImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchParametersImplFromJson(json);

  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final int minAmount;
  @override
  final int maxAmount;
  @override
  final String note;

  @override
  String toString() {
    return 'SearchParameters(categories: $categories, minAmount: $minAmount, maxAmount: $maxAmount, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchParametersImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      minAmount,
      maxAmount,
      note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchParametersImplCopyWith<_$SearchParametersImpl> get copyWith =>
      __$$SearchParametersImplCopyWithImpl<_$SearchParametersImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchParametersImplToJson(
      this,
    );
  }
}

abstract class _SearchParameters implements SearchParameters {
  const factory _SearchParameters(
      {final List<Category> categories,
      required final int minAmount,
      required final int maxAmount,
      required final String note}) = _$SearchParametersImpl;

  factory _SearchParameters.fromJson(Map<String, dynamic> json) =
      _$SearchParametersImpl.fromJson;

  @override
  List<Category> get categories;
  @override
  int get minAmount;
  @override
  int get maxAmount;
  @override
  String get note;
  @override
  @JsonKey(ignore: true)
  _$$SearchParametersImplCopyWith<_$SearchParametersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
