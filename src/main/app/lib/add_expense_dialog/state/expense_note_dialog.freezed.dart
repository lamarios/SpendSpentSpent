// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_note_dialog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseNoteDialogState {
  bool get loading => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  List<String> get suggestions => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseNoteDialogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseNoteDialogStateCopyWith<ExpenseNoteDialogState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseNoteDialogStateCopyWith<$Res> {
  factory $ExpenseNoteDialogStateCopyWith(ExpenseNoteDialogState value,
          $Res Function(ExpenseNoteDialogState) then) =
      _$ExpenseNoteDialogStateCopyWithImpl<$Res, ExpenseNoteDialogState>;
  @useResult
  $Res call({bool loading, String note, List<String> suggestions});
}

/// @nodoc
class _$ExpenseNoteDialogStateCopyWithImpl<$Res,
        $Val extends ExpenseNoteDialogState>
    implements $ExpenseNoteDialogStateCopyWith<$Res> {
  _$ExpenseNoteDialogStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseNoteDialogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? note = null,
    Object? suggestions = null,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseNoteDialogStateImplCopyWith<$Res>
    implements $ExpenseNoteDialogStateCopyWith<$Res> {
  factory _$$ExpenseNoteDialogStateImplCopyWith(
          _$ExpenseNoteDialogStateImpl value,
          $Res Function(_$ExpenseNoteDialogStateImpl) then) =
      __$$ExpenseNoteDialogStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool loading, String note, List<String> suggestions});
}

/// @nodoc
class __$$ExpenseNoteDialogStateImplCopyWithImpl<$Res>
    extends _$ExpenseNoteDialogStateCopyWithImpl<$Res,
        _$ExpenseNoteDialogStateImpl>
    implements _$$ExpenseNoteDialogStateImplCopyWith<$Res> {
  __$$ExpenseNoteDialogStateImplCopyWithImpl(
      _$ExpenseNoteDialogStateImpl _value,
      $Res Function(_$ExpenseNoteDialogStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseNoteDialogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? note = null,
    Object? suggestions = null,
  }) {
    return _then(_$ExpenseNoteDialogStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ExpenseNoteDialogStateImpl implements _ExpenseNoteDialogState {
  const _$ExpenseNoteDialogStateImpl(
      {this.loading = false,
      this.note = '',
      final List<String> suggestions = const []})
      : _suggestions = suggestions;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final String note;
  final List<String> _suggestions;
  @override
  @JsonKey()
  List<String> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  String toString() {
    return 'ExpenseNoteDialogState(loading: $loading, note: $note, suggestions: $suggestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseNoteDialogStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, note,
      const DeepCollectionEquality().hash(_suggestions));

  /// Create a copy of ExpenseNoteDialogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseNoteDialogStateImplCopyWith<_$ExpenseNoteDialogStateImpl>
      get copyWith => __$$ExpenseNoteDialogStateImplCopyWithImpl<
          _$ExpenseNoteDialogStateImpl>(this, _$identity);
}

abstract class _ExpenseNoteDialogState implements ExpenseNoteDialogState {
  const factory _ExpenseNoteDialogState(
      {final bool loading,
      final String note,
      final List<String> suggestions}) = _$ExpenseNoteDialogStateImpl;

  @override
  bool get loading;
  @override
  String get note;
  @override
  List<String> get suggestions;

  /// Create a copy of ExpenseNoteDialogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseNoteDialogStateImplCopyWith<_$ExpenseNoteDialogStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
