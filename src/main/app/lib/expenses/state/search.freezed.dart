// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchState {
  SearchParameters get searchParametersBounds;
  SearchParameters get searchParameters;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchStateCopyWith<SearchState> get copyWith =>
      _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchState &&
            (identical(other.searchParametersBounds, searchParametersBounds) ||
                other.searchParametersBounds == searchParametersBounds) &&
            (identical(other.searchParameters, searchParameters) ||
                other.searchParameters == searchParameters));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, searchParametersBounds, searchParameters);

  @override
  String toString() {
    return 'SearchState(searchParametersBounds: $searchParametersBounds, searchParameters: $searchParameters)';
  }
}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) _then) =
      _$SearchStateCopyWithImpl;
  @useResult
  $Res call(
      {SearchParameters searchParametersBounds,
      SearchParameters searchParameters});

  $SearchParametersCopyWith<$Res> get searchParametersBounds;
  $SearchParametersCopyWith<$Res> get searchParameters;
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res> implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchParametersBounds = null,
    Object? searchParameters = null,
  }) {
    return _then(_self.copyWith(
      searchParametersBounds: null == searchParametersBounds
          ? _self.searchParametersBounds
          : searchParametersBounds // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
      searchParameters: null == searchParameters
          ? _self.searchParameters
          : searchParameters // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
    ));
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<$Res> get searchParametersBounds {
    return $SearchParametersCopyWith<$Res>(_self.searchParametersBounds,
        (value) {
      return _then(_self.copyWith(searchParametersBounds: value));
    });
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<$Res> get searchParameters {
    return $SearchParametersCopyWith<$Res>(_self.searchParameters, (value) {
      return _then(_self.copyWith(searchParameters: value));
    });
  }
}

/// @nodoc

class _SearchState implements SearchState {
  const _SearchState(
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

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchStateCopyWith<_SearchState> get copyWith =>
      __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchState &&
            (identical(other.searchParametersBounds, searchParametersBounds) ||
                other.searchParametersBounds == searchParametersBounds) &&
            (identical(other.searchParameters, searchParameters) ||
                other.searchParameters == searchParameters));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, searchParametersBounds, searchParameters);

  @override
  String toString() {
    return 'SearchState(searchParametersBounds: $searchParametersBounds, searchParameters: $searchParameters)';
  }
}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(
          _SearchState value, $Res Function(_SearchState) _then) =
      __$SearchStateCopyWithImpl;
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
class __$SearchStateCopyWithImpl<$Res> implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? searchParametersBounds = null,
    Object? searchParameters = null,
  }) {
    return _then(_SearchState(
      searchParametersBounds: null == searchParametersBounds
          ? _self.searchParametersBounds
          : searchParametersBounds // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
      searchParameters: null == searchParameters
          ? _self.searchParameters
          : searchParameters // ignore: cast_nullable_to_non_nullable
              as SearchParameters,
    ));
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<$Res> get searchParametersBounds {
    return $SearchParametersCopyWith<$Res>(_self.searchParametersBounds,
        (value) {
      return _then(_self.copyWith(searchParametersBounds: value));
    });
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchParametersCopyWith<$Res> get searchParameters {
    return $SearchParametersCopyWith<$Res>(_self.searchParameters, (value) {
      return _then(_self.copyWith(searchParameters: value));
    });
  }
}

// dart format on
