// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
  List<Category> get categories;
  int get minAmount;
  int get maxAmount;
  String get note;

  /// Create a copy of SearchParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<SearchParameters> get copyWith =>
      _$SearchParametersCopyWithImpl<SearchParameters>(
          this as SearchParameters, _$identity);

  /// Serializes this SearchParameters to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchParameters &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(categories),
      minAmount,
      maxAmount,
      note);

  @override
  String toString() {
    return 'SearchParameters(categories: $categories, minAmount: $minAmount, maxAmount: $maxAmount, note: $note)';
  }
}

/// @nodoc
abstract mixin class $SearchParametersCopyWith<$Res> {
  factory $SearchParametersCopyWith(
          SearchParameters value, $Res Function(SearchParameters) _then) =
      _$SearchParametersCopyWithImpl;
  @useResult
  $Res call(
      {List<Category> categories, int minAmount, int maxAmount, String note});
}

/// @nodoc
class _$SearchParametersCopyWithImpl<$Res>
    implements $SearchParametersCopyWith<$Res> {
  _$SearchParametersCopyWithImpl(this._self, this._then);

  final SearchParameters _self;
  final $Res Function(SearchParameters) _then;

  /// Create a copy of SearchParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? minAmount = null,
    Object? maxAmount = null,
    Object? note = null,
  }) {
    return _then(_self.copyWith(
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      minAmount: null == minAmount
          ? _self.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as int,
      maxAmount: null == maxAmount
          ? _self.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SearchParameters implements SearchParameters {
  const _SearchParameters(
      {final List<Category> categories = const [],
      required this.minAmount,
      required this.maxAmount,
      required this.note})
      : _categories = categories;
  factory _SearchParameters.fromJson(Map<String, dynamic> json) =>
      _$SearchParametersFromJson(json);

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

  /// Create a copy of SearchParameters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchParametersCopyWith<_SearchParameters> get copyWith =>
      __$SearchParametersCopyWithImpl<_SearchParameters>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchParametersToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchParameters &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      minAmount,
      maxAmount,
      note);

  @override
  String toString() {
    return 'SearchParameters(categories: $categories, minAmount: $minAmount, maxAmount: $maxAmount, note: $note)';
  }
}

/// @nodoc
abstract mixin class _$SearchParametersCopyWith<$Res>
    implements $SearchParametersCopyWith<$Res> {
  factory _$SearchParametersCopyWith(
          _SearchParameters value, $Res Function(_SearchParameters) _then) =
      __$SearchParametersCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Category> categories, int minAmount, int maxAmount, String note});
}

/// @nodoc
class __$SearchParametersCopyWithImpl<$Res>
    implements _$SearchParametersCopyWith<$Res> {
  __$SearchParametersCopyWithImpl(this._self, this._then);

  final _SearchParameters _self;
  final $Res Function(_SearchParameters) _then;

  /// Create a copy of SearchParameters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
    Object? minAmount = null,
    Object? maxAmount = null,
    Object? note = null,
  }) {
    return _then(_SearchParameters(
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      minAmount: null == minAmount
          ? _self.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as int,
      maxAmount: null == maxAmount
          ? _self.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
