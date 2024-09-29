// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_categories.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchCategories _$SearchCategoriesFromJson(Map<String, dynamic> json) {
  return _SearchCategories.fromJson(json);
}

/// @nodoc
mixin _$SearchCategories {
  AvailableCategories get results => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;

  /// Serializes this SearchCategories to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchCategoriesCopyWith<SearchCategories> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchCategoriesCopyWith<$Res> {
  factory $SearchCategoriesCopyWith(
          SearchCategories value, $Res Function(SearchCategories) then) =
      _$SearchCategoriesCopyWithImpl<$Res, SearchCategories>;
  @useResult
  $Res call({AvailableCategories results, String query});

  $AvailableCategoriesCopyWith<$Res> get results;
}

/// @nodoc
class _$SearchCategoriesCopyWithImpl<$Res, $Val extends SearchCategories>
    implements $SearchCategoriesCopyWith<$Res> {
  _$SearchCategoriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? query = null,
  }) {
    return _then(_value.copyWith(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as AvailableCategories,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailableCategoriesCopyWith<$Res> get results {
    return $AvailableCategoriesCopyWith<$Res>(_value.results, (value) {
      return _then(_value.copyWith(results: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchCategoriesImplCopyWith<$Res>
    implements $SearchCategoriesCopyWith<$Res> {
  factory _$$SearchCategoriesImplCopyWith(_$SearchCategoriesImpl value,
          $Res Function(_$SearchCategoriesImpl) then) =
      __$$SearchCategoriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AvailableCategories results, String query});

  @override
  $AvailableCategoriesCopyWith<$Res> get results;
}

/// @nodoc
class __$$SearchCategoriesImplCopyWithImpl<$Res>
    extends _$SearchCategoriesCopyWithImpl<$Res, _$SearchCategoriesImpl>
    implements _$$SearchCategoriesImplCopyWith<$Res> {
  __$$SearchCategoriesImplCopyWithImpl(_$SearchCategoriesImpl _value,
      $Res Function(_$SearchCategoriesImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? query = null,
  }) {
    return _then(_$SearchCategoriesImpl(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as AvailableCategories,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchCategoriesImpl implements _SearchCategories {
  const _$SearchCategoriesImpl({required this.results, required this.query});

  factory _$SearchCategoriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchCategoriesImplFromJson(json);

  @override
  final AvailableCategories results;
  @override
  final String query;

  @override
  String toString() {
    return 'SearchCategories(results: $results, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchCategoriesImpl &&
            (identical(other.results, results) || other.results == results) &&
            (identical(other.query, query) || other.query == query));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, results, query);

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchCategoriesImplCopyWith<_$SearchCategoriesImpl> get copyWith =>
      __$$SearchCategoriesImplCopyWithImpl<_$SearchCategoriesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchCategoriesImplToJson(
      this,
    );
  }
}

abstract class _SearchCategories implements SearchCategories {
  const factory _SearchCategories(
      {required final AvailableCategories results,
      required final String query}) = _$SearchCategoriesImpl;

  factory _SearchCategories.fromJson(Map<String, dynamic> json) =
      _$SearchCategoriesImpl.fromJson;

  @override
  AvailableCategories get results;
  @override
  String get query;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchCategoriesImplCopyWith<_$SearchCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
