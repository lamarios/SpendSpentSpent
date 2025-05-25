// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_categories.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailableCategories {
  List<String>? get shopping;
  List<String>? get transports;
  List<String>? get brands;
  List<String>? get hobbies;
  List<String>? get health;
  List<String>? get education;
  List<String>? get housing;
  List<String>? get tech;
  List<String>? get documents;

  /// Create a copy of AvailableCategories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AvailableCategoriesCopyWith<AvailableCategories> get copyWith =>
      _$AvailableCategoriesCopyWithImpl<AvailableCategories>(
          this as AvailableCategories, _$identity);

  /// Serializes this AvailableCategories to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailableCategories &&
            const DeepCollectionEquality().equals(other.shopping, shopping) &&
            const DeepCollectionEquality()
                .equals(other.transports, transports) &&
            const DeepCollectionEquality().equals(other.brands, brands) &&
            const DeepCollectionEquality().equals(other.hobbies, hobbies) &&
            const DeepCollectionEquality().equals(other.health, health) &&
            const DeepCollectionEquality().equals(other.education, education) &&
            const DeepCollectionEquality().equals(other.housing, housing) &&
            const DeepCollectionEquality().equals(other.tech, tech) &&
            const DeepCollectionEquality().equals(other.documents, documents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(shopping),
      const DeepCollectionEquality().hash(transports),
      const DeepCollectionEquality().hash(brands),
      const DeepCollectionEquality().hash(hobbies),
      const DeepCollectionEquality().hash(health),
      const DeepCollectionEquality().hash(education),
      const DeepCollectionEquality().hash(housing),
      const DeepCollectionEquality().hash(tech),
      const DeepCollectionEquality().hash(documents));

  @override
  String toString() {
    return 'AvailableCategories(shopping: $shopping, transports: $transports, brands: $brands, hobbies: $hobbies, health: $health, education: $education, housing: $housing, tech: $tech, documents: $documents)';
  }
}

/// @nodoc
abstract mixin class $AvailableCategoriesCopyWith<$Res> {
  factory $AvailableCategoriesCopyWith(
          AvailableCategories value, $Res Function(AvailableCategories) _then) =
      _$AvailableCategoriesCopyWithImpl;
  @useResult
  $Res call(
      {List<String>? shopping,
      List<String>? transports,
      List<String>? brands,
      List<String>? hobbies,
      List<String>? health,
      List<String>? education,
      List<String>? housing,
      List<String>? tech,
      List<String>? documents});
}

/// @nodoc
class _$AvailableCategoriesCopyWithImpl<$Res>
    implements $AvailableCategoriesCopyWith<$Res> {
  _$AvailableCategoriesCopyWithImpl(this._self, this._then);

  final AvailableCategories _self;
  final $Res Function(AvailableCategories) _then;

  /// Create a copy of AvailableCategories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopping = freezed,
    Object? transports = freezed,
    Object? brands = freezed,
    Object? hobbies = freezed,
    Object? health = freezed,
    Object? education = freezed,
    Object? housing = freezed,
    Object? tech = freezed,
    Object? documents = freezed,
  }) {
    return _then(_self.copyWith(
      shopping: freezed == shopping
          ? _self.shopping
          : shopping // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      transports: freezed == transports
          ? _self.transports
          : transports // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      brands: freezed == brands
          ? _self.brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hobbies: freezed == hobbies
          ? _self.hobbies
          : hobbies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      health: freezed == health
          ? _self.health
          : health // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      education: freezed == education
          ? _self.education
          : education // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      housing: freezed == housing
          ? _self.housing
          : housing // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tech: freezed == tech
          ? _self.tech
          : tech // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      documents: freezed == documents
          ? _self.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AvailableCategories implements AvailableCategories {
  const _AvailableCategories(
      {final List<String>? shopping = const [],
      final List<String>? transports = const [],
      final List<String>? brands = const [],
      final List<String>? hobbies = const [],
      final List<String>? health = const [],
      final List<String>? education = const [],
      final List<String>? housing = const [],
      final List<String>? tech = const [],
      final List<String>? documents = const []})
      : _shopping = shopping,
        _transports = transports,
        _brands = brands,
        _hobbies = hobbies,
        _health = health,
        _education = education,
        _housing = housing,
        _tech = tech,
        _documents = documents;
  factory _AvailableCategories.fromJson(Map<String, dynamic> json) =>
      _$AvailableCategoriesFromJson(json);

  final List<String>? _shopping;
  @override
  @JsonKey()
  List<String>? get shopping {
    final value = _shopping;
    if (value == null) return null;
    if (_shopping is EqualUnmodifiableListView) return _shopping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _transports;
  @override
  @JsonKey()
  List<String>? get transports {
    final value = _transports;
    if (value == null) return null;
    if (_transports is EqualUnmodifiableListView) return _transports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _brands;
  @override
  @JsonKey()
  List<String>? get brands {
    final value = _brands;
    if (value == null) return null;
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _hobbies;
  @override
  @JsonKey()
  List<String>? get hobbies {
    final value = _hobbies;
    if (value == null) return null;
    if (_hobbies is EqualUnmodifiableListView) return _hobbies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _health;
  @override
  @JsonKey()
  List<String>? get health {
    final value = _health;
    if (value == null) return null;
    if (_health is EqualUnmodifiableListView) return _health;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _education;
  @override
  @JsonKey()
  List<String>? get education {
    final value = _education;
    if (value == null) return null;
    if (_education is EqualUnmodifiableListView) return _education;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _housing;
  @override
  @JsonKey()
  List<String>? get housing {
    final value = _housing;
    if (value == null) return null;
    if (_housing is EqualUnmodifiableListView) return _housing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tech;
  @override
  @JsonKey()
  List<String>? get tech {
    final value = _tech;
    if (value == null) return null;
    if (_tech is EqualUnmodifiableListView) return _tech;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _documents;
  @override
  @JsonKey()
  List<String>? get documents {
    final value = _documents;
    if (value == null) return null;
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of AvailableCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AvailableCategoriesCopyWith<_AvailableCategories> get copyWith =>
      __$AvailableCategoriesCopyWithImpl<_AvailableCategories>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AvailableCategoriesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AvailableCategories &&
            const DeepCollectionEquality().equals(other._shopping, _shopping) &&
            const DeepCollectionEquality()
                .equals(other._transports, _transports) &&
            const DeepCollectionEquality().equals(other._brands, _brands) &&
            const DeepCollectionEquality().equals(other._hobbies, _hobbies) &&
            const DeepCollectionEquality().equals(other._health, _health) &&
            const DeepCollectionEquality()
                .equals(other._education, _education) &&
            const DeepCollectionEquality().equals(other._housing, _housing) &&
            const DeepCollectionEquality().equals(other._tech, _tech) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_shopping),
      const DeepCollectionEquality().hash(_transports),
      const DeepCollectionEquality().hash(_brands),
      const DeepCollectionEquality().hash(_hobbies),
      const DeepCollectionEquality().hash(_health),
      const DeepCollectionEquality().hash(_education),
      const DeepCollectionEquality().hash(_housing),
      const DeepCollectionEquality().hash(_tech),
      const DeepCollectionEquality().hash(_documents));

  @override
  String toString() {
    return 'AvailableCategories(shopping: $shopping, transports: $transports, brands: $brands, hobbies: $hobbies, health: $health, education: $education, housing: $housing, tech: $tech, documents: $documents)';
  }
}

/// @nodoc
abstract mixin class _$AvailableCategoriesCopyWith<$Res>
    implements $AvailableCategoriesCopyWith<$Res> {
  factory _$AvailableCategoriesCopyWith(_AvailableCategories value,
          $Res Function(_AvailableCategories) _then) =
      __$AvailableCategoriesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<String>? shopping,
      List<String>? transports,
      List<String>? brands,
      List<String>? hobbies,
      List<String>? health,
      List<String>? education,
      List<String>? housing,
      List<String>? tech,
      List<String>? documents});
}

/// @nodoc
class __$AvailableCategoriesCopyWithImpl<$Res>
    implements _$AvailableCategoriesCopyWith<$Res> {
  __$AvailableCategoriesCopyWithImpl(this._self, this._then);

  final _AvailableCategories _self;
  final $Res Function(_AvailableCategories) _then;

  /// Create a copy of AvailableCategories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? shopping = freezed,
    Object? transports = freezed,
    Object? brands = freezed,
    Object? hobbies = freezed,
    Object? health = freezed,
    Object? education = freezed,
    Object? housing = freezed,
    Object? tech = freezed,
    Object? documents = freezed,
  }) {
    return _then(_AvailableCategories(
      shopping: freezed == shopping
          ? _self._shopping
          : shopping // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      transports: freezed == transports
          ? _self._transports
          : transports // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      brands: freezed == brands
          ? _self._brands
          : brands // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hobbies: freezed == hobbies
          ? _self._hobbies
          : hobbies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      health: freezed == health
          ? _self._health
          : health // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      education: freezed == education
          ? _self._education
          : education // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      housing: freezed == housing
          ? _self._housing
          : housing // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tech: freezed == tech
          ? _self._tech
          : tech // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      documents: freezed == documents
          ? _self._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on
