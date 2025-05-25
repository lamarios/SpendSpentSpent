// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {
  String get date;
  double get amount;
  double? get latitude;
  double? get longitude;
  String? get note;
  int get type;
  int? get timestamp;
  bool get income;
  Category get category;
  int? get id;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseCopyWith<Expense> get copyWith =>
      _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Expense &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, amount, latitude,
      longitude, note, type, timestamp, income, category, id);

  @override
  String toString() {
    return 'Expense(date: $date, amount: $amount, latitude: $latitude, longitude: $longitude, note: $note, type: $type, timestamp: $timestamp, income: $income, category: $category, id: $id)';
  }
}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) =
      _$ExpenseCopyWithImpl;
  @useResult
  $Res call(
      {String date,
      double amount,
      double? latitude,
      double? longitude,
      String? note,
      int type,
      int? timestamp,
      bool income,
      Category category,
      int? id});

  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res> implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? note = freezed,
    Object? type = null,
    Object? timestamp = freezed,
    Object? income = null,
    Object? category = null,
    Object? id = freezed,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: freezed == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      income: null == income
          ? _self.income
          : income // ignore: cast_nullable_to_non_nullable
              as bool,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_self.category, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Expense implements Expense {
  const _Expense(
      {required this.date,
      required this.amount,
      this.latitude,
      this.longitude,
      this.note,
      this.type = 1,
      this.timestamp,
      this.income = false,
      required this.category,
      this.id});
  factory _Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  @override
  final String date;
  @override
  final double amount;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? note;
  @override
  @JsonKey()
  final int type;
  @override
  final int? timestamp;
  @override
  @JsonKey()
  final bool income;
  @override
  final Category category;
  @override
  final int? id;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseCopyWith<_Expense> get copyWith =>
      __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Expense &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, amount, latitude,
      longitude, note, type, timestamp, income, category, id);

  @override
  String toString() {
    return 'Expense(date: $date, amount: $amount, latitude: $latitude, longitude: $longitude, note: $note, type: $type, timestamp: $timestamp, income: $income, category: $category, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) =
      __$ExpenseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String date,
      double amount,
      double? latitude,
      double? longitude,
      String? note,
      int type,
      int? timestamp,
      bool income,
      Category category,
      int? id});

  @override
  $CategoryCopyWith<$Res> get category;
}

/// @nodoc
class __$ExpenseCopyWithImpl<$Res> implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? note = freezed,
    Object? type = null,
    Object? timestamp = freezed,
    Object? income = null,
    Object? category = null,
    Object? id = freezed,
  }) {
    return _then(_Expense(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: freezed == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      income: null == income
          ? _self.income
          : income // ignore: cast_nullable_to_non_nullable
              as bool,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res> get category {
    return $CategoryCopyWith<$Res>(_self.category, (value) {
      return _then(_self.copyWith(category: value));
    });
  }
}

// dart format on
