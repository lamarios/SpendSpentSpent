// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchState {
  SearchParameters get searchParametersBounds =>
      throw _privateConstructorUsedError;
  SearchParameters get searchParameters => throw _privateConstructorUsedError;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res, SearchState>;
  @useResult
  $Res call(
      {SearchParameters searchParametersBounds,
      SearchParameters searchParameters});

  $SearchParametersCopyWith<$Res> get searchParametersBounds;
  $SearchParametersCopyWith<$Res> get searchParameters;
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchParametersBounds = null,
    Object? searchParameters = null,
  }) {
    return _then(_value.copyWith(
      searchParametersBounds: null == searchParametersBounds
          ? _value.searchParametersBounds
          : searchParametersBounds // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
      searchParameters: null == searchParameters
          ? _value.searchParameters
          : searchParameters // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
    ) as $Val);
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<$Res> get searchParametersBounds {
    return $SearchParametersCopyWith<$Res>(_value.searchParametersBounds,
        (value) {
      return _then(_value.copyWith(searchParametersBounds: value) as $Val);
    });
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<$Res> get searchParameters {
    return $SearchParametersCopyWith<$Res>(_value.searchParameters, (value) {
      return _then(_value.copyWith(searchParameters: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchStateImplCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$SearchStateImplCopyWith(
          _$SearchStateImpl value, $Res Function(_$SearchStateImpl) then) =
      __$$SearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SearchParameters searchParametersBounds,
      SearchParameters searchParameters});

  @override
  $SearchParametersCopyWith<$Res> get searchParametersBounds;
  @override
  $SearchParametersCopyWith<$Res> get searchParameters;
}

/// @nodoc
class __$$SearchStateImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateImpl>
    implements _$$SearchStateImplCopyWith<$Res> {
  __$$SearchStateImplCopyWithImpl(
      _$SearchStateImpl _value, $Res Function(_$SearchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchParametersBounds = null,
    Object? searchParameters = null,
  }) {
    return _then(_$SearchStateImpl(
      searchParametersBounds: null == searchParametersBounds
          ? _value.searchParametersBounds
          : searchParametersBounds // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
      searchParameters: null == searchParameters
          ? _value.searchParameters
          : searchParameters // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
    ));
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  const _$SearchStateImpl(
      {this.searchParametersBounds = const SearchParameters(
          categories: [], maxAmount: 0, minAmount: 0, note: ""),
      this.searchParameters = const SearchParameters(
          categories: [], maxAmount: 0, minAmount: 0, note: "")});

  @override
  @JsonKey()
  final SearchParameters searchParametersBounds;
  @override
  @JsonKey()
  final SearchParameters searchParameters;

  @override
  String toString() {
    return 'SearchState(searchParametersBounds: $searchParametersBounds, searchParameters: $searchParameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateImpl &&
            (identical(other.searchParametersBounds, searchParametersBounds) ||
                other.searchParametersBounds == searchParametersBounds) &&
            (identical(other.searchParameters, searchParameters) ||
                other.searchParameters == searchParameters));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, searchParametersBounds, searchParameters);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      __$$SearchStateImplCopyWithImpl<_$SearchStateImpl>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  const factory _SearchState(
      {final SearchParameters searchParametersBounds,
      final SearchParameters searchParameters}) = _$SearchStateImpl;

  @override
  SearchParameters get searchParametersBounds;
  @override
  SearchParameters get searchParameters;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
