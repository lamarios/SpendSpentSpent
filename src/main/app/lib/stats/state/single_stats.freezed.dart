// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'single_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SingleStatsState {
  bool get open => throw _privateConstructorUsedError;
  bool get showGraph => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SingleStatsStateCopyWith<SingleStatsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingleStatsStateCopyWith<$Res> {
  factory $SingleStatsStateCopyWith(
          SingleStatsState value, $Res Function(SingleStatsState) then) =
      _$SingleStatsStateCopyWithImpl<$Res, SingleStatsState>;
  @useResult
  $Res call({bool open, bool showGraph});
}

/// @nodoc
class _$SingleStatsStateCopyWithImpl<$Res, $Val extends SingleStatsState>
    implements $SingleStatsStateCopyWith<$Res> {
  _$SingleStatsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? showGraph = null,
  }) {
    return _then(_value.copyWith(
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as bool,
      showGraph: null == showGraph
          ? _value.showGraph
          : showGraph // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SingleStatsStateImplCopyWith<$Res>
    implements $SingleStatsStateCopyWith<$Res> {
  factory _$$SingleStatsStateImplCopyWith(_$SingleStatsStateImpl value,
          $Res Function(_$SingleStatsStateImpl) then) =
      __$$SingleStatsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool open, bool showGraph});
}

/// @nodoc
class __$$SingleStatsStateImplCopyWithImpl<$Res>
    extends _$SingleStatsStateCopyWithImpl<$Res, _$SingleStatsStateImpl>
    implements _$$SingleStatsStateImplCopyWith<$Res> {
  __$$SingleStatsStateImplCopyWithImpl(_$SingleStatsStateImpl _value,
      $Res Function(_$SingleStatsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? showGraph = null,
  }) {
    return _then(_$SingleStatsStateImpl(
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as bool,
      showGraph: null == showGraph
          ? _value.showGraph
          : showGraph // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SingleStatsStateImpl implements _SingleStatsState {
  const _$SingleStatsStateImpl({this.open = false, this.showGraph = false});

  @override
  @JsonKey()
  final bool open;
  @override
  @JsonKey()
  final bool showGraph;

  @override
  String toString() {
    return 'SingleStatsState(open: $open, showGraph: $showGraph)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SingleStatsStateImpl &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.showGraph, showGraph) ||
                other.showGraph == showGraph));
  }

  @override
  int get hashCode => Object.hash(runtimeType, open, showGraph);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SingleStatsStateImplCopyWith<_$SingleStatsStateImpl> get copyWith =>
      __$$SingleStatsStateImplCopyWithImpl<_$SingleStatsStateImpl>(
          this, _$identity);
}

abstract class _SingleStatsState implements SingleStatsState {
  const factory _SingleStatsState({final bool open, final bool showGraph}) =
      _$SingleStatsStateImpl;

  @override
  bool get open;
  @override
  bool get showGraph;
  @override
  @JsonKey(ignore: true)
  _$$SingleStatsStateImplCopyWith<_$SingleStatsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
