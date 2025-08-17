// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_categories.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchCategories {
  AvailableCategories get results;
  String get query;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchCategoriesCopyWith<SearchCategories> get copyWith =>
      _$SearchCategoriesCopyWithImpl<SearchCategories>(
          this as SearchCategories, _$identity);

  /// Serializes this SearchCategories to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchCategories &&
            (identical(other.results, results) || other.results == results) &&
            (identical(other.query, query) || other.query == query));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, results, query);

  @override
  String toString() {
    return 'SearchCategories(results: $results, query: $query)';
  }
}

/// @nodoc
abstract mixin class $SearchCategoriesCopyWith<$Res> {
  factory $SearchCategoriesCopyWith(
          SearchCategories value, $Res Function(SearchCategories) _then) =
      _$SearchCategoriesCopyWithImpl;
  @useResult
  $Res call({AvailableCategories results, String query});

  $AvailableCategoriesCopyWith<$Res> get results;
}

/// @nodoc
class _$SearchCategoriesCopyWithImpl<$Res>
    implements $SearchCategoriesCopyWith<$Res> {
  _$SearchCategoriesCopyWithImpl(this._self, this._then);

  final SearchCategories _self;
  final $Res Function(SearchCategories) _then;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? query = null,
  }) {
    return _then(_self.copyWith(
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as AvailableCategories,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailableCategoriesCopyWith<$Res> get results {
    return $AvailableCategoriesCopyWith<$Res>(_self.results, (value) {
      return _then(_self.copyWith(results: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SearchCategories].
extension SearchCategoriesPatterns on SearchCategories {
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
    TResult Function(_SearchCategories value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchCategories() when $default != null:
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
    TResult Function(_SearchCategories value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchCategories():
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
    TResult? Function(_SearchCategories value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchCategories() when $default != null:
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
    TResult Function(AvailableCategories results, String query)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchCategories() when $default != null:
        return $default(_that.results, _that.query);
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
    TResult Function(AvailableCategories results, String query) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchCategories():
        return $default(_that.results, _that.query);
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
    TResult? Function(AvailableCategories results, String query)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchCategories() when $default != null:
        return $default(_that.results, _that.query);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SearchCategories implements SearchCategories {
  const _SearchCategories({required this.results, required this.query});
  factory _SearchCategories.fromJson(Map<String, dynamic> json) =>
      _$SearchCategoriesFromJson(json);

  @override
  final AvailableCategories results;
  @override
  final String query;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchCategoriesCopyWith<_SearchCategories> get copyWith =>
      __$SearchCategoriesCopyWithImpl<_SearchCategories>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchCategoriesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchCategories &&
            (identical(other.results, results) || other.results == results) &&
            (identical(other.query, query) || other.query == query));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, results, query);

  @override
  String toString() {
    return 'SearchCategories(results: $results, query: $query)';
  }
}

/// @nodoc
abstract mixin class _$SearchCategoriesCopyWith<$Res>
    implements $SearchCategoriesCopyWith<$Res> {
  factory _$SearchCategoriesCopyWith(
          _SearchCategories value, $Res Function(_SearchCategories) _then) =
      __$SearchCategoriesCopyWithImpl;
  @override
  @useResult
  $Res call({AvailableCategories results, String query});

  @override
  $AvailableCategoriesCopyWith<$Res> get results;
}

/// @nodoc
class __$SearchCategoriesCopyWithImpl<$Res>
    implements _$SearchCategoriesCopyWith<$Res> {
  __$SearchCategoriesCopyWithImpl(this._self, this._then);

  final _SearchCategories _self;
  final $Res Function(_SearchCategories) _then;

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? results = null,
    Object? query = null,
  }) {
    return _then(_SearchCategories(
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as AvailableCategories,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of SearchCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailableCategoriesCopyWith<$Res> get results {
    return $AvailableCategoriesCopyWith<$Res>(_self.results, (value) {
      return _then(_self.copyWith(results: value));
    });
  }
}

// dart format on
